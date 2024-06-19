extends Area2D
@onready var player = $".."

var interactable = false
var displayText = ""
var interactableObject = null

func setInteractable(text):
	interactable = true
	player.setInteractable(text)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_overlapping_areas():
		if not interactable:
			var areas = get_overlapping_areas()
			for a in areas:
				if a.is_in_group("enemy"):
					setInteractable(a.get_text())
					a.interact()
					interactableObject = a
					
	elif interactable:
		player.unsetInteractable()
		if interactableObject != null:
			interactableObject.unInteract()
		interactable = false
		displayText = ""
	

