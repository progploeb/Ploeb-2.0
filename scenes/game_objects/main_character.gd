extends CharacterBody2D

@onready var hitbox_attack_1 = %HitboxAttack1
@onready var character_image = %CharacterImage
@onready var animation_player = %AnimationPlayer




const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const COMBO_TIMEOUT = 0.65 #combo zeitfenster
var isLeft = false
var current_attack = 0
var can_attack = true
var combo_timer = 0.0
var attack2_queued = false


func _ready():
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	#Interact/Use
	if (Input.is_action_just_pressed("use")):
		pass


	#Movement
	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	if (direction.length() > 0):
		direction = direction.normalized()
	
	velocity = direction * SPEED
	
	move_and_slide()
	
	if (direction.x <0):
		isLeft = true
	elif(direction.x >0):
		isLeft = false
	else:
		pass
		
	character_image.flip_h = isLeft
	
	#Animations
	if (Input.is_action_pressed("attack")):
		if can_attack:
			hitbox_attack_1.disabled = false
		
	else:
		hitbox_attack_1.disabled = true
		
	if ((direction.y != 0 or direction.x != 0) and not animation_player.current_animation.begins_with("attack")):
		animation_player.play("walk")
		
	elif ((direction.y == 0 or direction.x == 0) and not animation_player.current_animation.begins_with("attack")): 
		animation_player.play("idle")
	else:
		pass
		
	#Special Attack
	if (Input.is_action_pressed("special")):
		if can_attack:
			animation_player.play("attack3")
			can_attack = false
			reset_combo()
			current_attack = 3
		
	#Combo Attack
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			if current_attack == 0:
				attack1()
			elif current_attack == 1:
				queue_attack2()
			
		
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			reset_combo()
	
	
	
	
	
func attack1():
	if can_attack:
		current_attack = 1
		animation_player.play("attack1")
		combo_timer = COMBO_TIMEOUT
		can_attack = true
		attack2_queued = false
	
func attack2():
	if can_attack:
		current_attack = 2
		animation_player.play("attack2")
		combo_timer = 0 #stop combo timer
		can_attack = true
	
func reset_combo():
	current_attack = 0
	can_attack = true
	combo_timer = 0
	attack2_queued = false

func queue_attack2():
	attack2_queued = true

func _on_animation_finished(anim_name):
	if anim_name == "attack1":
		if attack2_queued: #attack 2 Starterlaubnis erteilt 🚀
			attack2()
		else:
			can_attack = true
	elif anim_name == "attack2":
		reset_combo()
	elif anim_name == "attack3":
		can_attack = true
		current_attack = 0


#Hitable Enemies (Hitbox Detection and Hit Animation)  Wieso hit nicht detected? Vision Area stört (eig nicht weil layer), Name falsch? (group ging auch nicht), wenn mask auf player geändert funktioniert.
#Attack Hitbox Management


#Char flippen wenn Attack+Maus Links/Rechts (oben/unten?)
