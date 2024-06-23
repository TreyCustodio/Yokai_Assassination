extends "res://scenes/yokai.gd"

func _ready():
	if not Constants.enemy_3:
		despawn = true
		

func die():
	Constants.enemy_3 = false
