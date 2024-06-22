extends Node2D

@onready var player = $player
@onready var clouds_2 = $background/clouds2
@onready var clouds = $background/clouds
@onready var clouds_parallax = $background/clouds_parallax
@onready var clouds_2_parallax = $background/clouds2_parallax
@onready var enemies = $enemies
@onready var enemydeath = $enemydeath
@onready var fire_rect = $Projectiles/fireballs/fire_rect
@onready var fire_rect_1 = $Projectiles/fireballs/fire_rect_1
@onready var fire_rect_2 = $Projectiles/fireballs/fire_rect_2
@onready var fireballs = $Projectiles/fireballs
@onready var fade = $fade
@onready var fade_animation = $fade/AnimationPlayer

##New data to add to palace.tcsn
@onready var transition = $transition

var fading_in = true
var fading_out = false
var fire_count_2 = 0 #Determiens how many fireballs are allowed on the screen
var fire_timer = 0.0
var recharge_time = 0.5
var frozen #Freezes the game
var transitioning = false
var fade_timer = 0.0

func _ready():
	pass # Replace with function body.\

func set_player():
	pass

func trans(scene):
	var str = "res://" + scene
	get_tree().change_scene_to_file(str)
	

func handle_transition():
	if not transitioning:
		if transition.has_overlapping_bodies():
			var bodies = transition.get_overlapping_bodies()
			for b in bodies:
				if b.is_in_group("player"):
					player.velocity = Vector2(-player.SPEED, -player.JUMP_VELOCITY)
					transitioning = true
					player.masterLock()
					player.walking = true
					player.playAnimation("running")
					fade_animation.play("fade_out")
					
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
		else:
			n.update_position(player.position.x)
		

func refreshFire(delta):
	if fire_count_2 > 0:
		if fire_timer >= recharge_time:
			fire_timer = 0.0
			fire_count_2 -= 1
		else:
			fire_timer += delta

func freezeEnemies():
	frozen = true
	for e in enemies.get_children():
		e.freeze()

func unFreezeEnemies():
	frozen = false
	for e in enemies.get_children():
		e.unFreeze()

func freezeRoutine():
	if player.shifting:
		if not frozen:
			freezeEnemies()
	elif player.pause:
		if not frozen:
			freezeEnemies()
	elif player.speaking:
		if not frozen:
			freezeEnemies()
	elif frozen:
		unFreezeEnemies()
		
func _process(delta):
	if fading_in:
		player.masterLock()
		if not fade_animation.is_playing():
			fade_animation.play("fade_in")
		if fade_timer >= 0.5:
			player.masterUnlock()
			fade_timer = 0.0
			fading_in = false
		else:
			fade_timer += delta
	elif transitioning:
		if not fade_animation.is_playing():
			fade_animation.play("fade_out")
		if fade_timer >= 1.0:
			fade_timer = 0.0
			trans("forest.tscn")
		else:
			fade_timer += delta
	handle_transition()
	refreshFire(delta)
	checkDead()
	freezeRoutine()
