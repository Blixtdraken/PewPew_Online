extends Line2D
@onready
var drawer_node:Node2D  = get_parent().get_node("Drawer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2.ZERO
	pass # Replace with function body.

@export
var distance_between_points:float = 100
@export
var trail_length:float = 500
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	#points.append()
	var list:PackedVector2Array = points
	@warning_ignore("narrowing_conversion")
	var point_amount:int = trail_length/distance_between_points + 1
	if drawer_node.global_position.distance_to(list[0]) >= distance_between_points:
		list.insert(0, drawer_node.global_position)
		if list.size() + 1 >= point_amount:
			list.remove_at(list.size()-1)
	else:
		list.set(0,drawer_node.global_position)
	
	#print(list)
	points = list
	
	#print(points)
	#print(position)
	pass
