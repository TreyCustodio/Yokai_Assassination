extends Area2D

@onready var speech = $"../speech"

var interactable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact():
	interactable = true

func unInteract():
	interactable = false

func get_text():
	return speech.get_text()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
