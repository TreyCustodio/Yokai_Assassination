extends CharacterBody2D

##Objects
#Sprites
@onready var samurai = $samurai
@onready var kitsune = $kitsune

#Camera/Hud
@onready var camera_2d = $Camera2D
@onready var healthbar = $Camera2D/healthbar
@onready var health_number = $Camera2D/healthbar/healthNumber
@onready var pause_menu = $"../pauseMenu"

#Textbox
@onready var textbox = $textbox
@onready var text = $textbox/text

#Collision rects
@onready var samurai_rect = $samurai_rect
@onready var kitsune_rect = $kitsune_rect
@onready var sword_rect = $weapons/sword_rect
@onready var fire_rect = $weapons/fire_rect
@onready var fire_spawner = $weapons/fire_spawner


#Sound fx
@onready var slashfx = $slashfx
@onready var backstepfx = $backstepfx
@onready var jumpfx = $jumpfx
@onready var landfx = $landfx
@onready var to_kitsune_fx = $change_sound
@onready var to_samurai_fx = $change_sound_1
@onready var bitefx = $kitsune/bitefx
@onready var hurtfx = $hurtfx
@onready var deathfx = $deathfx

#Areas
@onready var weapons = $weapons
@onready var interact_rect = $interaction/interact_rect
@onready var interaction = $interaction
@onready var bite_rect = $weapons/bite_rect
const MAIN = preload("res://main.tscn")

##Physics values
var dead = false
const SPEED = 300.0
const JUMP_VELOCITY = -900.0
var pause = false
var attackMode = Constants.attackMode #spam, hold
var textMode = Constants.textMode

var direction = Constants.direction
var gravity = 3000
var invincible = false
var iframe_timer = 0.0

##States
#Form
var form = Constants.form
var fullscreen = Constants.fullscreen
#Pause states

#Player states
var master_lock = true
var key_lock = false
var speaking = false
var biting = false
var backstepping = false
var walking = false
var low = false
var slashing = false
var jumping = false
var jump_start = false
var jump_loop = false
var jump_end = false
var airslashing = false
var displayText = ""
var interactable = false
var frozen = false
var shifting = false
var shooting = false
var playing_death = false
##Stats
var maxHp = 5
var hp = Constants.get_hp()
var yokai_count = Constants.get_yokai()
var human_count = Constants.get_humans()

func _ready():
	position = Constants.position
	if form == "samurai":
		if direction == -1:
			initialize_samurai_direction()
			initialize_kitsune_direction()
		return
	elif form == "kitsune":
		if direction == -1:
			initialize_kitsune_direction()
			initialize_samurai_direction()
		samurai.visible = false
		samurai_rect.disabled = true
		interact_rect.disabled = true
		kitsune.visible = true
		kitsune_rect.disabled = false
		kitsune.play("idle")
	
func play_death():
	playing_death = true
	deathfx.play()
	
func masterLock():
	master_lock = true
	resetStates()
	
func masterUnlock():
	master_lock = false
	key_lock = false
	
func resetStates():
	walking = false
	jumping = false
	slashing = false
	airslashing = false
	speaking = false
	backstepping = false
	invincible = false
	iframe_timer = 0.0

func playAnimation(animation):
	if form == "kitsune":
		kitsune.play(animation)
	elif form == "samurai":
		samurai.play(animation)
		

func disable_rects():
	sword_rect.disabled = true
	bite_rect.disabled = true
	
func hit():
	if not invincible:
		invincible = true
		hurtfx.play()
		Constants.hp -= 1
		hp -=1
		if hp <= 0:
			freeze()
			resetStates()
			disable_rects()
			masterLock()
			dead = true
			samurai.pause()
			kitsune.pause()
			return
		if form == "samurai":
			samurai.modulate = Color(1,0,0,10)
		elif form == "kitsune":
			kitsune.modulate = Color(1,0,0,10)
	
func changeForm():
	resetStates()
	keyLock()
	stop()
	shifting = true
	if form == "samurai":
		to_kitsune_fx.play()
		Constants.form = "kitsune"
		form = "kitsune"
		interact_rect.disabled = true
		#kitsune.flip_h = samurai.flip_h
		samurai.play("shifting")
	elif form == "kitsune":
		to_samurai_fx.play()
		Constants.form = "samurai"
		form = "samurai"
		kitsune.play("shifting")

func bite():
	weapons.setDamage(2)
	if direction == 1:
		kitsune.offset.x += 32
	elif direction == -1:
		kitsune.offset.x -= 32
	stop()
	keyLock()
	biting = true
	kitsune.play("biting")
	
func keyLock():
	key_lock = true

func keyUnlock():
	key_lock = false
	
func freeze():
	stop()
	frozen = true
	
func unPause():
	if form == "samurai":
		samurai.play()
	elif form == "kitsune":
		kitsune.play()
	attackMode = Constants.attackMode
	textMode = Constants.textMode
	textbox.set_speed()
	pause = false
	keyUnlock()

func airSlash():
	jump_start = false
	airslashing = true
	samurai.animation = "slashing"
	if direction == 1:
		samurai.offset.x += 32
	elif direction == -1:
		samurai.offset.x -= 32
	
	keyLock()
	
func slash():
	#Direction isnt correct
	slashing = true
	keyLock()
	samurai.animation = "slashing"
	if direction == 1:
		samurai.offset.x += 32
	elif direction == -1:
		samurai.offset.x -= 32
	stop()

func stopAirslash():
	keyUnlock()
	if direction == 1:
		samurai.offset.x -=32
	elif direction == -1:
		samurai.offset.x += 32
	
	if is_on_floor():
		stopJump()
	
	airslashing = false
	sword_rect.disabled = true
	samurai.animation = "jump_loop"
	
func stopSlash():
	sword_rect.disabled = true
	keyUnlock()
	if direction == 1:
		samurai.offset.x -=32
	elif direction == -1:
		samurai.offset.x += 32
	slashing = false
	sword_rect.disabled = true
	samurai.animation = "idle"
	
func setFullscreen():
	#Fullscreen -> Window
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		#camera_2d.position.x += 250
		#camera_2d.position.y += 150
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Constants.fullscreen = false
		fullscreen = false
	#Window -> Fullscreen
	else:
		#camera_2d.position.x -= 250
		#camera_2d.position.y -= 150
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Constants.fullscreen = true
		fullscreen = true
	update_camera()
		
func setHp():
	var number = str(hp)
	health_number.text = "	" + number

func startJump():
	if form == "samurai":
		weapons.setDamage(2)
		if not jumpfx.playing:
			jumpfx.play()
		samurai.offset.y -= 22
		samurai.play("jump_start")
		jump_start = true
		jumping = true
		
	elif form == "kitsune":
		kitsune.play("running")
		kitsune.frame = 1
		if velocity.x == 0:
			kitsune.pause()
		velocity.y = JUMP_VELOCITY
		if not jumpfx.playing:
			jumpfx.play()
		jumping = true
		jump_start = true
	
func startJumpLoop():
	samurai.play("jump_loop")
	jump_start = false
	jump_loop = true
	velocity.y = JUMP_VELOCITY

func startJumpEnd():
	samurai.play("jump_end")
	jump_loop = false
	jump_end = true
	
func stopJump():
	landfx.play()
	jump_end = false
	jumping = false
	if form == "samurai":
		weapons.setDamage(1)
		samurai.offset.y += 22
		samurai.play("idle")
	else:
		if velocity.x != 0:
			kitsune.play("running")
		else:
			kitsune.play("idle")

func backstep():
	backstepping = true
	velocity.x = (-int((direction * SPEED) * 2.5))
	backstepfx.play()

func stopBackstep():
	samurai_rect.disabled = false
	backstepping = false

func setInteractable(text):
	interactable = true
	displayText = text
	

func unsetInteractable():
	displayText = ""
	interactable = false

func startSpeech(sound = 0):
	interact_rect.disabled = true
	interaction.hide_icon()
	healthbar.visible = false
	text.play()
	textbox.textSound = sound
	textbox.setText(displayText)
	textbox.visible = true
	textbox.frame = 0
	textbox.play("start")
	stop()
	slashing = false
	walking = false
	speaking = true
	samurai.play("idle")
	keyLock()

func stopSpeech():
	interact_rect.disabled = false
	interaction.show_icon()
	healthbar.visible = true
	speaking = false
	keyUnlock()

func stop():
	velocity *= 0

func shootFire():
	slashing = true
	kitsune.play("fire")
	stop()
	
func pauseGame():
	pause_menu.position = Vector2(position.x-20, position.y - 40)
	pause_menu.pauseGame()
	#reset states
	slashing = false
	stop()
	if form == "samurai":
		samurai.pause()
	elif form == "kitsune":
		kitsune.pause()
	keyLock()
	pause = true


		
func handleEvents(frame):
	##Preliminary Events
	#Shift for both forms
	if shifting:
		#If released, stop shifting
		return
	
	
	##Samurai Events
	if form == "samurai":
		if speaking:
			return
		if interactable:
			if Input.is_action_just_pressed("jump"):
				startSpeech()
				return
		if slashing:
			if Input.is_action_just_pressed("backstep"):
					stopSlash()
					backstep()
					
			elif attackMode == "spam":
				if frame > 4:
					if Input.is_action_just_pressed("slash"):
						if not slashfx.playing:
							slashfx.play()
						samurai.set_frame_and_progress(5, samurai.get_frame_progress())
						return
						
			elif attackMode == "hold":
				if frame > 4:
					if not Input.is_action_just_released("slash"):
						if sword_rect.disabled:
							sword_rect.disabled = false
						if not slashfx.playing:
							slashfx.play()
						samurai.set_frame_and_progress(5, samurai.get_frame_progress())
				return
				
			return
		elif jumping and not airslashing:
			if not is_on_floor() and Input.is_action_just_pressed("slash"):
				airSlash()
				return
		
		if not key_lock:
			#Hurt/Heal for debug
			#if Input.is_action_just_pressed("hurt"):
				#hp -= 1
			#if Input.is_action_just_pressed("heal"):
				#hp += 1
			
			if not jumping and not airslashing and not backstepping:
				#Change form
				if Input.is_action_just_pressed("shift"):
					if not invincible:
						changeForm()
						return
				#Slash
				elif Input.is_action_just_pressed("slash"):
					slash()
					return
				
				#Jump
				elif Input.is_action_just_pressed("jump") and is_on_floor():
					startJump()
					return
				
				#Pause
				elif Input.is_action_just_pressed("pause"):
					pauseGame()
					return
				
			#Direction: 0 -> no input, 1 -> right, -1 -> left
			var tempDir = Input.get_axis("left", "right")
			if tempDir == 0:
				walking = false
			else:
				walking = true
				direction = tempDir

			#Backstep and Walk
			if not backstepping and not airslashing and Input.is_action_just_pressed("backstep") and is_on_floor():
				backstep()
			
			if backstepping:
				velocity.x = move_toward(velocity.x, 0, 40)
				
				if velocity.x == 0:
					stopBackstep()
			else:
				if walking:
					velocity.x = direction * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, 100)
					
	##Kitsune Events
	elif form == "kitsune":
		if pause:
			return
		#Fire control
		elif slashing:
			#No moving or new actions during fire
			return
		elif biting:
			#No moving or new actions during bite
			return
		#No new actions while jumping, but keep moving
		if not jumping:
			#Shift
			if Input.is_action_just_pressed("shift"):
				changeForm()
				return
			#Jump
			elif Input.is_action_just_pressed("jump"):
				startJump()
			elif Input.is_action_just_pressed("backstep"):
				bite()
				return
			#Fire
			elif Input.is_action_just_pressed("slash"):
				if get_parent().ready_to_burn():
					shootFire()
					return
			#Pause
			elif Input.is_action_just_pressed("pause"):
				pauseGame()
				return
		var tempDir = Input.get_axis("left", "right")
		if tempDir == 0:
			walking = false
		else:
			walking = true
			direction = tempDir
			
		if walking:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 100)


###Handle events and update states
func _physics_process(delta):
	##Pause Routine
	if pause:
		if Input.is_action_just_pressed("pause"):
			pause_menu.unPause()
			unPause()
		
		#pauseRoutine()
		return
	##I-frames
	if invincible:
		if iframe_timer >= 1.0:
			iframe_timer = 0.0
			invincible = false
			if form == "samurai":
				samurai.modulate = Color(1,1,1,1)
			elif form == "kitsune":
				kitsune.modulate = Color(1,1,1,1)
		else:
			iframe_timer += delta
	##Event and physics handling
	#Set frame
	var frame = samurai.get_frame()
	#Set gravity
	if not frozen and not is_on_floor():
		velocity.y += gravity * delta
	
	if not master_lock:
		handleEvents(frame)
			
			
	###Updating states
	##set healthbar animation
	if hp <= int(ceil(maxHp/3.0)):
		low = true
	else:
		low = false
	if low:
		healthbar.animation = "low"
	else:
		healthbar.animation = "default"
	setHp()
	
	##Shifting routine
	if shifting:
		#From samurai to kitsune
		if form == "kitsune":
			if samurai.frame == 20:
				samurai.animation = "idle"
				samurai.stop()
				samurai_rect.disabled = true
				kitsune_rect.disabled = false
				samurai.visible = false
				kitsune.visible = true
				kitsune.play("idle")
				shifting = false
				keyUnlock()
		#From kitsune to samurai
		elif form == "samurai":
			if kitsune.frame == 20:
				kitsune.animation = "idle"
				kitsune.stop()
				kitsune_rect.disabled = true
				samurai_rect.disabled = false
				interact_rect.disabled = false
				kitsune.visible = false
				samurai.visible = true
				samurai.play("idle")
				shifting = false
				keyUnlock()
				
		return
		
	##Samurai Update
	if form == "samurai":
		update_samurai()
	
	##Kitsune Update
	elif form == "kitsune":
		update_kitsune()
		
	##Movement - both forms
	if not key_lock:
		move_and_slide()
	update_camera()

func update_camera():
	if fullscreen:
		camera_2d.position.x = position.x - 660
		camera_2d.position.y = position.y - (400)
	else:
		#camera_2d.position.x -= 250
		#camera_2d.position.y -= 150
		camera_2d.position.x = position.x - 400
		camera_2d.position.y = position.y - 250
		


func update_samurai():
	if speaking:
		if textbox.animation == "loop":
			return
		elif textbox.get_frame() == 5:
			textbox.animation = "loop"
			textbox.setDisplay()
		return
		
	if not backstepping:
		update_samurai_direction()
		update_kitsune_direction()
		
	#set animation loop
	#Jumping
	if jumping:
		if form == "kitsune":
			if velocity.x == 0:
				kitsune.pause()
			else:
				kitsune.play()
		
		if airslashing:
			if is_on_floor():
				stopAirslash()
				return
			if samurai.frame == 5:
				if not slashfx.playing:
					slashfx.play()
				sword_rect.disabled = false
			elif samurai.frame == 10:
				stopAirslash()
			move_and_slide()
			return
		if jump_start:
			if samurai.frame == 4:
				startJumpLoop()
		elif jump_loop:
			if is_on_floor():
				stopJump()
				startJumpEnd()
		elif jump_end:
			if samurai.frame == 4:
				stopJump()
	
	elif slashing:
		if attackMode == "spam":
			if samurai.frame == 5:
				if not slashfx.playing:
					slashfx.play()
				sword_rect.disabled = false
			elif samurai.frame == 10:
				stopSlash()
		elif attackMode == "hold":
			if Input.is_action_just_released("slash"):
				stopSlash()
			else:
				#frame is never 6
				if samurai.frame == 6:
					if sword_rect.disabled:
						sword_rect.disabled = false
					if not slashfx.playing:
						slashfx.play()
					
	elif walking or backstepping:
		samurai.animation = "running"
	else:
		samurai.animation = "idle"
			
func update_kitsune():
	#Update fire, no movement
	if slashing:
		#Shoot the fire
		if kitsune.frame == 4:
			var dir = 1
			if kitsune.flip_h:
				dir = -1
			if not shooting:
				shooting = true
				get_parent().shoot_fire(dir, fire_spawner.global_position)
			return
		elif kitsune.frame == 8:
			shooting = false
			slashing = false
			kitsune.play("idle")
			return
		else:
			return
	elif biting:

		if kitsune.frame == 14:
			if kitsune.animation_finished:
				if direction == 1:
					bite_rect.position.x = weapons.position.x + 27
				elif direction == -1:
					bite_rect.position.x = weapons.position.x - 95
				weapons.setDamage(1)
				biting = false
				if direction == 1:
					kitsune.offset.x -= 32
				elif direction == -1:
					kitsune.offset.x += 32
				kitsune.play("idle")
				keyUnlock()
		elif kitsune.frame >= 8:
			if not bite_rect.disabled:
				bite_rect.disabled = true
		elif kitsune.frame >= 6:
			if direction == 1:
				bite_rect.position.x += 4
			elif direction == -1:
				bite_rect.position.x -= 4
			if bite_rect.disabled:
				bitefx.play()
				bite_rect.disabled = false
		return
	#Update direction
	update_kitsune_direction()
	update_samurai_direction()
	
	
	#Update jump, keep moving
	if jumping:
		if velocity.x == 0:
			kitsune.pause()
		else:
			kitsune.play("running")
		
		#first frame of jump, don't check if on floor
		if jump_start:
			jump_start = false
		else:
			if is_on_floor():
				landfx.play()
				jumping = false
				kitsune.play()
	else:
		if walking:
			kitsune.animation = "running"
		else:
			kitsune.animation = "idle"
				
func update_kitsune_direction():
	var isLeft = velocity.x < 0
	var isRight = velocity.x > 0
	if isLeft and not kitsune.flip_h:
		kitsune.flip_h = true
		fire_spawner.position.x -= 120
		bite_rect.position.x -= 120
	elif isRight and kitsune.flip_h:
		kitsune.flip_h = false
		fire_spawner.position.x += 120
		bite_rect.position.x += 120

func update_samurai_direction():
	var isLeft = velocity.x < 0
	var isRight = velocity.x > 0
	#flip sprite
	#Hitbox position adjusted by 32
	if not samurai.flip_h and isLeft:
		samurai.flip_h = true
		interact_rect.position.x = samurai.position.x - 16
		samurai_rect.position.x = samurai.position.x - 16
		sword_rect.position.x = samurai.position.x - 64
	elif samurai.flip_h and isRight:
		samurai.flip_h = false
		interact_rect.position.x = samurai.position.x + 12
		samurai_rect.position.x = samurai.position.x + 16
		sword_rect.position.x = samurai.position.x + 68

func initialize_samurai_direction():
	if not samurai.flip_h and direction == -1:
		samurai.flip_h = true
		interact_rect.position.x = samurai.position.x - 16
		samurai_rect.position.x = samurai.position.x - 16
		sword_rect.position.x = samurai.position.x - 64
	elif samurai.flip_h:
		samurai.flip_h = false
		interact_rect.position.x = samurai.position.x + 12
		samurai_rect.position.x = samurai.position.x + 16
		sword_rect.position.x = samurai.position.x + 68
		
func initialize_kitsune_direction():
	if direction == -1 and not kitsune.flip_h:
		kitsune.flip_h = true
		fire_spawner.position.x -= 120
		bite_rect.position.x -= 120
	elif kitsune.flip_h:
		kitsune.flip_h = false
		fire_spawner.position.x += 120
		bite_rect.position.x += 120
