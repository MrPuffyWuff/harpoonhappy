extends Node2D

var points : Array[Point] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points.append(Point.new(Vector2(100,100),Vector2(95,95)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_points()

func update_points():
	for point : Point in points:
		var vx : Vector2 = point.position - point.prev_position
		point.prev_position = point.position
		point.position += vx
