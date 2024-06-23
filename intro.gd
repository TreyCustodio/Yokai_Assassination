extends Node2D

@onready var player = $player
@onready var clouds_2 = $background/clouds2
@onready var clouds = $background/clouds
@onready var clouds_parallax = $background/clouds_parallax
@onready var clouds_2_parallax = $background/clouds2_parallax
@onready var enemies = $enemies
@onready var enemydeath = $enemydeath
@onready var npc = $enemies/faker2
@onready var npc_2 = $enemies/faker
@onready var startfx = $startfx
@onready var fade = $fade
@onready var fade_animation = $fade/AnimationPlayer
@onready var bgm = $bgm
@onready var start = $start
@onready var npc_3 = $enemies/faker3
@onready var settings = $settings
@onready var pause_menu = $pauseMenu
@onready var cred_1 = $fade/cred_1
@onready var cred_2 = $fade/cred_2
@onready var cred_3 = $fade/cred_3
@onready var cred_4 = $fade/cred_4
@onready var cred_5 = $fade/cred_5
@onready var jam_1 = $fade/cred_4/jam_1
@onready var jam_2 = $fade/cred_4/jam_2
@onready var jam_3 = $fade/cred_4/jam_3
@onready var cutscene = $cutscene
@onready var title = $title

var timer = 0.0
var tick = -2
var highlight = Vector2(0,0)
var fading_in = true
var transitioning = false
var fade_timer = 0.0
var modulo = Color(1,1,1,0)


var title_tick = -1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

##Parallax Scrolling
#2 copies of the scrolling image
#When the 2nd copy is equal to position 0,
#which is also when the 1st copy finishes its first loop,
#reset their positions

# Called every frame. 'delta' is the elapsed time since the previous frame.


func trans(scene, pos = Vector2(0,0)):
	Constants.position = pos
	Constants.direction = player.direction
	var str = "res://" + scene
	get_tree().change_scene_to_file(scene)
	
func transition_routine():
	trans("forest.tscn", Vector2(820, 531))

func titleRoutine(delta):
	if Constants.play_intro:
		if title_tick == 12:
			if not bgm.playing:
				bgm.play()
			pass
		elif title_tick == -1:
			if timer >= 1.0:
				timer = 0.0
				bgm.play()
				title_tick += 1
			else:
				timer += delta
		elif title_tick == 0:
			modulo.a += 0.05
			if modulo.a >= 1:
				modulo.a = 1
				cred_1.modulate = modulo
				title_tick+= 1
			else:
				cred_1.modulate = modulo
		
		elif title_tick == 1:
			if timer >= 3.0:
				timer = 0.0
				title_tick += 1
			else:
				timer += delta
		
		elif title_tick == 2:
			modulo.a -= 0.05
			if modulo.a <= 0:
				modulo.a = 0
				cred_1.modulate = modulo
				title_tick+= 1
			else:
				cred_1.modulate = modulo
		
		elif title_tick == 3:
			modulo.a += 0.05
			if modulo.a >= 1:
				modulo.a = 1
				cred_2.modulate = modulo
				title_tick+= 1
			else:
				cred_2.modulate = modulo
		
		elif title_tick == 4:
			if timer >= 3.0:
				timer = 0.0
				title_tick += 1
			else:
				timer += delta
		
		elif title_tick == 5:
			modulo.a -= 0.05
			if modulo.a <= 0:
				modulo.a = 0
				cred_2.modulate = modulo
				title_tick+= 1
			else:
				cred_2.modulate = modulo
		
		elif title_tick == 6:
			modulo.a += 0.05
			if modulo.a >= 1:
				modulo.a = 1
				cred_3.modulate = modulo
				title_tick+= 1
			else:
				cred_3.modulate = modulo
		
		elif title_tick == 7:
			if timer >= 3.0:
				timer = 0.0
				title_tick += 1
			else:
				timer += delta
		
		elif title_tick == 8:
			modulo.a -= 0.05
			if modulo.a <= 0:
				modulo.a = 0
				cred_3.modulate = modulo
				title_tick+= 1
			else:
				cred_3.modulate = modulo
		elif title_tick == 9:
			modulo.a += 0.05
			if modulo.a >= 1:
				modulo.a = 1
				cred_4.modulate = modulo
				jam_1.modulate = modulo
				jam_2.modulate = modulo
				jam_3.modulate = modulo
				title_tick+= 1
			else:
				cred_4.modulate = modulo
				jam_1.modulate = modulo
				jam_2.modulate = modulo
				jam_3.modulate = modulo
		
		elif title_tick == 10:
			if timer >= 4.0:
				timer = 0.0
				title_tick += 1
			else:
				timer += delta
		
		elif title_tick == 11:
			modulo.a -= 0.05
			if modulo.a <= 0:
				modulo.a = 0
				cred_4.modulate = modulo
				jam_1.modulate = modulo
				jam_2.modulate = modulo
				jam_3.modulate = modulo
				title_tick+= 1
				modulo.a = 1
			else:
				cred_4.modulate = modulo
				jam_1.modulate = modulo
				jam_2.modulate = modulo
				jam_3.modulate = modulo
	else:
		title_tick = 12
		if not bgm.playing:
			bgm.play()
	
			
	if not fading_in:
		
		if not pause_menu.pause:
			if Input.is_action_just_pressed("jump"):
				startfx.play()
				bgm.stop()
				cutscene.play()
				if not Constants.play_intro:
					transitioning = true
					fade_animation.play("fade_out")
				else:
					tick += 1
					Constants.play_intro = false
		if Input.is_action_just_pressed("pause"):
			if not pause_menu.opening or pause_menu.closing:
				if pause_menu.pause:
					pause_menu.unPause()
				else:
					pause_menu.pauseGame()
		
	
func _process(delta):
	if not player.key_lock:
		player.position = Vector2(722,373)
		#player.masterLock()
		player.keyLock()
		player.freeze()
		player.interaction.monitoring = false
		player.samurai.visible = false
		player.kitsune.visible = false
		player.camera_2d.visible = false
	
	if fading_in and title_tick == 12:
		if not fade_animation.is_playing():
			fade_animation.play("fade_in")
		if fade_timer >= 0.5:
			fade_timer = 0.0
			fading_in = false
		else:
			fade_timer += delta
	
	elif transitioning:
		bgm.volume_db -= 0.5
		if fade_timer >= 2.0:
			if bgm.volume_db <= 0:
				fade_timer = 0.0
				transition_routine()
		else:
			fade_timer += delta
		return
			
	if tick == -2:
		titleRoutine(delta)
	elif tick == -1:
		modulo.a -= 0.1
		if modulo.a <= 0:
			modulo.a = 0
			start.modulate = modulo
			settings.modulate = modulo
			title.modulate = modulo
			tick+= 1
		else:
			start.modulate = modulo
			settings.modulate = modulo
			title.modulate = modulo
		
		
	elif tick == 0:
		npc.playAnimation("running")
		npc_2.playAnimation("running")
		tick += 1
	if tick == 1:
		npc.position.x -= 2
		npc_2.position.x -= 2
		if npc.position.x <= 780:
			npc.playAnimation("default")
			npc_2.playAnimation("default")
			tick += 1
	elif tick == 2:
		if timer >= 1.0:
			npc_2.sprite.flip_h = false
			timer = 0.0
			tick += 1
			displayText("You've been following me for\na while now, Tetsuya...")
		else:
			timer += delta
	elif tick == 3:
		if not player.speaking:
			if timer >= 0.3:
				timer = 0.0
				tick += 1
				displayText("======&My apologies.|I'm a bit shaken up by recent events.|It wasn't my intention to\nmake you uneasy.", 3)
			else:
				timer += delta
	elif tick == 4:
		if not player.speaking:
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("What recent events are you\ntalking about?")
			else:
				timer += delta
	elif tick == 5:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.5:
				timer = 0.0
				tick += 1
				displayText("&Haven't you heard?|About the Yokai appearing all\nover the palace?", 3)
			else:
				timer += delta
	elif tick == 6:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.5:
				timer = 0.0
				tick += 1
				displayText("&You're serious?|&I had no idea...")
			else:
				timer += delta
	elif tick == 7:
		if not player.speaking:
			npc.sprite.flip_h = false
			#Some action before timer
			if timer >= 1.0:
				npc.sprite.flip_h = true
				timer = 0.0
				tick += 1
				displayText("&Apparently...|The shogun and his council\nare in complete disarray.|It would be prime time for\nthe Katsu clan to strike.", 3)
			else:
				timer += delta
	elif tick == 8:
		if not player.speaking:
			npc_2.sprite.flip_h = true
			#Some action before timer
			if timer >= 1.5:
				timer = 0.0
				tick += 1
				displayText("&What's the matter?|&Everything ok?", 3)
			else:
				timer += delta
	elif tick == 9:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("Don't turn into a Yokai\non me now!", 3)
			else:
				timer += delta
	elif tick == 10:
		if not player.speaking:
			npc_2.sprite.flip_h = false
			#Some action before timer
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("&No...It's just...|My brother went missing\nseveral days ago...|Since then, I've guarded the\nfront gate on my own.")
			else:
				timer += delta
	elif tick == 11:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("&You mean Tezuka?", 3)
			else:
				timer += delta
	elif tick == 12:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("Yes, and now I'm thinking\nabout the Yokai and...|&..............|Don't you mean Tezuka-\nsama?")
			else:
				timer += delta
	
	elif tick == 13:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("&Ah! Yes, of course!|&I meant to say Tezuka-senpai!", 3)
			else:
				timer += delta
	elif tick == 14:
		if not player.speaking:
			#Some action before timer
			if timer >= 0.6:
				timer = 0.0
				tick += 1
				displayText("My brother is the master\nof the palace gates!|&How dare you mock his title!")
			else:
				timer += delta
	elif tick == 15:
		if not player.speaking:
			npc_2.playAnimation("running")
			tick += 1
	elif tick == 16:
		npc_2.position.x += 1
		if npc_2.position.x >= npc.position.x - 96:
			npc_2.position.x = npc.position.x - 96
			npc_2.playAnimation("default")
			tick += 1
	elif tick == 17:
		displayText("&And what was your title?|I won't allow fodder like you\nto disrespect my brother!")
		tick += 1
	elif tick == 18:
		if not player.speaking:
			tick += 1
	elif tick == 19:
		npc.playAnimation("slashing")
		npc.sprite.offset.x -= 32
		tick += 1
	elif tick == 20:
		if npc.sprite.frame == 6:
			if npc_2.visible:
				enemydeath.play()
				npc_2.visible = false
		elif npc.sprite.frame == 10:
			npc.sprite.offset.x += 32
			npc.playAnimation("default")
			tick += 1
	elif tick == 21:
		if timer >= 1.0:
			timer = 0.0
			tick += 1
			displayText("&Ye he he!|These samurai fall for the\nmost cleverless tricks!", 2)
		else:
			timer += delta
	elif tick == 22:
		if not player.speaking:
			npc_3.sprite.flip_h = false
			npc_3.sprite2.flip_h = false
			npc_3.playAnimation("running")
			tick += 1
	elif tick == 23:
		if npc_3.position.x >= npc.position.x - 200:
			npc_3.playAnimation("default")
			tick += 1
		else:
			npc_3.position.x += 4
	elif tick == 24:
		displayText("&=Ah! There you are...|&==\"Tezuka-sama\"", 2)
		tick += 1
	elif tick == 25:
		if not player.speaking:
			if timer >= 1.0:
				tick += 1
			else:
				timer += delta
	elif tick == 26:
		npc.shiftfx.play()
		npc_3.sprite.visible = false
		npc_3.sprite2.visible = true
		npc.sprite.visible = false
		npc.sprite2.visible = true
		tick += 1
	elif tick == 27:
		if timer >= 2.0:
			timer = 0.0
			transitioning = true
			fade_animation.play("fade_out")
		else:
			timer += delta
			
			
		
func displayText(text, sound=0):
	player.displayText = text
	player.startSpeech(sound)
