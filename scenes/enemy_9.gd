extends "res://scenes/npc.gd"
func _ready():
	if not Constants.enemy_9:
		despawn = true
		

func die():
	Constants.enemy_9 = false
