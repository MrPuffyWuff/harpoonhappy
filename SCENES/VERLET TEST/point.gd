extends Node2D

class_name Point

var prev_position : Vector2

func _init(position : Vector2, old_position : Vector2) -> void:
	self.position = position
	self.prev_position = old_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
