extends Node

class_name Player

var player_data:Dictionary = {}

var game_room:GameRoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@rpc("authority", "unreliable_ordered")
func _send_player_data(position_data:Vector2,rotation_data:float):
	var sender:int = multiplayer.get_remote_sender_id()
	for player in game_room.player_list:
		if player != sender:
			_sync_player_data.rpc_id(player, position_data,rotation_data)
	pass

@rpc("any_peer", "unreliable_ordered")
func _sync_player_data(position_data:Vector2,rotation_data:float):
	pass

@rpc("authority", "reliable")
func __send_shoot_laser(from_pos:Vector2, angle:float):
	var sender:int = multiplayer.get_remote_sender_id()
	for player in game_room.player_list:
		if player != sender:
			(get_node("../"+str(sender)) as Player).__sync_shoot_laser.rpc_id(player, from_pos, angle)
	pass
@rpc("any_peer", "reliable")
func __sync_shoot_laser(from_pos:Vector2, angle:float):
	pass


#Called on fake players on the client
@rpc("authority","reliable")
func __send_laser_hit(victim_uuid:int):
	var shooter:int = multiplayer.get_remote_sender_id()
	player_data["score"] += 1
	
	for player in game_room.player_list:
		__sync_laser_hit.rpc_id(player,shooter,victim_uuid)
		__set_score.rpc_id(player,player_data["score"])
	pass
	
@rpc("any_peer", "reliable")
func __sync_laser_hit(shooter_uuid:int, victim_uuid:int):
	pass

@rpc("any_peer", "reliable")
func __set_score(set_score:int):
	pass
