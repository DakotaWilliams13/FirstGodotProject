extends CharacterBody2D

var hide = false
var speed = 10
@onready var anim = $AnimatedSprite2D
var alive = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var player = $"../../Player/Player"
	
	if alive == true:
		if hide == true:
			velocity.x = 0
			anim.play("Hide")
		else:
			velocity.x -= speed
			anim.play("Idle")
			
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		hide = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		hide = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y -= 200
		death()

func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if alive == true:
			body.heath -= 10
		death()

func death():
	alive = false
	velocity.x = 0
	anim.play("Dead")
	await anim.animation_finished
	queue_free()
