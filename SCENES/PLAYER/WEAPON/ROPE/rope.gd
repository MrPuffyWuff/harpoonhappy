extends Node3D

class_name Rope

@onready var path_3d := $Path3D

var segments : int = 10
var start : Vector3 = Vector3(0,0,0)
var end : Vector3 = Vector3(0,-10,0)
var start_anchor : NodePath
var end_anchor : NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rope_curve := Curve3D.new()
	rope_curve.add_point(start)
	rope_curve.add_point(end)
	path_3d.curve = rope_curve
	for i in range(0, 101, 100/(segments + 1)):
		var percent = i/100.0
		print(percent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
