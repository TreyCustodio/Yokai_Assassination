extends Area2D
var openable = false
@onready var palace = $".."
@onready var up = $up
var motion_tick = 0
var tick_timer = 0.0
var transitioning = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		openable = true
		up.visible = true
		pass


func _on_body_exited(body):
	if body.is_in_group("player"):
		openable = false
		up.visible = false
		pass # Replace with function body.

func _physics_process(delta):
	if openable:
		if tick_timer >= 0.2:
			tick_timer = 0.0
			if motion_tick == 0:
				up.position.y -= 10
				motion_tick = 1
			elif motion_tick == 1:
				up.position.y += 10
				motion_tick = 0
		else:
			tick_timer += delta
		
		if Input.is_action_just_pressed("up"):
			openable = false
			transitioning = true
			palace.player.pause = true
	elif transitioning:
		palace.bgm.volume_db -= 0.5
		if not palace.fade_animation.is_playing():
			palace.fade_animation.play("fade_out")
		if palace.fade_timer >= 1.0:
			if palace.bgm.volume_db <= 0:
				palace.fade_timer = 0.0
				palace.trans("castle.tscn", Vector2(920, 670))
		else:
			palace.fade_timer += delta
		
