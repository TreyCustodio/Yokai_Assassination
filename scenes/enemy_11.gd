extends "res://scenes/npc.gd"

func _ready():
	if not Constants.enemy_11:
		despawn = true
		

func die():
	Constants.enemy_11 = false
