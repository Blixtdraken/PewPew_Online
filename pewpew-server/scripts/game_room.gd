extends Node

class_name GameRoom
var room_code:String = ""
var player_list:Array = []
@onready
var room_handler:RoomHandler = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@rpc("any_peer","reliable")
func __player_joined_room(player_data:Dictionary):
	var player_joined:int = multiplayer.get_remote_sender_id()
	player_list.append(player_joined)
	(get_parent() as RoomHandler).uuid_to_room_map[player_joined] = room_code
	var player_color:Color = player_data.get("color")
	var player_nickname:String = player_data.get("nickname")
	
	var packed_scene:PackedScene = preload("res://scenes/player.tscn")
	var player_scene:Player = packed_scene.instantiate()
	
	
	#Set the owner of the object to the player who controls it for technical reasons
	player_scene.set_multiplayer_authority(player_joined)
	player_scene.name = str(player_joined)
	player_scene.game_room = self
	player_scene.player_data = player_data
	add_child(player_scene)
	
	#Send add player signal too every player in room including to add newly joined player
	#also, send add signal for every player already in the room
	for player in player_list:
		__add_player.rpc_id(player,player_joined,player_data)
		if player != player_joined:
			__add_player.rpc_id(player_joined,player,get_player(player).player_data)
	pass


func remove_player(uuid:int):
	var player_removed:int = uuid
	player_list.erase(uuid)
	
	get_node("./"+str(uuid)).queue_free()
	
	#If there is no players left in room remove it
	if player_list.size() == 0:
		queue_free()
		return
	
	
	
	#Send remove player call to all players
	for player in player_list:
			__remove_player.rpc_id(player,player_removed)
	pass
	
@rpc("authority","reliable")
func __add_player(uuid:int, player_data:Dictionary):
	pass

@rpc("authority","reliable")
func __remove_player(uuid:int):
	pass

@rpc("any_peer","reliable")
func __leave_room():
	var player_left:int = multiplayer.get_remote_sender_id()
	remove_player(player_left)
	room_handler.uuid_to_room_map.erase(player_left)
	pass

func get_player(uuid:int) -> Player:
	return get_node("./"+str(uuid)) 
	
