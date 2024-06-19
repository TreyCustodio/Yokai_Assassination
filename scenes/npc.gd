extends CharacterBody2D
@onready var healthbar = $healthbar
@onready var sprite = $sprite
@onready var hitzone = $hitzone
@onready var iframe_timer = $iframe_timer
@onready var hurtfx = $hurtfx
@onready var interact_icon = $interactIcon

const SPEED = 300.0
var vulnerable = true
var maxHp = 3
var hp = maxHp
var dead = false
var fighting = false
var interactable = false
var timer = 0.0
var modulo = Color(1,1,1,1)
var text = "hi"


func hit(damage):
	vulnerable = false
	iframe_timer.start()
	if not fighting:
		fighting = true
		healthbar.visible = true
		
	hp -= damage
	if hp <= 0:
		dead = true
		healthbar.animation = "0"
	else:
		hurtfx.play()
		sprite.modulate = Color(1,0,0,10)
		healthbar.play(str(hp))

func interact():
	interactable = true
	interact_icon.visible = true
	interact_icon.play("default")

func getText():
	return text
	
func _physics_process(delta):
	if hitzone.interactable and not interactable:
		interact()
	elif not hitzone.interactable and interactable:
		interactable = false
		interact_icon.visible = false
		interact_icon.stop()
		
	if vulnerable:
		if hitzone.has_overlapping_areas():
			var areas = hitzone.get_overlapping_areas()
			for a in areas:
				if a.is_in_group("weapon"):
					hit(a.getDamage())


func _on_iframe_timer_timeout():
	sprite.modulate = modulo
	iframe_timer.stop()
	vulnerable = true
