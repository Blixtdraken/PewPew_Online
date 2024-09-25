extends Node

class_name Main

var server:ENetMultiplayerPeer = null

# A sort of mapping of what room a client is in {<id as int>, <room code as string>}
var client_room_map:Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	server = ENetMultiplayerPeer.new()
	server.peer_connected.connect(_peer_connected_to_server)
	server.peer_disconnected.connect(_peer_disconnected_to_server)
	server.create_server(7656,1024)
	multiplayer.multiplayer_peer = server
	print("started")
	pass 


#Called when a client is connected to the server
func _peer_connected_to_server(id:int):
	print(str(id) +" established a connection to the server")
	pass

#Called when a client disconnetcs to the server
func _peer_disconnected_to_server(id:int):
	print(str(id) +" has closed the connection with server")
	pass
