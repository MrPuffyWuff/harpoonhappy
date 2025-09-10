extends Control

@onready var debug_info : Label = $DebugPanel/DebugInfo
var debug_info_visible : bool = false
@onready var player : Player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if debug_info_visible and player != null:
		update_debug_info()

func update_debug_info():
	#Justs grab info and displays it.
	var info : Array[String] = []
	info.append("Debug Information")
	info.append("---GAME INFO")
	info.append("Engine Time Scale: " + str(Engine.time_scale))
	info.append("FPS: " + str(Engine.get_frames_per_second()))
	info.append("Delta: " + str(get_process_delta_time()))
	info.append("---PLAYER INFO")
	info.append("Position: " + str(player.position))
	info.append("Velocity: " + str(player.velocity))
	info.append("Speed: " + str(player.velocity.length()))
	info.append("Player Rotation: " + str(player.rotation))
	info.append("Body Rotation: " + str(player.body.rotation))
	info.append("Input Dir: " + str(player.pre_trans_dir))
	
	debug_info.text = "\n".join(info)

func _input(event: InputEvent) -> void:
	#f3 -> Toggles debug information
	if Input.is_action_just_pressed("debug_toggle"):
		debug_info_visible = not debug_info_visible
		$DebugPanel.visible = debug_info_visible
	#ESC -> Resets the player position
	if Input.is_action_just_pressed("ui_settings_toggle"):
		player.reset()
