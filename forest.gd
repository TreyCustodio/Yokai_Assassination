extends "res://room.gd"

var changing = false
func transition_routine():
	trans("palace.tscn", Vector2(820, 457))


func playCutscene():
	if player.is_on_floor():
		if changing:
			if player.shifting == false:
				changing = false
				cutscene = false
				displayText("&Press SPACE to change forms.|As a Samurai, press SHIFT\nto do an evasive backstep.|As a Kitsune, press SHIFT\nto lunge forth and bite.", 6)
			return
		elif player.form == "samurai":
			cutscene = false
			displayText("&Press SPACE to change forms.|As a Samurai, press SHIFT\nto do an evasive backstep.|As a Kitsune, press SHIFT\nto lunge forth and bite.", 5)
		else:
			changing = true
			player.changeForm()
		

				
				
func _on_info_body_entered(body):
	if Constants.forest_info:
		if body.is_in_group("player"):
			Constants.forest_info = false
			cutscene = true
	
	
		# Replace with function body.
