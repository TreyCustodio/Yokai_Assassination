extends "res://scenes/yokai.gd"

func _ready():
	if not Constants.enemy_2:
		despawn = true

func die():
	Constants.enemy_2 = false
