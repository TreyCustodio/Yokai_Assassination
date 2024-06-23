extends AnimatedSprite2D
@onready var player = $"../player"

func _physics_process(delta):
	if player.form == "kitsune":
		animation = "kitsune"
	else:
		animation = "default"
