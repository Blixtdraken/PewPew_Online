extends Node

class_name Main

var client:ENetMultiplayerPeer = null

var ip_adress:String = "37.27.184.26"

func _ready():
	DisplayServer.window_set_min_size(Vector2i(583,477))
	@warning_ignore("narrowing_conversion")
	#Engine.max_fps = DisplayServer.screen_get_refresh_rate() +1	
	pass

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("fullscreen"):
		var window:Window = (get_node("/root") as Window)
		if window.mode == Window.Mode.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN
	pass

func change_scene(packed_scene:PackedScene):
	var scene_node = get_node("./Scene")
	var scene_instance = packed_scene.instantiate()
	#(scene_node.get_child(0) as Control).visible = false
	var old_scene:Node = scene_node.get_child(0)
	#scene_node.remove_child(old_scene)
	old_scene.name = "___OLD__"
	old_scene.queue_free()
	var old_name:String = scene_node.name
	scene_node.add_child(scene_instance)
	scene_node.name = old_name

func connect_to_server():
	client = ENetMultiplayerPeer.new(		)
	
	client.create_client(ip_adress,7656)
	multiplayer.multiplayer_peer = client
	
	
	#multiplayer.server_disconnected.connect
	pass

func _server_disconnected():
	change_scene(preload("res://scenes/menus/start_menu.tscn"))
	pass


	
