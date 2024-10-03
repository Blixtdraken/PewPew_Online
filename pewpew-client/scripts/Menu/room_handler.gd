extends Control

class_name RoomHandler

var local_color:Color = Color.WHITE
var local_second_color:Color = Color.WHITE
var local_nickname:String = "some name"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_node("./Room Request Menu/Ship Color") as ColorPicker).color_changed.connect(_set_local_color)
	(get_node("./Room Request Menu/Ship Color 2") as ColorPicker).color_changed.connect(_set_local_second_color)
	(get_node("./Room Request Menu/Nickname") as LineEdit).text_changed.connect(_set_local_nickname)
	pass # Replace with function body.

@rpc("any_peer","reliable")
func __req_host_room(room_code:String):
	pass

@rpc("any_peer","reliable")
func __req_join_room(room_code:String):
	pass

@rpc("authority","reliable")
func __room_error(error_message:String):
	(get_node("./Room Request Menu/Code Field/Status Label") as Label).text = error_message
	pass
	
@rpc("authority","reliable")
func __accept_room_req(room_code:String):
	
	get_child(0).queue_free()
	
	var packed_scene:PackedScene = preload("res://scenes/game_room.tscn")
	var game_room:GameRoom = packed_scene.instantiate()
	
	game_room.room_code = room_code
	game_room.name = room_code
	add_child(game_room)
	
	pass

func _set_local_color(color:Color):
	local_color = color
	pass
func _set_local_second_color(color:Color):
	local_second_color = color
	#print(local_second_color)
	pass

func _set_local_nickname(nickname:String):
	local_nickname = nickname
	pass
