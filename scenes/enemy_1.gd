extends "res://scenes/yokai.gd"

func _ready():
	if not Constants.enemy_1:
		despawn = true

func die():
	Constants.enemy_1 = false
