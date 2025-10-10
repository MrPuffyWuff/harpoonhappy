extends Node3D

class_name Rope

const RED_CIRCLE = preload("res://SCENES/MAP/OBJECTS/red_circle.tscn")
@onready var path_3d := $Path3D
@onready var path_follow := $Path3D/PathFollow3D

var segments : int = 0
var start : Vector3 = Vector3(0,0,0)
var end : Vector3 = Vector3(0,-10,0)
var start_anchor : Node3D
var end_anchor : Node3D
@export var final_rope_mass : float = 3
@export var min_rope_mass : float = 3

var legnth : float

func _ready() -> void:
	#Make path point to object
	var rope_curve := Curve3D.new()
	rope_curve.add_point(start)
	rope_curve.add_point(end)
	path_3d.curve = rope_curve
	legnth = (start - end).length()
	segments = int(legnth/2)
	var rotation = Basis.looking_at(end - start)
	#Generate Joints and Rigid bodies
	var points = [start_anchor]
	for i in range(0, 2*segments + 1):
		var percent = i/float(2*segments)
		path_follow.progress_ratio = percent
		if i % 2 == 0:
			var joint := PinJoint3D.new()
			joint.position = path_follow.position
			joint.transform.basis = rotation
			#joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_DAMPING, 0.7)
			#joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_DAMPING, 0.7)
			#joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_DAMPING, 0.7)
			#joint.set_param(PinJoint3D.PARAM_BIAS, 0.7)
			#joint.add_child(make_mesh())
			var dot = RED_CIRCLE.instantiate()
			joint.add_child(dot)
			points.append(joint)
		else:
			var body := make_rigid_body(rotation)
			body.mass = lerp(min_rope_mass, final_rope_mass, percent)
			#print(body.mass)
			points.append(body)
	points.append(end_anchor)
	#Load in points
	for i in range(1, len(points) - 1):
		add_child(points[i])
	for i in range(1, len(points) - 1):
		if i % 2 == 1 and i < len(points) - 1:
			var joint : Joint3D = points[i]
			joint.node_a = points[i-1].get_path()
			joint.node_b = points[i+1].get_path()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_rigid_body(rotation_point : Basis) -> RigidBody3D:
	var body := RigidBody3D.new()
	body.position = path_follow.position
	body.transform.basis = rotation_point.rotated(Vector3(1,0,0),PI/2)
	#body.axis_lock_angular_x = false
	#body.axis_lock_angular_y = false
	#body.axis_lock_angular_z = true
	body.mass = 10
	#body.angular_damp = 1
	#TEMP - Mesh for debugging sake
	var mesh_instance : MeshInstance3D = make_mesh(legnth/segments)
	body.add_child(mesh_instance)
	#The Collision Hit Box
	var colliding_box := CollisionShape3D.new()
	var collision_shape := CapsuleShape3D.new()
	collision_shape.height = legnth/segments/2#0.5 bc I'm scared
	collision_shape.radius = 0.25
	colliding_box.shape = collision_shape
	body.add_child(colliding_box)
	return body

func make_mesh(height : float = 1) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.height = height
	mesh.radial_segments = 8
	mesh.radius = 0.25
	mesh_instance.mesh = mesh
	return mesh_instance
