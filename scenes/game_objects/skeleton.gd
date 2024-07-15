extends CharacterBody2D
@onready var animation_player = %AnimationPlayer
@onready var skeleton_image = %SkeletonImage


@export var speed = 20
@export var stop_distance = 10

var player_chase = false
var player = null
var isLeft = false
var attack1 = null
var is_hit = false

func _physics_process(delta):
	if (player_chase and player != null ):
		var distance_to_player = position.distance_to(player.position)
		
		if distance_to_player > stop_distance:
			position += (player.position - position).normalized() * speed * delta
			animation_player.play("walk")
		else:
			animation_player.play("idle")
			
		if (player.position.x - position.x < 0):
			isLeft = true
		else:
			isLeft = false
		
		skeleton_image.flip_h = isLeft
	
	#Take Damage
	if is_hit:
		print("Skeleton hit")

func _on_vision_area_body_entered(body):
	if (body.name == "CharacterBody2D"):
		print("body entered")
		player = body
		player_chase = true
		

func _on_vision_area_body_exited(body):
	if body == player:
		print("body exited")
		player = null
		player_chase = false
		animation_player.play("idle")
		

func _on_hit_detection_area_body_entered(body):
	print(body.name)
	if  body.name == "CharacterBody2D":
		print("Player's attack detected:", body.name)
		attack1 = body
		is_hit = true
		print("Damage")


func _on_hit_detection_area_body_exited(attack):
	pass # Replace with function body.
