extends Area2D
@onready var castle = $".."
var falling = false
@onready var box = $"../box"
@onready var rect = $rect
@onready var rope = $"../box/rope"
@onready var npc_4 = $"../enemies/npc4"

func _on_area_entered(area):
	if area.is_in_group("weapon"):
		rect.disabled = true
		rope.visible = false
		falling = true

func _physics_process(delta):
	if falling:
		box.position.y += 5
		if box.position.y >= 671 - 12:
			box.position.y = 671 - 12
			falling = false
		if npc_4.visible and box.position.y >= 630:
			npc_4.visible = false
			npc_4.dead = true
		
