extends Node

var hp = 5
var yokai_count = 0
var human_count = 0
var form = "samurai"
var attackMode = "spam"
var textMode = "medium"
#Start the game with the correct position
var position = Vector2(722, 372)
var direction = 1
var fullscreen = false
var play_intro = true
var forest_info = true
var castle_info = true

##Forest
var enemy_1 = true
var enemy_2 = true
var enemy_3 = true
##Gate
var enemy_4 = true
var enemy_5 = true
##Castle
#Pair 1
var enemy_6 = true #human, "Haruko-sama!"
var enemy_7 = true #yokai, "Haruko!"

#Pair 2
var enemy_8 = true #human
var enemy_9 = true #human

#Indiv
var enemy_10 = true #human, "Man, I'm drowsy... You smell like someone I know..."
#Indiv
var enemy_11 = true #yokai, "you're carrying the aroma of a fox with you!"

var enemy_12 = true
var enemy_13 = true






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
