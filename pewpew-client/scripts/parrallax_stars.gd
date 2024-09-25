extends Polygon2D
@onready
var background:Polygon2D = get_node("../Background")
# Called when the node enters the scene tree for the first time.

@export
var follow_amount:float = 1
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	polygon = background.polygon
	texture_offset = -%Camera.get_screen_center_position()*follow_amount
	pass
