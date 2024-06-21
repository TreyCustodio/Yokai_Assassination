extends Area2D

var count = 0
func getDamage():
	return 2
func getCount():
	return count
func incrementCount():
	count += 1
	if count == 3:
		count = 0
func decrementCount():
	count -= 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
