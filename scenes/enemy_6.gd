extends "res://scenes/faker.gd"
func _ready():
	if not Constants.enemy_6:
		despawn = true
		

func die():
	Constants.enemy_6 = false