extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_toggled(toggled_on: bool) -> void:
	#print(toggled_on)
	if toggled_on == true:
		Engine.max_fps = 10
	else:
		Engine.max_fps = 0
	pass

	pass # Replace with function body.
