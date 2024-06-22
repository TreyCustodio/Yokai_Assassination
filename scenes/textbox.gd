extends AnimatedSprite2D

@onready var text_display = $textDisplay
#Text sounds
@onready var speech_1 = $speech_1
@onready var speech_2 = $speech_2
@onready var speech_3 = $speech_3
@onready var speech_4 = $speech_4
@onready var speech_5 = $speech_5
@onready var player = $".."
@onready var textclose = $textclose

var displaying = false#displaying text
var ready_to_continue = false#Press Z to clear text and display next char sequence
var done = false#Press Z to close the dialogue
var closing = false#closing animation
var displayText = ""
var currentChar = ""
var length = 0
var index = 0
var charTimer = 0.0
var timePerChar = 0.01
var box_y = 0.0
var textSound = 0 #0 -> default, 1-> evil guard, 2 -> kitsune
# Called when the node enters the scene tree for the first time.

func set_speed():
	if Constants.textMode == "slow":
		setCharTime(0.1)
	elif Constants.textMode == "medium":
		setCharTime(0.01)
	elif Constants.textMode == "fast":
		setCharTime(0)
		
func _ready():
	set_speed()
	
func setCharTime(floatNum):
	timePerChar = floatNum
	
func setText(string):
	box_y = text_display.position.y
	displayText = string
	length = displayText.length()
	currentChar = displayText[0]
	index = 0
	
func setDisplay():
	displaying = true
	
func continueDisplay():
	text_display.position.y = box_y
	text_display.clear()
	play("loop")
	ready_to_continue = false
	displaying = true
	
func close():
	index = 0
	text_display.clear()
	closing = true
	ready_to_continue = false
	displaying = false
	play("close")
	textclose.play()
	
func handleEvents():
	if ready_to_continue:
		if Input.is_action_just_pressed("jump"):
			if done:
				close()
			else:
				continueDisplay()
	
func playSound():
	if textSound == 0:
		speech_1.play()
	elif textSound == 1:
		speech_2.play()
	elif textSound == 2:
		speech_3.play()
	elif textSound == 3:
		speech_4.play()
	elif textSound == 4:
		speech_5.play()
		
func setAnimations():
	if ready_to_continue:
		play("pause")
	elif closing:
		if frame == 5:
			#End text routine
			done = false
			visible = false
			text_display.position.y = box_y
			closing = false
			player.stopSpeech()
			pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if displaying:
		if charTimer >= timePerChar:
			charTimer = 0.0
			display()
		else:
			charTimer += delta
	setAnimations()
	handleEvents()


func display():
	#"Haruko-sama! ===What was all that ruckus about?|Is everything gonna be okay?"

	##Special characters
	if currentChar == "=":
		index+=1
	elif currentChar == " ":
		text_display.add_text(currentChar)
		index += 1
	elif currentChar == "&":
		text_display.position.y += 12
		index += 1
	#Stop and wait for Z
	elif currentChar == "|":
		index+= 1
		currentChar = displayText[index]
		displaying = false
		ready_to_continue = true
		return
	##Display next char
	else:
		playSound()
		text_display.add_text(currentChar)
		index += 1
	##Stop if at the end of the text
	if index == length:
		displaying = false
		done = true
		ready_to_continue = true
	else:
		currentChar = displayText[index]
