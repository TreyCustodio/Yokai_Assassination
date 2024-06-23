extends AnimatedSprite2D

var timer = 0.0
func _process(delta):
	if frame == 9:
		position.x = 1244
	else:
		position.x -= 4
		
