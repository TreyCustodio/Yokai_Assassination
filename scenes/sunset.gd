extends Node2D

##Child Nodes
@onready var background = $background
@onready var clouds_2 = $cloud_images/clouds2
@onready var clouds_2_parallax = $cloud_images/clouds2_parallax
@onready var clouds = $cloud_images/clouds
@onready var clouds_parallax = $cloud_images/clouds_parallax


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moveClouds()

##Parallax Scrolling
#2 copies of the scrolling image
#When the 2nd copy is equal to position 0,
#which is also when the 1st copy finishes its first loop,
#reset their positions
func resetClouds():
	clouds_2.position.x = 391
	clouds.position.x = 391
	clouds_parallax.position.x = 2241
	clouds_2_parallax.position.x = 2241
	
func moveClouds():
	clouds_2.position.x -= 1
	clouds.position.x -= 1
	clouds_parallax.position.x -= 1
	clouds_2_parallax.position.x -= 1
	if clouds_2_parallax.position.x <= 391:
		resetClouds()
