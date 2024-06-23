extends AnimatedSprite2D
##Player
@onready var player = $"../player"

##Sound fx
@onready var pause_start = $pause_start
@onready var pause_close = $pause_close
@onready var menu_cursor = $menuCursor
@onready var menu_select = $menuSelect
##Pause states
var pause = false
var opening = false
var closing = false
var highlight = Vector2(0,0)
var inMain = true
var inSettings = false
var selectingMode = false
var selectingText = false
var attackMode = Constants.attackMode
var textMode = Constants.textMode
var quit_prompt = false
var modulo = Color(1,1,1,0)

func pauseGame():
	opening = true
	frame = 7
	#pause = true
	attackMode = Constants.attackMode
	textMode = Constants.textMode
	pause_start.play()
	visible = true

func unPause():
	#pause = false
	pause_close.play()
	closing = true
	inMain = true
	inSettings = false
	selectingMode = false
	selectingText = false
	frame = 7
	highlight.y = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if opening:
		modulo.a += 0.1
		if modulo.a >= 1:
			modulo.a = 1
			modulate = modulo
			pause = true
			opening = false
		else:
			modulate = modulo
	
	elif closing:
		modulo.a -= 0.1
		if modulo.a <= 0:
			modulo.a = 0
			modulate = modulo
			pause = false
			closing = false
			visible = false
		else:
			modulate = modulo
		return
	if pause:
		pauseRoutine()
		
###Pause Routine
func pauseRoutine():
	if quit_prompt:
		if Input.is_action_just_pressed("FULLSCREEN"):
			get_tree().quit()
		elif not player.speaking:
			quit_prompt = false
		return
			
	if inMain:
		if Input.is_action_just_pressed("jump"):
			menu_select.play()
			if highlight.y == 0:
				frame = 0
				inMain = false
				inSettings = true
			elif highlight.y == 1:
				#toggle fullscreen
				player.setFullscreen()
			elif highlight.y == 2:
				if not quit_prompt:
					quit_prompt = true
					player.displayText = "Progress will be lost.\nPress ESCAPE to confirm."
					player.startSpeech(4)
					return
		elif highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menu_cursor.play()
				frame = 8
				highlight.y = 1
		elif highlight.y == 1:
			if Input.is_action_just_pressed("down"):
				menu_cursor.play()
				frame = 9
				highlight.y = 2
			elif Input.is_action_just_pressed("up"):
				menu_cursor.play()
				frame = 7
				highlight.y = 0
		elif highlight.y == 2:
			if Input.is_action_just_pressed("up"):
				menu_cursor.play()
				frame = 8
				highlight.y = 1
	##Attack Mode / Text Mode
	elif inSettings:
		#Select
		if Input.is_action_just_pressed("jump"):
			menu_select.play()
			if highlight.y == 0:
				if attackMode == "spam":
					frame = 2
					highlight.y = 0
				elif attackMode == "hold":
					frame = 3
					highlight.y = 1
				selectingMode = true
				inSettings = false
			#Go to Text settings
			elif highlight.y == 1:
				inSettings = false
				selectingText = true
				if textMode == "medium":
					highlight.y = 1
					frame = 5
				elif textMode == "fast":
					highlight.y = 2
					frame = 6
				elif textMode == "slow":
					highlight.y = 0
					frame = 4
			return
		#Back to main
		elif Input.is_action_just_pressed("slash"):
			menu_cursor.play()
			inSettings = false
			inMain = true
			highlight.y = 0
			frame = 7
			return
		#Move cursor
		if highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menu_cursor.play()
				frame = 1
				highlight.y = 1
		
		elif highlight.y == 1:
			if Input.is_action_just_pressed("up"):
				menu_cursor.play()
				highlight.y = 0
				frame = 0
	#Spam / Hold
	elif selectingMode:
		if Input.is_action_just_pressed("slash"):
			menu_cursor.play()
			selectingMode = false
			inSettings = true
			frame = 0
			highlight.y = 0
			return
			
		if highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menu_select.play()
				Constants.attackMode = "hold"
				attackMode = "hold"
				frame = 3
				highlight.y = 1
		
		elif highlight.y == 1:
			if Input.is_action_just_pressed("up"):
				menu_select.play()
				Constants.attackMode = "spam"
				attackMode = "spam"
				highlight.y = 0
				frame = 2
				
	elif selectingText:
		if Input.is_action_just_pressed("slash"):
			menu_cursor.play()
			selectingText = false
			inSettings = true
			frame = 0
			highlight.y = 0
			return
		
		#On slow
		if highlight.y == 0:
			if Input.is_action_just_pressed("down"):
				menu_select.play()
				Constants.textMode = "medium"
				textMode = "medium"
				frame = 5
				highlight.y = 1
		
		#On medium
		elif highlight.y == 1:
			if Input.is_action_just_pressed("up"):
				menu_select.play()
				Constants.textMode = "slow"
				textMode = "slow"
				highlight.y = 0
				frame = 4
			elif Input.is_action_just_pressed("down"):
				menu_select.play()
				Constants.textMode = "fast"
				textMode = "fast"
				highlight.y = 2
				frame = 6
		
		#On fast
		elif highlight.y == 2:
			if Input.is_action_just_pressed("up"):
				menu_select.play()
				Constants.textMode = "medium"
				textMode = "medium"
				highlight.y = 1
				frame = 5
				
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



