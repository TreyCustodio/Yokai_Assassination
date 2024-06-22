extends Area2D

@onready var speech = $"../speech"
@onready var interact_icon = $"../interactIcon"
@onready var npc = $".."

var interactable = false

func _ready():
	pass # Replace with function body.

func interact():
	interactable = true
	show_icon()

func get_fighting():
	return npc.fighting
	
func unInteract():
	interactable = false
	hide_icon()

func hide_icon():
	interact_icon.visible = false

func show_icon():
	interact_icon.play("default")
	interact_icon.visible = true
	
func get_text():
	return speech.get_text()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
