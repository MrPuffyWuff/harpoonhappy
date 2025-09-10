extends Node3D

@onready var player : Player = $Player
@onready var gui =  $"../Gui"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.reset()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gui.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
