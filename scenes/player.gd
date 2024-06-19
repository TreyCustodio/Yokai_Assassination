extends CharacterBody2D

##Objects
@onready var samurai = $samurai
@onready var camera_2d = $Camera2D
@onready var healthbar = $Camera2D/healthbar
@onready var health_number = $Camera2D/healthbar/healthNumber
#Collision rects
@onready var samurai_rect = $samurai_rect
@onready var kitsune_rect = $kitsune_rect
@onready var backstep_rect = $backstep_rect
@onready var sword_rect = $weapons/sword_rect
#Textbox
@onready var textbox = $textbox
#Sound fx
@onready var slashfx = $slashfx
@onready var backstepfx = $backstepfx
@onready var jumpfx = $jumpfx
@onready var landfx = $landfx
@onready var pauseMenu = $pauseMenu
@onready var menuCursor = $menuCursor
@onready var menuSelect = $menuSelect
@onready var weapons = $weapons
@onready var interact_rect = $interaction/interact_rect
@onready var interaction = $interaction


##Physics values
const SPEED = 300.0
const JUMP_VELOCITY = -900.0
var pause = false
var attackMode = "spam"
var direction = 1
var gravity = 3000
var highlight = Vector2(0,0)
#set visible false for intro
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

##States
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
##Stats
var maxHp = 5
var hp = maxHp


func keyLock():
	key_lock = true

func keyUnlock():
	key_lock = false
	
func unpause():
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
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func setText():
	var number = str(hp)
	health_number.text = "	" + number

func startJump():
	weapons.setDamage(2)
	if not jumpfx.playing:
		jumpfx.play()
	samurai.offset.y -= 22
	samurai.play("jump_start")
	jump_start = true
	jumping = true
	
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
	weapons.setDamage(1)
	samurai.offset.y += 22
	samurai.play("idle")

func backstep():
	backstepping = true
	velocity.x = (-int((direction * SPEED) * 2.5))
	backstepfx.play()

func stopBackstep():
	backstep_rect.disabled = true
	samurai_rect.disabled = false
	backstepping = false

func setInteractable(text):
	displayText = text
	interactable = true

func unsetInteractable():
	displayText = ""
	interactable = false
	
func startSpeech():
	textbox.visible = true
	textbox.play("start")
	speaking = true
	keyLock()

func stopSpeech():
	speaking = false
	keyUnlock()

func stop():
	velocity *= 0

func pauseGame():
	#reset states
	slashing = false
	samurai.play("idle")
	keyLock()
	pauseMenu.visible = true
	pause = true
	
func pauseRoutine():
	if Input.is_action_just_pressed("pause"):
		unpause()
		return
	if Input.is_action_just_pressed("jump"):
		menuSelect.play()

		
	if highlight.y == 0:
		if Input.is_action_just_pressed("down"):
			menuCursor.play()
			attackMode = "hold"
			pauseMenu.frame = 1
			highlight.y += 1
	
	elif highlight.y == 1:
		if Input.is_action_just_pressed("up"):
			menuCursor.play()
			attackMode = "spam"
			highlight.y -= 1
			pauseMenu.frame = 0
		
		
func handleEvents(frame):
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
			#Slash
			if Input.is_action_just_pressed("slash"):
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


func _physics_process(delta):
	if interaction.interactable:
		if not interactable:
			setInteractable(interaction.displayText)
			return
	elif interactable:
		unsetInteractable()
	if pause:
		pauseRoutine()
		return
	
	#Set frame
	var frame = samurai.get_frame()
	#Set gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("FULLSCREEN"):
		setFullscreen()
			
	##Event handling
	handleEvents(frame)
			
	##Update states
	if hp <= int(ceil(maxHp/3.0)):
		low = true
	else:
		low = false
	
	##Animation control
	if speaking:
		if textbox.animation == "loop":
			pass
		elif textbox.get_frame() == 5:
			textbox.animation = "loop"
			if textbox.get_frame() == 3:
				textbox.animation = "pause"
				
	if not backstepping:
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
	
	#set animation loop
	#Jumping
	if jumping:
		if airslashing:
			if is_on_floor():
				stopAirslash()
				return
			if frame == 5:
				sword_rect.disabled = false
			elif frame == 10:
				stopAirslash()
			move_and_slide()
			return
		if jump_start:
			if frame == 4:
				startJumpLoop()
		elif jump_loop:
			if is_on_floor():
				startJumpEnd()
		elif jump_end:
			if frame == 4:
				stopJump()
	
	elif slashing:
		if attackMode == "spam":
			if frame == 5:
				if not slashfx.playing:
					slashfx.play()
					sword_rect.disabled = false
			elif frame == 10:
				stopSlash()
		elif attackMode == "hold":
			if Input.is_action_just_released("slash"):
				stopSlash()
			else:
				if not slashfx.playing:
					slashfx.play()
				if sword_rect.disabled:
					sword_rect.disabled = false
					
	elif walking or backstepping:
		samurai.animation = "running"
	else:
		samurai.animation = "idle"
	
	#set healthbar animation
	if low:
		healthbar.animation = "low"
	else:
		healthbar.animation = "default"
	
	if not key_lock:
		move_and_slide()
	setText()



