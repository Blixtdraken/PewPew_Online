extends Node2D

@export
var game_area_size:Vector2 = Vector2(1000,1000)


@onready
var background:Polygon2D = get_node("Background")

@onready
var border_body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_node("Border Body") as StaticBody2D).scale = Vector2(game_area_size/200)
	(%Camera as Camera2D).limit_bottom = game_area_size.y/2 as int
	(%Camera as Camera2D).limit_right = game_area_size.x/2 as int
	(%Camera as Camera2D).limit_top = -game_area_size.y/2 as int
	(%Camera as Camera2D).limit_left = -game_area_size.x/2 as int
	
	background.polygon[0] = Vector2(game_area_size.x/2,game_area_size.y/2)
	background.polygon[1] = Vector2(game_area_size.x/2,-game_area_size.y/2)
	background.polygon[2] = Vector2(-game_area_size.x/2,-game_area_size.y/2)
	background.polygon[3] = Vector2(-game_area_size.x/2,game_area_size.y/2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
