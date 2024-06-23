extends "res://scenes/npc.gd"

func _ready():
	if not Constants.enemy_8:
		despawn = true
		

func die():
	Constants.enemy_8 = false
