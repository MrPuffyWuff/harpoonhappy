extends Node3D

const BUILDING = preload("res://SCENES/MAP/OBJECTS/building.tscn")
const CRATE = preload("res://SCENES/MAP/OBJECTS/crate.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_building(Vector3.ZERO, Vector3(20, 10, 20))
	#for i in range(5):
		#spawn_building(Vector3(
			#rng.randf_range(-50,50),
			#0,
			#rng.randf_range(-50,50)
			#))
	for i in range(5):
		spawn_crate(Vector3(
			rng.randf_range(-50,50),
			2,
			rng.randf_range(-50,50)
			))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_building(location : Vector3, size : Vector3 = Vector3.ZERO):
	var instance : Building = BUILDING.instantiate()
	instance.position.x = location.x
	instance.position.z = location.z
	if size != Vector3.ZERO:
		instance.body_size = size
	$BuildingsNode.add_child(instance)

func spawn_crate(location : Vector3):
	var instance = CRATE.instantiate()
	instance.position.x = location.x
	instance.position.y = location.y
	instance.position.z = location.z
	$Objects.add_child(instance)
