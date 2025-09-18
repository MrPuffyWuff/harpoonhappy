extends RigidBody3D

@onready var input_dir : Vector3
@export var SPEED : float = 100
@onready var Terrain = get_node("/root/Main/Game/Terrain")

var player : Player
const ROPE = preload("res://SCENES/PLAYER/WEAPON/ROPE/rope.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = input_dir * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(linear_velocity)
	pass

func _on_body_entered(body: Node) -> void:
	if body.get_parent().name == "Objects":
		#"Glue" them together
		var joint : Generic6DOFJoint3D = Generic6DOFJoint3D.new()
		joint.node_a = self.get_path()
		joint.node_b = body.get_path()
		add_child(joint)
		make_rope()

func make_rope():
	var rope : Rope = ROPE.instantiate()
	rope.start = player.rope_point.position
	var to_obj_vector : Vector3 = self.global_position - player.global_position
	#Why inverse???? idk, magic?
	rope.end = player.basis.inverse() * to_obj_vector
	rope.start_anchor = player
	rope.end_anchor = self
	#Terrain.get_child(5).add_child(rope)
	player.rope_point.add_child(rope)
