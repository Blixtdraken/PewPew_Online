extends Node

class_name RoomHandler

var uuid_to_room_map:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_disconnected.connect(_player_disconnected)
	pass # Replace with function body.


@rpc("any_peer","reliable")
func __req_host_room(room_code:String):
	var remote_uuid:int = multiplayer.get_remote_sender_id()
	
	if not is_valid_room_code(room_code):
		__room_error.rpc_id(remote_uuid,"Invalid Symbols: " + room_code + "")
		return
	room_code = room_code.to_lower()
	
	print(str(remote_uuid) + " requested to host " + room_code)
	#Check if room already exist, if it does it sends back error message to player who requested it.
	if get_node_or_null("./"+room_code):
		__room_error.rpc_id(remote_uuid,"Room " + room_code + " already exists!")
		return
	
	#Create room
	var packed_scene:PackedScene = preload("res://scenes/game_room.tscn")
	var game_room:GameRoom = packed_scene.instantiate()
	
	game_room.name = room_code
	game_room.room_code = room_code
	add_child(game_room)
	
	#Add uuid to the mapping to know what room player is in
	uuid_to_room_map[remote_uuid] = room_code
	#Send to player client acceptation so they can join the room
	print(str(remote_uuid) + " accepted to host " + room_code)
	__accept_room_req.rpc_id(remote_uuid, room_code)
	pass

@rpc("any_peer","reliable")
func __req_join_room(room_code:String):
	var remote_uuid:int = multiplayer.get_remote_sender_id()
	
	print(str(remote_uuid) + " requested to join " + room_code)
	
	if not is_valid_room_code(room_code):
		__room_error.rpc_id(remote_uuid,"Invalid Symbols: " + room_code + "!")
		return
	room_code = room_code.to_lower()
	#Checks if room exists, if it doesn't exist it can't be joined and result in an error being sent to the player
	if not get_node_or_null("./"+room_code):
		__room_error.rpc_id(remote_uuid,"Can't find room " + room_code + "?")
		return
	
	#Add uuid to the mapping to know what room player is in
	#23uuid_to_room_map.get_or_add(remote_uuid,room_code)
	#Sends accept call to the players client
	print(str(remote_uuid) + " accepted to join " + room_code)
	__accept_room_req.rpc_id(remote_uuid, room_code)
	pass

@rpc("authority","reliable")
func __room_error(error_message:String):
	pass
	
@rpc("authority","reliable")
func __accept_room_req(room_code:String):
	pass
	
func _player_disconnected(uuid:int):
	
	var room_code = uuid_to_room_map.get(uuid)
	if room_code:
		get_room(room_code).remove_player(uuid)
		uuid_to_room_map.erase(uuid)
	pass

func get_room(room_code:String) -> GameRoom:
	return get_node("./"+room_code) as GameRoom
	
func is_valid_room_code(code:String):
	return code.is_valid_identifier() and code.find("_") == -1

	
