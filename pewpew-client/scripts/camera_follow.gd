extends Camera2D

class_name CameraFollow

var follow_target:Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_target:
		position = position.lerp(follow_target.position, delta*5)
		#position = follow_target.position
		#print(position)
		#rotation = follow_target.rotation
	pass
