extends Node2D

@onready var player = $player
@onready var clouds_2 = $background/clouds2
@onready var clouds = $background/clouds
@onready var clouds_parallax = $background/clouds_parallax
@onready var clouds_2_parallax = $background/clouds2_parallax
@onready var enemies = $enemies
@onready var enemydeath = $enemydeath


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

##Parallax Scrolling
#2 copies of the scrolling image
#When the 2nd copy is equal to position 0,
#which is also when the 1st copy finishes its first loop,
#reset their positions
func resetClouds():
	clouds_2.position.x = 0
	clouds.position.x = 0
	clouds_parallax.position.x = 1460
	clouds_2_parallax.position.x = 1460
	
func moveClouds():
	clouds_2.position.x -= 1
	clouds.position.x -= 1
	clouds_parallax.position.x -= 1
	clouds_2_parallax.position.x -= 1
	if clouds_2_parallax.position.x <= 0:
		resetClouds()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func checkDead():
	for n in enemies.get_children():
		if n.dead:
			enemies.remove_child(n)
			enemydeath.play()
func _process(delta):
	checkDead()
	moveClouds()
