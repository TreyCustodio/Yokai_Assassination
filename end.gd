extends Node2D
@onready var thanks = $screen_manager/thanks
@onready var kill = $screen_manager/kill
@onready var samurai = $screen_manager/kill/samurai
@onready var yokai = $screen_manager/kill/yokai
@onready var screen_manager = $screen_manager
@onready var slash = $slash
@onready var sound = $sound
@onready var thanks_sound = $thanks

var tick = 0
var timer = 0.0
var screen_set = false

func _process(delta):
	if not screen_set:
		if Constants.fullscreen:
			thanks.position.x += 300
			kill.position.x += 300
		screen_set = true
	if tick == 0:
		if timer >= 2.0:
			timer = 0.0
			tick += 1
			kill.visible = true
			sound.play()
		else:
			timer += delta
	elif tick == 1:
		if timer >= 2.0:
			timer = 0.0
			slash.play()
			samurai.text = str(Constants.human_count)
			if Constants.human_count == 0:
				samurai.modulate = Color(0,1,0,1)
			elif Constants.human_count == 5:
				samurai.modulate = Color(1,0,0,1)
			tick += 1
		else:
			timer += delta
	elif tick == 2:
		if timer >= 1.0:
			timer = 0.0
			slash.play()
			yokai.text = str(Constants.yokai_count)
			if Constants.yokai_count == 0:
				yokai.modulate = Color(1,0,0,1)
			elif Constants.yokai_count == 7:
				yokai.modulate = Color(1,0,0,1)
			tick += 1
		else:
			timer += delta
	elif tick == 3:
		if timer >= 2.0:
			timer = 0.0
			thanks_sound.play()
			thanks.visible = true
			tick += 1
		else:
			timer += delta
			
	elif tick == 4:
		if timer >= 5.0:
			screen_manager.visible = false
			Constants.human_count = 0
			Constants.yokai_count = 0
			Constants.hp = 5
			get_tree().change_scene_to_file("res://intro.tscn")
		else:
			timer += delta
