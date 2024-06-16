extends CharacterBody2D

##Objects
@onready var samurai = $samurai
@onready var camera_2d = $Camera2D
@onready var healthbar = $Camera2D/healthbar
@onready var health_number = $Camera2D/healthbar/healthNumber

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

##Health
var maxHp = 5
var hp = 5

func keyLock():
	key_lock = true
	
func _physics_process(delta):
	#Set gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	##Event handling
	if not key_lock:
		#Hurt/Heal for debug
		if Input.is_action_just_pressed("hurt"):
			hp -= 1
		if Input.is_action_just_pressed("heal"):
			hp += 1
			
		#Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		#Direction: 0 -> no input, 1 -> right, -1 -> left
		var tempDir = Input.get_axis("left", "right")
		if tempDir == 0:
			walking = false
		else:
			walking = true
			direction = tempDir

		#Backstep and Walk
		if not backstepping and Input.is_action_just_pressed("backstep") and is_on_floor():
			backstepping = true
			velocity.x = (-int((direction * SPEED) * 1.5))
		
		if backstepping:
			velocity.x = move_toward(velocity.x, 0, 20)
			if velocity.x == 0:
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
	if velocity.x > 0 || velocity.x < 0:
		samurai.animation = "running"
	else:
		samurai.animation = "idle"
	
	#set healthbar animation
	if low:
		healthbar.animation = "low"
	else:
		healthbar.animation = "default"
		
	move_and_slide()

	health_number.text = str(hp)

