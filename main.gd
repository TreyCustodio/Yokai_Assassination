extends Node2D

var hp = 5
var yokai_count = 0
var human_count = 0

func get_hp():
	return hp

func get_yokai():
	return yokai_count
	
func get_humans():
	return human_count
	
func increase_yokai():
	yokai_count += 1

func increase_humans():
	human_count += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
