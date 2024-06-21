extends Node2D

@onready var player = $player
@onready var clouds_2 = $background/clouds2
@onready var clouds = $background/clouds
@onready var clouds_parallax = $background/clouds_parallax
@onready var clouds_2_parallax = $background/clouds2_parallax
@onready var enemies = $enemies
@onready var enemydeath = $enemydeath
@onready var npc = $enemies/npc
@onready var npc_2 = $enemies/npc2
var timer = 0.0
var tick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

##Parallax Scrolling
#2 copies of the scrolling image
#When the 2nd copy is equal to position 0,
#which is also when the 1st copy finishes its first loop,
#reset their positions

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	if not player.key_lock:
		player.keyLock()
		player.freeze()
		player.interaction.monitoring = false
		player.samurai.visible = false
		player.camera_2d.visible = false
		
	if tick == 0:
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
		if npc.sprite.frame == 10:
			npc.sprite.offset.x += 32
			npc.playAnimation("default")
			tick += 1
	elif tick == 21:
		if timer >= 1.0:
			timer = 0.0
			get_tree().change_scene_to_file("res://palace.tscn")
		else:
			timer += delta

func displayText(text, sound=0):
	player.displayText = text
	player.startSpeech(sound)
