extends Node3D

@export var prop_rotation_perframe : float = 0.3
var current_prop_rotate : float = 1
var timer : float = 0
@onready var parent = get_parent()
@export var MIN_ROTATION : Vector3 = Vector3(-0.5,0.0,-0.5)
@export var MAX_ROTATION : Vector3 = Vector3(0.5,0.0,0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
func tilt_body(current_dir : Vector3):
	#This took embarrisingly long, but basically:
	#The rotation goal is decided by the current percentage of max_speed
	var z_goal = -0.1 * (current_dir.x/parent.SPEED * 5)
	var x_goal = 0.1 * (current_dir.z/parent.SPEED * 5)
	#When "lerping" toward the goal rotation, the increment is delta based
	#The increment should be POSITIVE. Even if 0 -> -x. Negative increments go AWAY
	rotation = rotation.move_toward(Vector3(x_goal, 0, z_goal), 1 * get_process_delta_time())

func rotate_propellers(is_on_ground : bool):
	#Spin it if not on ground. Delta based
	current_prop_rotate = move_toward(
		current_prop_rotate,prop_rotation_perframe * float(not is_on_ground) * get_process_delta_time(),
		1
		)
	rotate_propellers_helper($Propellers/Propeller)
	rotate_propellers_helper($Propellers/Propeller2)

func rotate_propellers_helper(propeller : Node3D):
	propeller.rotate_y(current_prop_rotate)

func rotate_wheels():
	#I think this is the only Lerp in all of my code...
	#move_toward is just better for dynamic animations imo
	#Somewhat unpolished, but it just spins 100% of the time
	for child in ($Wheels.get_children()):
		var point : Node3D = child.get_child(1)
		point.rotation.z = lerp(0, 1, timer) * -2*PI

func close_trapdoor(is_open : bool):
	#Delta based rotation
	for child in $Trapdoor.get_children():
		child.rotation.z = move_toward(child.rotation.z, int(is_open) * -PI/2.0, 10 * get_process_delta_time())
