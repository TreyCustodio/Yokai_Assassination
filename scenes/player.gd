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
@onready var sword_rect = $sword_rect

##Physics values
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var direction = 1
var gravity = 2500
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

##States
var key_lock = false
var backstepping = false
var walking = false
var low = false
var slashing = false
var jumping = false
var jump_start = false
var jump_loop = false
var jump_end = false

##Stats
var maxHp = 5
var hp = maxHp


func keyLock():
	key_lock = true

func slash():
	pass
	
func setFullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func setText():
	var number = str(hp)
	health_number.text = "	" + number

func startJump():
	samurai.position = Vector2(samurai.position[0], samurai.position[1] - 22)
	jump_start = true
	jumping = true
	
func startJumpLoop():
	jump_start = false
	jump_loop = true
	#samurai_rect.position = Vector2(samurai_rect.position[0], samurai_rect.position[1] - 22)
	velocity.y = JUMP_VELOCITY

func startJumpEnd():
	jump_loop = false
	jump_end = true

func stopJump():
	samurai.position = Vector2(samurai.position[0], samurai.position[1] + 22)
	jump_end = false
	jumping = false
	samurai.animation = "idle"


func _physics_process(delta):
	#Set gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("FULLSCREEN"):
		setFullscreen()
			
	##Event handling
	if not key_lock:
		#Hurt/Heal for debug
		if Input.is_action_just_pressed("hurt"):
			hp -= 1
		if Input.is_action_just_pressed("heal"):
			hp += 1
		
		#Slash
		if Input.is_action_just_pressed("slash"):
			slashing = true
			sword_rect.disabled = false
			
		#Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			startJump()
			
		
		#Direction: 0 -> no input, 1 -> right, -1 -> left
		var tempDir = Input.get_axis("left", "right")
		if tempDir == 0:
			walking = false
		else:
			walking = true
			direction = tempDir

		#Backstep and Walk
		if not backstepping and Input.is_action_just_pressed("backstep") and is_on_floor():
			backstep_rect.disabled = false
			samurai_rect.disabled = true
			backstepping = true
			velocity.x = (-int((direction * SPEED) * 1.5))
		
		if backstepping:
			velocity.x = move_toward(velocity.x, 0, 20)
			if velocity.x == 0:
				backstep_rect.disabled = true
				samurai_rect.disabled = false
				backstepping = false
		else:
			if walking:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, 40)
			
	##Update states
	if hp <= int(ceil(maxHp/3)):
		low = true
	else:
		low = false
	
	##Animation control
	if not backstepping:
		var isLeft = velocity.x < 0
		var isRight = velocity.x > 0
		#flip sprite
		if isLeft:
			samurai.flip_h = true
		elif isRight:
			samurai.flip_h = false
	
	#set animation loop
	if jumping:
		if jump_start:
			samurai.animation = "jump_start"
			var frame = samurai.frame
			if frame == 4:
				startJumpLoop()
		elif jump_loop:
			samurai.animation = "jump_loop"
			if is_on_floor():
				startJumpEnd()
		elif jump_end:
			samurai.animation = "jump_end"
			var frame = samurai.frame
			if frame == 4:
				stopJump()
	
	elif velocity.x > 0 || velocity.x < 0:
		samurai.animation = "running"
	else:
		samurai.animation = "idle"
	
	#set healthbar animation
	if low:
		healthbar.animation = "low"
	else:
		healthbar.animation = "default"
		
	move_and_slide()
	setText()
