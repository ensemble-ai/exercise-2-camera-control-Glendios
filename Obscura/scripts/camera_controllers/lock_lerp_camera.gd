class_name LockLerpCamera
extends CameraControllerBase

@export var follow_speed: float
@export var catchup_speed: float
@export var leash_distance: float

func _ready() -> void:
	# Initialize camera position to target's position
	position.x = target.position.x
	position.z = target.position.z	

func _process(delta: float) -> void:
	if not current:
		return

	if draw_camera_logic:
		draw_logic()

	# Calculate the distance between the camera and the target
	var target_position = Vector3(target.position.x, 0, target.position.z)
	var position_difference = target_position - Vector3(position.x, 0, position.z)
	var distance = position_difference.length()

	# Determine camera speed based on player's state and leash distance
	var speed: float
	if distance < 0.1:
		speed = 0
	elif target.velocity == Vector3.ZERO:
		speed = catchup_speed
	elif distance > leash_distance:
		speed = target.velocity.length()
	else:
		speed = follow_speed

	# Update camera's position towards target with calculated speed
	var direction = position_difference.normalized()
	global_transform.origin += direction * speed * delta

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
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame
	await get_tree().process_frame
	mesh_instance.queue_free()
