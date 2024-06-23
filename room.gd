###Base room script used by every room

extends Node2D
@onready var player = $player
@onready var enemies = $enemies
@onready var enemydeath = $enemydeath
@onready var fire_rect = $projectiles/fireballs/fire_rect
@onready var fire_rect_1 = $projectiles/fireballs/fire_rect_1
@onready var fire_rect_2 = $projectiles/fireballs/fire_rect_2
@onready var fireballs = $projectiles/fireballs
@onready var fade = $fade
@onready var fade_animation = $fade/AnimationPlayer
@onready var bgm = $bgm

##New data to add to palace.tcsn
@onready var transition = $transition

var tick = 0
var fading_in = true
var fading_out = false
var fire_count_2 = 0 #Determiens how many fireballs are allowed on the screen
var fire_timer = 0.0
var recharge_time = 0.5
var frozen #Freezes the game
var transitioning = false #Transitions to new scene
var transition_room = ""
var fade_timer = 0.0
var death_timer = 0.0
var reset_timer = 0.0
var modulo = Color(1,1,1,1)
var cutscene = false

func displayText(text, sound=0):
	player.displayText = text
	player.startSpeech(sound)
	
func trans(scene, pos = Vector2(0,0)):
	Constants.position = pos
	Constants.direction = player.direction
	var str = "res://" + scene
	get_tree().change_scene_to_file(scene)


##Calls trans to transition to a specific scene and position.
##To be overridden by every room
func transition_routine():
	return

##Sets the players velocity to walk off screen.
##Override for negative velocities
func set_transition_velocity():
	player.velocity = Vector2(player.SPEED, -player.JUMP_VELOCITY)
	
	
func handle_transition():
	if not transitioning:
		if transition.has_overlapping_bodies():
			var bodies = transition.get_overlapping_bodies()
			for b in bodies:
				if b.is_in_group("player"):
					transitioning = true
					player.masterLock()
					set_transition_velocity()
					player.walking = true
					player.playAnimation("running")
					fade_animation.play("fade_out")
		
			
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
		elif n.despawn:
			enemies.remove_child(n)
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

func erase_player(delta):
	if tick == 2:
		if reset_timer >= 2.0:
			Constants.hp = 5
			trans("intro.tscn", Vector2(722, 372))
		else:
			reset_timer += delta
	elif tick == 1:
		if not player.speaking:
			tick += 1
			fade_animation.play("fade_out")
			
		return
	if not player.playing_death:
		player.play_death()
	modulo.a -= 0.01
	if modulo.a <= 0:
		modulo.a = 0
	player.samurai.self_modulate = modulo
	player.kitsune.self_modulate = modulo
	if reset_timer >= 4.0:
		tick = 1 
		reset_timer = 0.0
		displayText("If you try again, the intro\nwill be skipped.", 4)
	else:
		reset_timer += delta
	
func deathRoutine(delta):
	if not frozen:
		bgm.stop()
		freezeEnemies()
	if death_timer >= 1.0:
		erase_player(delta)
	else:
		death_timer += delta
	
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

##Abstract
func playCutscene():
	pass
	
func _process(delta):
	if cutscene:
		playCutscene()
		
	if player.dead:
		deathRoutine(delta)
		return
		
	elif fading_in:
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
		bgm.volume_db -= 0.5
		if not fade_animation.is_playing():
			fade_animation.play("fade_out")
		if fade_timer >= 1.0:
			if bgm.volume_db <= 0:
				fade_timer = 0.0
				transition_routine()
		else:
			fade_timer += delta
	if not transitioning:
		if not bgm.playing:
			bgm.play()
	handle_transition()
	refreshFire(delta)
	checkDead()
	freezeRoutine()
