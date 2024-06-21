###Fire rect
###Controls the movement and collision of fireballs
extends CollisionShape2D
@onready var fireball_1 = $fireball_1
@onready var fireball_2 = $fireball_2
@onready var fireball_3 = $fireball_3
@onready var fireballs = $".."
@onready var fire_sound = $fire_sound


var moving = false
var direction = 1
var initialPos = 0
#3 allowed on screen


func initialize(dir = 1, pos = Vector2(0,0)):
	fireballs.incrementCount()
	fire_sound.play()
	position = pos
	initialPos = pos.x
	moving = true
	fireball_1.visible = true
	disabled = false
	direction = dir

	
func stop():
	moving = false
	fireball_1.visible = false
	disabled = true
	rotation = 0
	
	
func _ready():
	pass # Replace with function body.


func _process(delta):
	if moving:
		if direction == 1:
			position.x += 4
			rotation += 1
			if position.x >= initialPos + 250:
				stop()
		else:
			position.x -= 4
			rotation -= 1
			if position.x <= initialPos - 250:
				stop()
		
