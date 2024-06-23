extends "res://scenes/faker.gd"

func _ready():
	if not Constants.enemy_4:
		despawn = true
		

func die():
	Constants.enemy_4 = false
