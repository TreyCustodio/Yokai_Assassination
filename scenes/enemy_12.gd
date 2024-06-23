extends "res://scenes/faker.gd"
func _ready():
	if not Constants.enemy_12:
		despawn = true
		

func die():
	Constants.enemy_12 = false
