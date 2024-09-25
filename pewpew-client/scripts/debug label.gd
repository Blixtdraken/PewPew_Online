extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connected_to_server.connect(_joined_server)
	multiplayer.server_disconnected.connect(_server_disconnect)
	pass # Replace with function body.



func _joined_server():
	text = "UUID: " + str(multiplayer.get_unique_id())
	label_settings.font_color = Color.GREEN
	pass
func _server_disconnect():
	label_settings.font_color = Color.RED
	pass
