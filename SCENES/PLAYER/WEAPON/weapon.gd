extends RigidBody3D

@onready var input_dir : Vector3
@export var SPEED : float = 100
@onready var Terrain = get_node("/root/Main/Game/Terrain")

var player : Player
const ROPE = preload("res://SCENES/PLAYER/WEAPON/rope.tscn")

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
		var pin_joint : Generic6DOFJoint3D = Generic6DOFJoint3D.new()
		pin_joint.node_a = self.get_path()
		pin_joint.node_b = body.get_path()
		add_child(pin_joint)
		make_rope()

func make_rope():
	var rope : Rope = ROPE.instantiate()
	rope.start = player.rope_point.position
	rope.end = self.global_position - player.global_position
	player.rope_point.add_child(rope)
