extends Line2D
@onready
var drawer_node:Node2D  = get_parent().get_node("Trail Drawer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2.ZERO
	pass # Replace with function body.

@export
var distance_between_points:float = 10
@export
var trail_length:float = 500
# Called every frame. 'delta' is the elapsed time since the previous frame.
var last_point:Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	#points.append()
	var list:PackedVector2Array = points
	@warning_ignore("narrowing_conversion")
	var point_amount:int = trail_length/distance_between_points + 1
	#print(drawer_node.global_position.distance_to(list[1]))
	var list_size:int = list.size()
	var point_distance:float = drawer_node.global_position.distance_to(list[1])
	if  point_distance >= distance_between_points:
		list.insert(0, drawer_node.global_position)
		if list_size + 1 >= point_amount:
			list.remove_at(list.size()-1)
		last_point = list[list_size-1]
	else:
		list.set(0,drawer_node.global_position)
		list.set(list_size - 1, last_point.lerp(list[(list_size - 2)], point_distance / distance_between_points))
	
	#print(list)
	points = list
	#points)
	#print(position)
	pass
