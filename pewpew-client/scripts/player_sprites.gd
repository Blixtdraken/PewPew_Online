extends CanvasItem

class_name PlayerSprites

@onready
var shell:Sprite2D = get_node("Shell")
@onready
var main:Sprite2D = get_node("Main")
@onready
var second:Sprite2D = get_node("Secondary")

func set_main_color(color:Color):
	main.self_modulate = color
	
func set_secondary_color(color:Color):
	#print(color)
	second.self_modulate = color
