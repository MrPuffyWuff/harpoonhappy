extends Node3D

const BUILDING = preload("res://SCENES/MAP/OBJECTS/building.tscn")
const CRATE = preload("res://SCENES/MAP/OBJECTS/crate.tscn")
var rng = RandomNumberGenerator.new()

@onready var ground = $Ground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ground.spawn_building(Vector3.ZERO, Vector3(20, 10, 20))
	#for i in range(5):
		#spawn_building(Vector3(
			#rng.randf_range(-50,50),
			#0,
			#rng.randf_range(-50,50)
			#))
	for i in range(100):
		spawn_crate(Vector3(
			rng.randf_range(-100,100),
			60,
			rng.randf_range(-100,100)
			))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_crate(location : Vector3):
	var instance = CRATE.instantiate()
	instance.position.x = location.x
	instance.position.y = location.y
	instance.position.z = location.z
	$Objects.add_child(instance)
