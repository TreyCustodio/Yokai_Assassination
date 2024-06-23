extends "res://scenes/npc.gd"

func _ready():
	if not Constants.enemy_7:
		despawn = true
		

func die():
	Constants.enemy_7 = false
