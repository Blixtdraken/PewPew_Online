extends Node2D

class_name GameRoom

var room_code:String = ""

var local_player:Player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Joined room " + room_code)
	var room_handler:RoomHandler = get_parent()
	var player_data:Dictionary = {}
	player_data.get_or_add("color",room_handler.local_color)
	player_data.get_or_add("second_color",room_handler.local_second_color)
	player_data.get_or_add("nickname",room_handler.local_nickname)
	player_data.get_or_add("score", 0)
	__player_joined_room.rpc_id(1,player_data)
	#get_window().mouse_passthrough = true
	pass # Replace with function body.

@rpc("any_peer","reliable")
func __player_joined_room(player_data:Dictionary):
	pass
	
@rpc("authority","reliable")
func __add_player(uuid:int, player_data:Dictionary):
	var packed_scene:PackedScene = preload("res://scenes/player.tscn")
	var player:Player = packed_scene.instantiate()
	
	#Set the owner of the object to the player who controls it for technical reasons
	player.set_multiplayer_authority(uuid)
	player.name = str(uuid)
	player.ship_color = player_data.get("color")
	player.ship_second_color = player_data.get("second_color")
	player.nickname = player_data.get("nickname")
	player.score = player_data.get("score")
	#Add player to the scene (both local and remote player)
	add_child(player)
	
	if uuid == multiplayer.get_unique_id():
		(get_node("Camera") as CameraFollow).follow_target = player
		local_player = player
	pass

@rpc("authority","reliable")
func __remove_player(uuid:int):
	get_node("./"+str(uuid)).queue_free()
	pass

@rpc("any_peer","reliable")
func __leave_room():
	pass

func _on_leave_pressed() -> void:
	print("left")
	__leave_room.rpc_id(1)
	(get_node("/root/Main") as Main).change_scene(load("res://scenes/menus/room_handler.tscn"))
	pass # Replace with function body.
