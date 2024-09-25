extends MenuButton

var main_node:Main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_node = get_node("/root/Main")
	text = main_node.ip_adress
	get_popup().index_pressed.connect(_on_server_pressed)
	pass # Replace with function body.


func _on_server_pressed(index:int):
	var value_chosen:String = get_popup().get_item_text(index)
	main_node.ip_adress = value_chosen
	text = value_chosen
	pass
