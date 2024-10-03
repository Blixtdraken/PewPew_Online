extends CharacterBody2D

class_name Player

@export
var debug:bool = false

@export
var window_move:bool = false

@export
var ignore_inout_without_focus:bool = true

var ship_color:Color = Color.WHITE
var ship_second_color:Color = Color.WHITE

var nickname:String = "n/a"

var sync_timer:Timer = null

var window:Window = null

var use_controller:bool = false

var game_room:GameRoom = get_parent()

var score

var rotation_velocity = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_node("Sprites") as PlayerSprites).set_main_color(ship_color)
	(get_node("Sprites") as PlayerSprites).set_secondary_color(ship_second_color)
	(get_node("Nickname") as Label).text = nickname
	score_label.text = str(score)
	if get_multiplayer_authority() == multiplayer.get_unique_id() or debug:
		
		#position = get_global_mouse_position()
		window = get_node("/root") as Window
		sync_timer = get_node("./Sync Timer")
		sync_timer.start()
	else:
		get_node("./Sync Timer").queue_free()
	pass # Replace with function body.



@export
var acceleration:float = 1
@export
var max_speed:float = 1000
@export
var break_force:float = 5
#var acceleration:Vector2 = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if get_multiplayer_authority() == multiplayer.get_unique_id() or debug:
		
		
		
		var look_at_vector = Input.get_vector("look_at.left","look_at.right","look_at.down","look_at.up").normalized()
		
		if look_at_vector != Vector2.ZERO:
			use_controller = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		elif Input.get_last_mouse_velocity() != Vector2.ZERO:
			use_controller = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
		if window.has_focus() or ignore_inout_without_focus:
			if look_at_vector != Vector2(0,0) and use_controller:
				last_rotation = rotation
				rotation = -look_at_vector.angle() + deg_to_rad(90)
			elif not use_controller:
				last_rotation = rotation
				rotation = position.direction_to(get_global_mouse_position()).angle() + deg_to_rad(90)
				
			var forward_dir:Vector2 = -transform.y
			if Input.is_action_pressed("move"):
				
				var velocity_add:Vector2 = forward_dir*delta*acceleration
				
				velocity = velocity.lerp(forward_dir*max_speed,delta*acceleration)
				
			if Input.is_action_pressed("boost"):
					velocity = forward_dir*max_speed	
								#print((forward_dir*max_speed).length())
			if Input.is_action_pressed("break"):
				velocity = velocity.lerp(Vector2.ZERO, delta*break_force)
				
			if Input.is_action_pressed("fire"):
				shoot_laser(position, rotation)
				__send_shoot_laser.rpc_id(1,position, rotation)
				#velocity += transform.y*10
				
			
			
	
		if Input.is_action_just_pressed("reset"):
			position = Vector2.ZERO
			velocity = Vector2.ZERO
		if window and window_move:
			window.position = (position as Vector2i)
		
		
		
		
		
		
		move_and_slide()
		get_node("/root/Main/Debug UI/Debug Menu/Vel Label").text = "Vel: " + str(velocity.length() as int)
	else:
		#rotation += rotation_velocity
		move_and_slide()
	#position = position.clamp(Vector2(-5000,-5000),Vector2(5000,5000))
	pass
var laser_overheated:bool = false
@onready
var laser_cooldown_timer:Timer = get_node("Laser Cooldown")
func shoot_laser(from_pos:Vector2, angle:float):
	if not laser_overheated:
		laser_cooldown_timer.start()
		laser_overheated = true
		var packed_scene = preload("res://scenes/laser.tscn")
		var laser_instance:Laser = packed_scene.instantiate()
		laser_instance.position = from_pos
		laser_instance.rotation = angle
		
		laser_instance.set_multiplayer_authority(get_multiplayer_authority())
		laser_instance.shooter = self
		
		var laser_sprite:Sprite2D = (laser_instance.get_node("Sprite") as Sprite2D)
		laser_sprite.texture = laser_sprite.texture.duplicate(true)
		var laser_gradient:GradientTexture2D = laser_sprite.texture
		#laser_gradient.generate_scene_unique_id()
		var laser_color = ship_color
		var color_vector = Vector3(laser_color.r+0.001,laser_color.g,laser_color.b)
		color_vector = color_vector.normalized()
		laser_color = Color(color_vector.x, color_vector.y, color_vector.z)
		laser_color.a = 1
		laser_gradient.gradient.set_color(0, laser_color)
		laser_color = ship_second_color
		laser_color.a = 0
		laser_gradient.gradient.set_color(1, laser_color)
		 
		#print(self)
		get_parent().add_child(laser_instance)

func _laser_cooled_down() -> void:
	laser_overheated=false
	pass # Replace with function body.

@rpc("authority", "reliable")
func __send_shoot_laser(from_pos:Vector2, angle:float):
	pass

@rpc("any_peer", "reliable")
func __sync_shoot_laser(from_pos:Vector2, angle:float):
	shoot_laser(from_pos, angle)
	pass

var last_rotation:float = 0
func _sync_timer_timeout():
	if not debug:
		_send_player_data.rpc_id(1,position,rotation,velocity,last_rotation-rotation)
	pass
	
#Send player information for server to sync with other players
@rpc("authority", "unreliable_ordered")
func _send_player_data(
position_data:Vector2, 
rotation_data:float, 
velocity_data:Vector2,
rotation_delta:float
):
	pass

#The rpc call tha receives the player information and proccesses it
@rpc("any_peer", "unreliable_ordered")
func _sync_player_data(
position_data:Vector2, 
rotation_data:float, 
velocity_data:Vector2,
rotation_delta:float
):
	if multiplayer.get_remote_sender_id() != 1:
		return
	
	position = position_data
	rotation = rotation_data
	velocity = velocity_data
	rotation_velocity = rotation_delta
	
	pass

@rpc("authority","reliable")
func __send_laser_hit(victim_uuid:int):
	pass
	
@rpc("any_peer", "reliable")
func __sync_laser_hit(shooter_uuid:int, victim_uuid:int):
	#if multiplayer.get_remote_sender_id() == 1:
		#print("[" + name + "] " + str(shooter_uuid) + " hit " + str(victim_uuid))
	pass

@onready
var score_label:Label = get_node("Score Label")

@rpc("any_peer", "reliable")
func __set_score(set_score:int):
	if multiplayer.get_remote_sender_id() == 1:
		score = set_score
		score_label.text = str(set_score)
	pass
