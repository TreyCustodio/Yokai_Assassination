extends CharacterBody2D

##Objects
#Sprites
@onready var samurai = $samurai
@onready var kitsune = $kitsune

#Camera/Hud
@onready var camera_2d = $Camera2D
@onready var healthbar = $Camera2D/healthbar
@onready var health_number = $Camera2D/healthbar/healthNumber

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
@onready var pauseMenu = $pauseMenu
@onready var menuCursor = $menuCursor
@onready var menuSelect = $menuSelect
@onready var pause_start = $pauseMenu/pause_start
@onready var pause_close = $pauseMenu/pause_close
@onready var to_kitsune_fx = $change_sound
@onready var to_samurai_fx = $change_sound_1

#Areas
@onready var weapons = $weapons
@onready var interact_rect = $interaction/interact_rect
@onready var interaction = $interaction


##Physics values
const SPEED = 300.0
const JUMP_VELOCITY = -900.0
var pause = false
var attackMode = "spam" #spam, hold
var textMode = "medium" #slow, medium, fast
var direction = 1
var gravity = 3000
var highlight = Vector2(0,0)

##States
#Form
var form = "samurai"
#Pause states
var inMain = true
var selectingMode = false
var selectingText = false
#Player states
var key_lock = false
var speaking = false
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
##Stats
var maxHp = 5
var hp = maxHp

func resetStates():
	walking = false
	jumping = false
	#slash = fireball
	#backstep = bite
	slashing = false
	airslashing = false
	speaking = false
	backstepping = false
	
func changeForm():
	
	resetStates()
	keyLock()
	stop()
	shifting = true
	if form == "samurai":
		to_kitsune_fx.play()
		form = "kitsune"
		interact_rect.disabled = true
		#kitsune.flip_h = samurai.flip_h
		samurai.play("shifting")
	elif form == "kitsune":
		to_samurai_fx.play()
		form = "samurai"
		kitsune.play("shifting")
		
func keyLock():
	key_lock = true

func keyUnlock():
	key_lock = false
	
func freeze():
	stop()
	frozen = true
	
func unpause():
	pause_close.play()
	inMain = true
	selectingMode = false
	selectingText = false
	pauseMenu.frame = 0
	highlight.y = 0
	pause = false
	pauseMenu.visible = false
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
		camera_2d.position.x += 250
		camera_2d.position.y += 150
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#Window -> Fullscreen
	else:
		camera_2d.position.x -= 250
		camera_2d.position.y -= 150
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
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
	speaking = false
	keyUnlock()

func stop():
	velocity *= 0

func shootFire():
	slashing = true
	kitsune.play("fire")
	stop()
	
func pauseGame():
	pause_start.play()
	#reset states
	slashing = false
	samurai.play("idle")
	keyLock()
	pauseMenu.visible = true
	pause = true

###Pause Routine
func pauseRoutine():
	#Unpause
	if Input.is_action_just_pressed("pause"):
		unpause()
		return
	#Attack Mode / Text Speed
	if inMain:
		if Input.is_action_just_pressed("jump"):
			menuSelect.play()
			#Go to Attack settings
			if highlight.y == 0:
				if attackMode == "spam":
					pauseMenu.frame = 2
					highlight.y = 0
				elif attackMode == "hold":
					pauseMenu.frame = 3
					highlight.y = 1
				selectingMode = true
				inMain = false
			#Go to Text settings
			elif highlight.y == 1:
				inMain = false
				selectingText = true
				if textMode == "medium":
					highlight.y = 1
					pauseMenu.frame = 5
				elif textMode == "fast":
					highlight.y = 2
					pauseMenu.frame = 6
				elif textMode == "slow":
					highlight.y = 0
					pauseMenu.frame = 4
			return
		#Move cursor
		if highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menuCursor.play()
				pauseMenu.frame = 1
				highlight.y = 1
		
		elif highlight.y == 1:
			if Input.is_action_just_pressed("up"):
				menuCursor.play()
				highlight.y = 0
				pauseMenu.frame = 0
	#Spam / Hold
	elif selectingMode:
		if Input.is_action_just_pressed("slash"):
			menuCursor.play()
			selectingMode = false
			inMain = true
			pauseMenu.frame = 0
			highlight.y = 0
			return
			
		if highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menuSelect.play()
				attackMode = "hold"
				pauseMenu.frame = 3
				highlight.y = 1
		
		elif highlight.y == 1:
			if Input.is_action_just_pressed("up"):
				menuSelect.play()
				attackMode = "spam"
				highlight.y = 0
				pauseMenu.frame = 2
				
	elif selectingText:
		if Input.is_action_just_pressed("slash"):
			menuCursor.play()
			selectingText = false
			inMain = true
			pauseMenu.frame = 0
			highlight.y = 0
			return
		
		#On slow
		if highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menuSelect.play()
				textMode = "medium"
				textbox.setCharTime(0.01)
				pauseMenu.frame = 5
				highlight.y = 1
		
		#On medium
		elif highlight.y == 1:
			if Input.is_action_just_pressed("up"):
				menuSelect.play()
				textMode = "slow"
				textbox.setCharTime(0.05)
				highlight.y = 0
				pauseMenu.frame = 4
			elif Input.is_action_just_pressed("down"):
				textbox.setCharTime(0)
				menuSelect.play()
				textMode = "fast"
				highlight.y = 2
				pauseMenu.frame = 6
		
		#On fast
		elif highlight.y == 2:
			if Input.is_action_just_pressed("up"):
				menuSelect.play()
				textbox.setCharTime(0.01)
				textMode = "medium"
				highlight.y = 1
				pauseMenu.frame = 5
		
func handleEvents(frame):
	##Preliminary Events
	#Shift for both forms
	if shifting:
		#If released, stop shifting
		return
	#Toggle fullscreen -> move to pause screen
	elif Input.is_action_just_pressed("FULLSCREEN"):
		setFullscreen()
	
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
			if Input.is_action_just_pressed("hurt"):
				hp -= 1
			if Input.is_action_just_pressed("heal"):
				hp += 1
			
			if not jumping and not airslashing and not backstepping:
				#Change form
				if Input.is_action_just_pressed("shift"):
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
		#Fire control
		if slashing:
			#No moving or new actions during fire
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
			#Fire
			elif Input.is_action_just_pressed("slash"):
				if get_parent().ready_to_burn():
					shootFire()
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
		pauseRoutine()
		return
	
	##Event and physics handling
	#Set frame
	var frame = samurai.get_frame()
	#Set gravity
	if not frozen and not is_on_floor():
		velocity.y += gravity * delta
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
		
	#Update direction
	update_kitsune_direction()
	
	
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
	elif isRight and kitsune.flip_h:
		kitsune.flip_h = false
		fire_spawner.position.x += 120

func update_samurai_direction():
	var isLeft = velocity.x < 0
	var isRight = velocity.x > 0
	#flip sprite
	#Hitbox position adjusted by 32
	if not samurai.flip_h and isLeft:
		samurai.flip_h = true
		interact_rect.position.x = samurai.position.x - 32
		samurai_rect.position.x = samurai.position.x - 16
		sword_rect.position.x = samurai.position.x - 66
	elif samurai.flip_h and isRight:
		samurai.flip_h = false
		interact_rect.position.x = samurai.position.x + 32
		samurai_rect.position.x = samurai.position.x + 16
		sword_rect.position.x = samurai.position.x + 70
