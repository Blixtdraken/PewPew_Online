extends Control
@onready
var loading_sub_scene:Control = get_node("Loading Sub Menu")
@onready
var start_sub_scene:Control = get_node("Start Sub Menu")



func _ready() -> void:
	start_sub_scene.show()
	loading_sub_scene.hide()
	pass
	

func _on_connect_button_pressed() -> void:
	start_sub_scene.hide()
	loading_sub_scene.show()
	(loading_sub_scene.get_node("Status") as Label).text = "Connecting..."
	
	multiplayer.connection_failed.connect(_connection_error)
	multiplayer.connected_to_server.connect(_connected_to_server)
	print("Connecting to remote server...")
	(get_node("/root/Main") as Main).connect_to_server()
	
	pass # Replace with function body.

func _connection_error():
	print("ERROR: Connection to server failed")
	(loading_sub_scene.get_node("Status") as Label).text = "ERROR: Failed to connect to server, please restart"
	var error_timer:Timer = Timer.new()
	add_child(error_timer)
	error_timer.one_shot = true
	error_timer.timeout.connect(_error_timout)
	error_timer.start(1)
	pass

func _error_timout():
	var main_scene:Main = (get_node("/root/Main") as Main)
	main_scene.change_scene(preload("res://scenes/menus/start_menu.tscn"))
	pass

func _connected_to_server():
	print("Established connection to the server")
	var main_scene:Main = (get_node("/root/Main") as Main)
	if not multiplayer.server_disconnected.is_connected(main_scene._server_disconnected):
		multiplayer.server_disconnected.connect(main_scene._server_disconnected)
	main_scene.change_scene(preload("res://scenes/menus/room_handler.tscn"))
	
	pass
	
