extends "res://room.gd"

func transition_routine():
	trans("forest.tscn", Vector2(2349, 531))

func set_transition_velocity():
	player.velocity = Vector2(-player.SPEED, -player.JUMP_VELOCITY)
