#Mr Kosek taught us this, ye?
@tool
extends MeshInstance3D

const size : float = 256
@export_range(4, 256, 4) var resolution : int = 32:
	#SUPER COOL. Basically, you know the suuuuper repetitive
	#Accessor and modifier methods you did in Java? This is
	#the short hand for that
	set(input):
		resolution = input
		update_mesh()
#Contains a set of built in noises
@export var noise : FastNoiseLite:
	set(input):
		noise = input
		update_mesh()
		#A bit of odd code, but the idea is to supercede the setter
		#Were connecting the signal for changes to the update mesh
		#function, thus removing the need for a setter
		if noise:
			noise.changed.connect(update_mesh)
@export_range(4, 128, 4) var height : float = 64:
	set(input):
		height = input
		update_mesh()

func get_height(x : float, y : float) -> float:
	return noise.get_noise_2d(x, y) * height

func get_normal(x : float, y : float) -> Vector3:
	#Dist between verticies
	var epsilon : float = size / resolution
	#Perpendicular vector
	#Why does it work? Idk how to word it, just think rrly hard about it
	var normal := Vector3(
		#The "average" of the x (l-r) axis heights
		(get_height(x + epsilon, y) - get_height(x - epsilon, y)) / (2.0 * epsilon),
		1.0,
		#The "average" of the y (f-b) axis heights
		(get_height(x, y + epsilon) - get_height(x, y - epsilon)) / (2.0 * epsilon),
	)
	return normal.normalized()
func update_mesh() -> void:
	#Making the mesh
	var plane := PlaneMesh.new()
	#The Number of Grid units
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	
	#A list of arrays containing points, faces, verticies, etc
	var plane_arrays : Array = plane.get_mesh_arrays()
	var vertex_array : PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_VERTEX]
	var normal_array : PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_NORMAL]
	var tangent_array : PackedFloat32Array = plane_arrays[ArrayMesh.ARRAY_TANGENT]
	
	for i in vertex_array.size():
		var vertex = vertex_array[i]
		#The default of a plane. Makes sense. Again I can't draw, just think about it
		var normal = Vector3.UP
		var tangent = Vector3.RIGHT
		if noise:
			vertex.y = get_height(vertex.x, vertex.z)
			normal = get_normal(vertex.x, vertex.z)
			#The normal is perpendicular, so the cross is parallel!!! SO COOL
			tangent = normal.cross(Vector3.UP)
		vertex_array[i] = vertex
		normal_array[i] = normal
		tangent_array[4 * i] = tangent.x
		tangent_array[4 * i + 1] = tangent.y
		tangent_array[4 * i + 2] = tangent.z
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	mesh = array_mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
