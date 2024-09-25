extends Control

@onready
var room_handler:RoomHandler = get_parent()
@onready
var code_field:LineEdit = get_node("./Code Field")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _host_button_pressed():
	room_handler.__req_host_room.rpc_id(1, code_field.text)
	pass


func _join_button_pressed():
	room_handler.__req_join_room.rpc_id(1, code_field.text)
	pass
