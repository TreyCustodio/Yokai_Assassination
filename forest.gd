extends Node2D

@onready var player = $player
@onready var clouds_2 = $background/clouds2
@onready var clouds = $background/clouds
@onready var clouds_parallax = $background/clouds_parallax
@onready var clouds_2_parallax = $background/clouds2_parallax
@onready var enemies = $enemies
@onready var enemydeath = $enemydeath
@onready var fire_rect = $projectiles/fireballs/fire_rect
@onready var fire_rect_1 = $projectiles/fireballs/fire_rect_1
@onready var fire_rect_2 = $projectiles/fireballs/fire_rect_2
@onready var fireballs = $projectiles/fireballs

var fire_count_2 = 0 #Determiens how many fireballs are allowed on the screen
var fire_timer = 0.0
var recharge_time = 0.5

func _ready():
	pass # Replace with function body.

func ready_to_burn():
	return fire_count_2 < 3
	
func shoot_fire(dir=1, pos=Vector2(0,0)):
	fire_count_2 += 1
	var count = fireballs.getCount()
	if count == 0:
		fire_rect.initialize(dir, pos)
	elif count == 1:
		fire_rect_1.initialize(dir, pos)
	elif count == 2:
		fire_rect_2.initialize(dir,pos)

func checkDead():
	for n in enemies.get_children():
		if n.dead:
			enemies.remove_child(n)
			enemydeath.play()

func refreshFire(delta):
	if fire_count_2 > 0:
		if fire_timer >= recharge_time:
			fire_timer = 0.0
			fire_count_2 -= 1
		else:
			fire_timer += delta
			
func _process(delta):
	#player.healthbar.top_level = true
	refreshFire(delta)
	checkDead()
