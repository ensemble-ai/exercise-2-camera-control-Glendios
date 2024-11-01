class_name SpeedPushCamera
extends CameraControllerBase

@export var push_ratio: float = 0.4
@export var pushbox_top_left: Vector2 = Vector2(-10, 6)
@export var pushbox_bottom_right: Vector2 = Vector2(10, -6)
@export var speedup_zone_top_left: Vector2 = Vector2(-4, 4)
@export var speedup_zone_bottom_right: Vector2 = Vector2(4, -4)

var push_left = pushbox_top_left.x
var push_top = pushbox_top_left.y
var push_right = pushbox_bottom_right.x
var push_bottom = pushbox_bottom_right.y

var speedup_left = speedup_zone_top_left.x
var speedup_top = speedup_zone_top_left.y
var speedup_right = speedup_zone_bottom_right.x
var speedup_bottom = speedup_zone_bottom_right.y

func _ready() -> void:
	# Center camera on the target's initial position
	if target:
		position = target.position

func _process(delta: float) -> void:
	if not current or not target:
		return
	
	if draw_camera_logic:
		draw_logic()

	# Choose the camera speed based on the player's input (e.g., boost mode)
	var camera_speed = target.BASE_SPEED
	if Input.is_action_pressed("ui_accept"):
		camera_speed = target.HYPER_SPEED

	var camera_pos = global_position
	var target_pos = target.global_position

	# Adjust camera position if the target is near the pushbox boundaries
	handle_pushbox_boundary(camera_pos, target_pos)
	
	# Calculate the horizontal and vertical distances between camera and target
	var x_distance = target_pos.x - camera_pos.x
	var z_distance = target_pos.z - camera_pos.z
	
	# Move the camera based on its position in the speedup zone relative to the pushbox
	handle_speedup_zone(x_distance, z_distance, camera_speed, delta)

	super(delta)

# Adjust the camera position when the target nears the outer pushbox boundaries
func handle_pushbox_boundary(camera_pos: Vector3, target_pos: Vector3) -> void:
	# Left edge of the pushbox
	var left_gap = (target_pos.x - target.WIDTH / 2.0) - (camera_pos.x + push_left)
	if left_gap < 0:
		global_position.x += left_gap

	# Right edge of the pushbox
	var right_gap = (target_pos.x + target.WIDTH / 2.0) - (camera_pos.x + push_right)
	if right_gap > 0:
		global_position.x += right_gap

	# Top edge of the pushbox
	var top_gap = (target_pos.z + target.HEIGHT / 2.0) - (camera_pos.z + push_top)
	if top_gap > 0:
		global_position.z += top_gap

	# Bottom edge of the pushbox
	var bottom_gap = (target_pos.z - target.HEIGHT / 2.0) - (camera_pos.z + push_bottom)
	if bottom_gap < 0:
		global_position.z += bottom_gap

# Calculate the camera movement based on the target's position within the speedup zone
func handle_speedup_zone(x_distance: float, z_distance: float, speed: float, delta: float) -> void:
	# Camera moves horizontally if target is within speedup bounds but outside the pushbox
	if x_distance > speedup_right and x_distance < push_right and target.velocity.x > 0:
		global_position.x += speed * push_ratio * delta
	elif x_distance < speedup_left and x_distance > push_left and target.velocity.x < 0:
		global_position.x -= speed * push_ratio * delta

	# Camera moves vertically if target is within speedup bounds but outside the pushbox
	if z_distance > speedup_top and z_distance < push_top and target.velocity.z < 0:
		global_position.z -= speed * push_ratio * delta
	elif z_distance < speedup_bottom and z_distance > push_bottom and target.velocity.z > 0:
		global_position.z += speed * push_ratio * delta

# Draw the pushbox and speedup zone boundaries
func draw_logic() -> void:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = ORMMaterial3D.new()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw outer pushbox borders
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_top))

	# Draw inner speedup zone borders
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))

	immediate_mesh.surface_end()
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame
	await get_tree().process_frame
	mesh_instance.queue_free()
