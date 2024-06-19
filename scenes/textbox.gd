extends AnimatedSprite2D

@onready var text_display = $textDisplay
@onready var speech_1 = $speech_1
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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setCharTime(floatNum):
	timePerChar = floatNum
	
func setText(string):
	displayText = string
	length = displayText.length()
	currentChar = displayText[0]
	index = 0
	
func setDisplay():
	displaying = true
	
func continueDisplay():
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
	

func setAnimations():
	if ready_to_continue:
		play("pause")
	elif closing:
		if frame == 5:
			#End text routine
			done = false
			visible = false
			if text_display.position.y > -152:
				text_display.position.y -= 12
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
		speech_1.play()
		text_display.add_text(currentChar)
		index += 1
	##Stop if at the end of the text
	if index == length:
		displaying = false
		done = true
		ready_to_continue = true
	else:
		currentChar = displayText[index]
