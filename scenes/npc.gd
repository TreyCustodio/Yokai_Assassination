extends CharacterBody2D
@onready var healthbar = $healthbar
@onready var sprite = $sprite
@onready var hitzone = $hitzone
@onready var hitbox = $hitzone/hitbox
@onready var iframe_timer = $iframe_timer
@onready var hurtfx = $hurtfx
@onready var interact_icon = $interactIcon
@onready var attackzone = $attackzone
@onready var slash_rect = $attackzone/slash_rect
@onready var slash_detect = $attackzone/slash_detect
@onready var speech = $speech

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
var slashing = false
var slash_tick = 0 #Done after 3
var direction = -1
var waiting = false
var frozen = false

func freeze():
	frozen = true
	if fighting:
		healthbar.pause()
		sprite.pause()
	
	
func unFreeze():
	frozen = false
	if fighting:
		sprite.play()
		healthbar.play()
	
func flip():
	sprite.flip_h = not sprite.flip_h
	direction *= -1
	if direction == 1:
		interact_icon.position.x = sprite.position.x + 16
		hitzone.position.x = sprite.position.x + (hitbox.shape.get_rect().size.x -18)
		attackzone.position.x = sprite.position.x + (34 + slash_rect.shape.get_rect().size.x)
	elif direction == -1:
		interact_icon.position.x = sprite.position.x - 16
		hitzone.position.x = sprite.position.x
		attackzone.position.x = sprite.position.x - 54
	
func hit(damage):
	vulnerable = false
	iframe_timer.start()
	if not fighting:
		unInteract()
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

func playAnimation(name):
	sprite.play(name)

func unInteract():
	interactable = false
	interact_icon.visible = false
	
func interact():
	interactable = true
	interact_icon.visible = true
	interact_icon.play("default")

func getText():
	return text

func slash():
	slashing = true
	if direction == -1:
		sprite.offset.x -= 32
	elif direction == 1:
		sprite.offset.x += 32
	sprite.play("slashing")
	
func _physics_process(delta):
	##Damage routine
	if vulnerable:
		if hitzone.has_overlapping_areas():
			var areas = hitzone.get_overlapping_areas()
			for a in areas:
				if a.is_in_group("weapon"):
					hit(a.getDamage())
					
	##Movement and attack pattern
	if fighting and not frozen:
		if slashing:
			update_attack(delta)
			if attackzone.has_overlapping_bodies():
				if not slash_rect.disabled:
					var areas = attackzone.get_overlapping_bodies()
					for a in areas:
						if a.is_in_group("player"):
							a.hit()
		elif attackzone.has_overlapping_bodies():
			var areas = attackzone.get_overlapping_bodies()
			for a in areas:
				if a.is_in_group("player"):
					slash()
		else:
			sprite.play("running")
			if direction == 1:
				position.x += 2
			elif direction == -1:
				position.x -= 2

func update_position(player_x):
	if not slashing and not frozen:
		if player_x < position.x:
			if not sprite.flip_h:
				flip()
		elif player_x > position.x + 64:
			if sprite.flip_h:
				flip()
			
func update_attack(delta):
	if waiting:
		if sprite.frame == 11:
			waiting = false
			slashing = false
			if direction == -1:
				sprite.offset.x += 32
			elif direction == 1:
				sprite.offset.x -= 32
			sprite.play("default")
		return
	if sprite.frame == 5:
		if slash_rect.disabled:
			slash_rect.disabled = false
	elif sprite.frame == 8:
		slash_tick += 1
		if slash_tick == 3:
			slash_rect.disabled = true
			waiting = true
			slash_tick = 0
		else:
			sprite.frame = 5
			
	
func _on_iframe_timer_timeout():
	sprite.modulate = modulo
	iframe_timer.stop()
	vulnerable = true
