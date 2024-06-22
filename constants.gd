extends Node

var hp = 5
var yokai_count = 0
var human_count = 0
var form = "samurai"
var attackMode = "spam"
var textMode = "medium"
#Start the game with the correct position
var position = Vector2(722, 372)#Vector2(2349, 531)
var direction = 1
var fullscreen = false
var play_intro = false

func changeForm(_form):
	form = _form
	
func get_yokai():
	return yokai_count
	
func get_humans():
	return human_count

func get_hp():
	return hp
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
