extends Area2D
@onready var player = $".."

var interactable = false
var displayText = ""
var interactableObject = null

func hide_icon():
	if interactableObject != null:
		interactableObject.hide_icon()

func show_icon():
	if interactableObject != null:
		interactableObject.show_icon()
	
func setInteractable(text, obj):
	interactable = true
	interactableObject = obj
	player.setInteractable(text)

func unInteract():
	interactable = false
	player.unsetInteractable()
	
func _ready():
	pass # Replace with function body.


func _process(delta):
	if interactableObject != null:
		if interactableObject.get_fighting():
			unInteract()
			interactableObject.unInteract()
			interactableObject = null
		elif not interactable:
			interactableObject.unInteract()
			interactableObject = null
		
	if has_overlapping_areas():
		var areas = get_overlapping_areas()
		for a in areas:
			if a.is_in_group("enemy"):
				if not a.get_fighting():
					setInteractable(a.get_text(), a)
					a.interact()
					return
			#unInteract if there are areas but none are the npc or the npc is fighting
			if interactable:
				unInteract()
	else:
		#unInteract if there are no areas
		if interactable:
			unInteract()
