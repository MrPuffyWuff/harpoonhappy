extends CharacterBody3D
class_name Player

const WEAPON = preload("res://SCENES/PLAYER/WEAPON/weapon.tscn")
const RED_CIRCLE = preload("res://SCENES/MAP/OBJECTS/red_circle.tscn")

@export var SPEED : float = 20.0
@export var VEL_STEP : float = 0.2
@export var ROTATION_SPEED : float = 1
@onready var body = $PlayerBodyHelicopter

@onready var camera : Camera3D = $CameraPivot/SpringArm3D/Camera3D
var camera_enabled = true
@export var CAMERA_TURN_SPEED : float = 0.01
@export var Y_CAM_RANGE_CLAMP : Vector2 = Vector2(-0.8,0.8)
@export var CAMERA_ZOOM_SPEED : float = 0.5
@export var CAMERA_RANGE_CLAMP : Vector2 = Vector2(5,20)

var pre_trans_dir : Vector3

@onready var rope_point : Node3D = $RopePoint

func _ready() -> void:
	#NOTE Check if this is a pointer, that could be bad if so
	pre_trans_dir = velocity

func _physics_process(delta: float) -> void:
	#Self explanitory
	handle_xyz_input(delta)
	if Engine.time_scale == 0.1: handle_weapon_ray()
	handle_time_state()
	move_and_slide()
	handle_body_state()

func handle_time_state():
	#Toggle Engine.time_scale between 1 and 0.1. Scales delta values GLOBALLY
	#Therefore, anything delta controled can be "slowed"
	#For the sake of aiming the harpoon, we need to disable the camera
	#Also allow mouse movement to select target
	if Input.is_action_pressed("player_flip_time_state"):
		Engine.time_scale = 0.1
		camera_enabled = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Engine.time_scale = 1
		camera_enabled = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func handle_weapon_ray():
	#Basically, it creates a normal vector with the origin at the camera and the end point
	# at where you clicked
	#Apparently the documentation says this should be handled in physics_process to avoid
	# locked states?? --Makes more sense after implementing the ray cast
	#https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	if Input.is_action_just_pressed("player_shoot_weapon"):
		#Get vector from camera to Mouse poz
		var cam_normal_vector : Vector3 = $CameraPivot/SpringArm3D/Camera3D.project_ray_normal(get_viewport().get_mouse_position())
		#Given the vector form the camera, raycast the obj
		#This is so we can remap it onto the helicopter body
		var result = ray_cast(cam_normal_vector, 200)
		#if they clicked something
		if result:
			var instance = WEAPON.instantiate()
			instance.input_dir = (result["position"] - self.position).normalized()
			instance.position = self.position
			instance.player = self
			$"..".add_child(instance)

func ray_cast(cam_normal_vector : Vector3, length : float) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var origin = camera.global_position
	var query = PhysicsRayQueryParameters3D.create(origin, origin + cam_normal_vector * length)
	#query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	return result

func handle_body_state():
	#call all body functions with required inputs
	body.close_trapdoor(Input.is_action_pressed("player_trapdoor"))
	body.rotate_propellers(is_on_floor())
	body.tilt_body(pre_trans_dir)
	if not is_on_floor(): body.rotate_wheels()
	$CollisionShape3D.rotation = body.rotation

func handle_xyz_input(delta: float):
	var x_z_input : Vector2
	#Don't allow x z movement when on the grounnd
	if is_on_floor():
		x_z_input = Vector2(0,0)
	else:
		x_z_input = Input.get_vector("player_left", "player_right", "player_foward", "player_backward")
	#Create a direction vector (including the y-axis!!)
	var direction = Vector3(
			x_z_input.x,
			int(Input.is_action_pressed("player_ascend")) - int(Input.is_action_pressed("player_descend")),
			x_z_input.y
		).normalized()
	var transformed_dir : Vector3 = transform.basis * direction
	#Slowly "lerp" velocity towards the target velocity
	#Target velocity defined by 6 keys transformed into a Vector3
	velocity = velocity.move_toward(transformed_dir * SPEED, VEL_STEP)
	#pre_trans_dir is unaffected by rotation; without transform.basis
	#used to control rotation, as the body rotation is local.
	pre_trans_dir = pre_trans_dir.move_toward(direction * SPEED, VEL_STEP)
	rotate_object_local(Vector3(0,1,0),ROTATION_SPEED * x_z_input.x * x_z_input.y * delta)

func _input(event: InputEvent) -> void:
	#NOTE Camera Shenaniggans. DO NOT TRY TO COMPREHEND
	#Ok fine i'll try to make it comprehendable
	
	#All camera functions below
	if not camera_enabled:
		return
	if event is InputEventMouseMotion:
		#mouse_dir is the velocity basically. NOT POSITION (I made that mistake...)
		var mouse_dir : Vector2 = event.relative
		#Offset the Pivot. This helps lock the camera local rotation to face the helicopter
		$CameraPivot.rotation.x -= mouse_dir.y * CAMERA_TURN_SPEED
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x,Y_CAM_RANGE_CLAMP.x ,Y_CAM_RANGE_CLAMP.y)
		$CameraPivot.rotation.y -= mouse_dir.x * CAMERA_TURN_SPEED
		$CameraPivot.transform = $CameraPivot.transform.orthonormalized()
	elif event is InputEventMouseButton:
		#Zoom stuff
		if event.is_pressed():
			#Using a spring allows it to shrink upon contact with a CollisionShape
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				$CameraPivot/SpringArm3D.spring_length -= CAMERA_ZOOM_SPEED
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				$CameraPivot/SpringArm3D.spring_length += CAMERA_ZOOM_SPEED
			$CameraPivot/SpringArm3D.spring_length = clamp($CameraPivot/SpringArm3D.spring_length, CAMERA_RANGE_CLAMP.x, CAMERA_RANGE_CLAMP.y)

#For the purposes of the Rubric
func reset():
	position = Vector3(0,11,0)#ylvl10 is the height of the helipad
	rotation = Vector3.ZERO
	velocity = Vector3.ZERO
