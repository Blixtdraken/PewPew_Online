extends Node2D


class_name Laser
@export
var laser_speed:float = 1500

var shooter:Player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#reset_physics_interpolation()
	#if multiplayer.get_unique_id() != get_multiplayer_authority():
		#(get_node("HitBox") as Area2D).monitoring = false
		#(get_node("HitBox") as Area2D).monitorable = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	transform.translated(-transform.y*delta*laser_speed)
	position += -transform.y*delta*laser_speed
	#print(position)
	pass
	
func _delete_timeout():
	#print("Removed Laser")
	queue_free()
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_multiplayer_authority() != get_multiplayer_authority():
		if body is Player and multiplayer.get_unique_id() == get_multiplayer_authority():
			var player:Player = body
			#print("Hit player: " + str(player))
			if shooter:
				shooter.__send_laser_hit.rpc_id(1, player.get_multiplayer_authority())
		get_parent().call_deferred("remove_child",self)
		queue_free()
		#print("DeHit player: " + str(body))
	pass # Replace with function body.
