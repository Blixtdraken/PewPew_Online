extends Control

@onready
var main:Main = get_node("/root/Main")
@onready
var window:Window = get_node("/root") as Window

var camera:CameraFollow = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return
	get_tree().node_added.connect(_node_added)
	pass # Replace with function body.

var just_found_camera:bool = false
func _node_added(node:Node):
	return
	if node is CameraFollow:
		camera = node
		just_found_camera = true
		main.remove_child(self)
		node.add_child(self)
		position = (window.size/2 as Vector2)
		position.y *= -1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
