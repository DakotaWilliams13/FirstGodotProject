extends CharacterBody2D

enum {
	MOVE, 
	ATTACK,
	ATTACK2,
	ATTACK3,
	DEATH,
	BLOCK,
	DAMAGE,
	JUMP,
	RUN,
	WALK
}

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animPlayer = $AnimationPlayer
var health = 100
var gold = 0
var state = MOVE
var run_speed = 1
var combo = false
var attack_cooldown = false


func _physics_process(delta: float) -> void:
	match state: #анолог switch
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ATTACK2:
			attack2_state()
		ATTACK3:
			pass
		DEATH:
			pass
		BLOCK:
			block_state()
		DAMAGE:
			pass
		JUMP:
			pass
		RUN:
			pass
		WALK:
			pass
	
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animPlayer.play("Jump")

	
		
	if health <= 0:
		health = 0
		animPlayer.play("Death")
		await  animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")
		
	if velocity.y > 0:
		animPlayer.play("Fall")
	move_and_slide()

func move_state():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1:
				animPlayer.play("Walk")
			elif run_speed == 2:
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")

	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
		
	if Input.is_action_pressed("run"):
		run_speed = 2
	else:
		run_speed = 1
	
	if Input.is_action_pressed("block"):
		state = BLOCK
	
	if Input.is_action_just_pressed("attack") and attack_cooldown == false:
		state = ATTACK


func block_state():
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block"):
		state = MOVE
	
func attack_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack1")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE

func attack2_state():
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE

func combo1():
	combo = true
	await animPlayer.animation_finished
	combo = false

func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.3).timeout
	attack_cooldown = false
