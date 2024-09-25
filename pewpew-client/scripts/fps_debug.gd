extends Label

#@onready
#var window:Window = get_node("/root")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var fps:float = 1/delta
	text = "FPS: " + str(fps as int)
	var fps_procent:float = fps/ DisplayServer.screen_get_refresh_rate()
	#print(fps_procent)
	label_settings.font_color = Color(1-fps_procent,fps_procent,fps_procent-1)
	pass
