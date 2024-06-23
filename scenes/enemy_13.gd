extends "res://scenes/npc.gd"
func _ready():
	if not Constants.enemy_13:
		despawn = true
		

func die():
	Constants.enemy_13 = false
