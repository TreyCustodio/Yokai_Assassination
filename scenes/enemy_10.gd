extends "res://scenes/faker.gd"
func _ready():
	if not Constants.enemy_10:
		despawn = true
		

func die():
	Constants.enemy_10 = false
