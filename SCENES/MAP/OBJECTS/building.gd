extends StaticBody3D
class_name Building

var body_size : Vector3 = Vector3(20,30,20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Body.mesh = BoxMesh.new()
	$CollisionShape3D.shape = BoxShape3D.new()
	
	$Body.mesh.size = body_size
	$CollisionShape3D.shape.size = body_size
	$Body.position.y = body_size.y/2
	$CollisionShape3D.position.y = body_size.y/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
