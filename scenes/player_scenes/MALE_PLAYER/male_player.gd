extends CharacterBody2D

signal body_entered(id)
signal body_exited(id)
var player_speed = 500
@onready var animation_tree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")
@onready var joystick = $Camera2D/joystick
var stamina = 50
@export var can_tag = true
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	handle_animations(Vector2(0, 1))
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera2D.make_current()
		joystick.visible = true
		var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		
		var joystick_vector = joystick.posVector
		if(Input.get_action_strength(("shift")) > 0):
			player_speed = 900
			stamina-=1*delta
		else:
			player_speed = 500
			stamina += 1*delta
			
		velocity = (player_speed*joystick_vector) + (input_direction*player_speed)
		handle_animations(joystick_vector)
		move_and_slide()
		pick_new_state()
	pass

#handles animation changes
func handle_animations(mov_dir):
	if(velocity != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", mov_dir)
		animation_tree.set("parameters/idle/blend_position", mov_dir)

#changes states based on velocity
func pick_new_state():
	if(velocity != Vector2.ZERO):
		animation_mode.travel("walk")
	else:
		animation_mode.travel("idle")

func _on_area_2d_body_entered(body):
	#print(GameManager.Players)
	if body != self:
		var bodyId = int(str(body.name))
		if(GameManager.Players.size() >= 1):
			if(GameManager.Players[bodyId].is_it && can_tag):
				GameManager.Players[int(str(self.name))].is_it = true
				GameManager.Players[bodyId].is_it = false
				body_entered.emit(true)
				print(GameManager.Players)
				print("before -- ")
				can_tag = false
				body.can_tag = false
				$TagTimer.start(3)
				if(body.has_node("TagTimer")):
					var node = body.get_node("TagTimer") as Timer
					node.start(3)
				syncGM(GameManager.Players, multiplayer.get_unique_id())
	pass # Replace with function body.

@rpc("any_peer")
func syncGM(arr, sender_id):
	print(GameManager.Players)
	if(sender_id != multiplayer.get_unique_id()):
		GameManager.Players = arr
		return
	else:
		syncGM.rpc(arr, sender_id)
	return



func _on_col_timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
	pass # Replace with function body.


func _on_tag_timer_timeout():
	can_tag = true
	pass # Replace with function body.
