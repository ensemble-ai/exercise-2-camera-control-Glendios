class_name LerpSmoothCamera
extends CameraControllerBase

@export var follow_speed: float
@export var lead_speed: float = 15.0
@export var catchup_delay_duration: float = 0.5
@export var catchup_speed: float = 15.0
@export var leash_distance: float = 11.0

var time_since_movement: float = 0.0
var last_input_direction: Vector2 = Vector2.ZERO
var catchup_timer: Timer = null

func _ready() -> void:
	# Initialize camera position to target's position
	if target:
		position.x = target.position.x
		position.z = target.position.z
	
	# Initialize the catchup timer
	catchup_timer = Timer.new()
	catchup_timer.one_shot = true
	add_child(catchup_timer)

func _process(delta: float) -> void:
	if not current or not target:
		return

	if draw_camera_logic:
		draw_logic()

	# Determine input direction based on player's movement input
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).limit_length(1.0)

	# Track last input direction and reset timer if there's input
	if input_direction.length() > 0.1:
		last_input_direction = input_direction
		time_since_movement = 0.0
		catchup_timer.stop()  # Stop timer when moving
	else:
		time_since_movement += delta
		if not catchup_timer.is_stopped():
			catchup_timer.start(catchup_delay_duration)

	# Calculate the desired camera position
	var desired_position = position
	if input_direction.length() > 0.1:
		# Lead the camera in the input direction up to the leash distance
		var lead_position = target.position + Vector3(last_input_direction.x, 0, last_input_direction.y) * leash_distance
		desired_position = lead_position
	elif time_since_movement >= catchup_delay_duration and catchup_timer.is_stopped():
		# Catch up to the target if it's been idle for the delay duration
		desired_position = target.position

	# Calculate direction to move towards the desired position
	var direction_to_desired = desired_position - position
	direction_to_desired.y = 0  # Only adjust in the x and z directions

	# Choose speed based on whether the player is actively moving or not
	var speed = lead_speed if input_direction.length() > 0.1 else catchup_speed

	# Move towards the desired position with calculated speed
	if direction_to_desired.length() > 0.01:
		var movement = direction_to_desired.normalized() * speed * delta
		if movement.length() > direction_to_desired.length():
			movement = direction_to_desired  # Prevent overshooting
		position += movement

	# Enforce leash distance by clamping the camera position if it's too far from target
	var distance_to_target = target.position.distance_to(position)
	if distance_to_target > leash_distance:
		var leash_direction = (target.position - position).normalized()
		position = target.position - (leash_direction * leash_distance)
		position.y = target.position.y + dist_above_target

func draw_logic() -> void:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = ORMMaterial3D.new()

	# Configure material and add to mesh
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Draw a cross in the center of the screen for camera visualization
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
	# Horizontal line
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))

	immediate_mesh.surface_end()
	add_child(mesh_instance)

	# Position the cross at camera's height level with target
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(position.x, target.global_position.y, position.z)

	# Free the mesh after one frame
	await get_tree().process_frame
	mesh_instance.queue_free()
