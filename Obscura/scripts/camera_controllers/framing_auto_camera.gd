class_name HorizontalAutoCamera
extends CameraControllerBase

@export var top_left: Vector2 = Vector2(-6, -6)
@export var bottom_right: Vector2 = Vector2(6, 6)
@export var auto_scroll_speed: Vector3 = Vector3(3, 0, 0)
var frame_origin: Vector3

func _ready() -> void:
	frame_origin = position

func _process(delta: float) -> void:
	if not current:
		return

	# Update frame position for autoscrolling
	frame_origin += auto_scroll_speed * delta

	# Center camera within bounds
	position = frame_origin + Vector3(
		(top_left.x + bottom_right.x) / 2.0,
		0,
		(top_left.y + bottom_right.y) / 2.0
	)

	# Define edges based on frame_origin for clarity
	var left_edge = frame_origin.x + top_left.x
	var right_edge = frame_origin.x + bottom_right.x
	var top_edge = frame_origin.z + top_left.y
	var bottom_edge = frame_origin.z + bottom_right.y

	# Clamp target's X and Z position within defined boundaries
	target.position.x = clamp(
		target.position.x,
		left_edge + target.WIDTH / 2,
		right_edge - target.WIDTH / 2
	)
	target.position.z = clamp(
		target.position.z,
		top_edge + target.HEIGHT / 2,
		bottom_edge - target.HEIGHT / 2
	)

	# Draw bounding box if enabled
	if draw_camera_logic:
		draw_logic()

func draw_logic() -> void:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	# Remove box shadow for clarity
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	material.albedo_color = Color.WHITE

	# Draw bounding box edges
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Define corners of the box
	var top_left_corner = Vector3(top_left.x, 0, top_left.y)
	var top_right_corner = Vector3(bottom_right.x, 0, top_left.y)
	var bottom_right_corner = Vector3(bottom_right.x, 0, bottom_right.y)
	var bottom_left_corner = Vector3(top_left.x, 0, bottom_right.y)

	# Draw edges in a structured order: top, right, bottom, left
	immediate_mesh.surface_add_vertex(top_left_corner)
	immediate_mesh.surface_add_vertex(top_right_corner)
	immediate_mesh.surface_add_vertex(top_right_corner)
	immediate_mesh.surface_add_vertex(bottom_right_corner)
	immediate_mesh.surface_add_vertex(bottom_right_corner)
	immediate_mesh.surface_add_vertex(bottom_left_corner)
	immediate_mesh.surface_add_vertex(bottom_left_corner)
	immediate_mesh.surface_add_vertex(top_left_corner)

	immediate_mesh.surface_end()
	add_child(mesh_instance)
	
	# Position the mesh instance to align with the frame origin
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(frame_origin.x, target.global_position.y, frame_origin.z)

	await get_tree().process_frame
	mesh_instance.queue_free()
