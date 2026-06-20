extends CharacterBody2D

var chase = false
var speed = 100
@onready var anim = $AnimatedSprite2D
var alive = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#var player = get_tree().current_scene.get_node("Player")
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
													#Нормализация в Godot — это операция, при которой вектор приводится к длине 1, 
													#сохраняя при этом его направление. Это позволяет представить вектор только 
													#как указатель направления, а не как меру расстояния. 
	if alive == true:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("Idle")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
			
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y -= 200
		death()

func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if alive == true:
			body.heath -= 40
		death()

func death():
	alive = false
	velocity.x = 0
	anim.play("Death")
	await anim.animation_finished
	queue_free()
