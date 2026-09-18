extends CharacterBody2D

@export var walk_speed: float = 150.0
@export var run_speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 1200.0

@onready var animated_sprite: AnimatedSprite2D = $Sprite2D


func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta


	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity


	# Left / Right movement
	var direction := Input.get_axis("ui_left", "ui_right")


	# Walk or Run
	if Input.is_key_pressed(KEY_SHIFT):
		velocity.x = direction * run_speed
	else:
		velocity.x = direction * walk_speed


	# Stop when no movement key is pressed
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


	# Flip character
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false


	# Choose animation
	if not is_on_floor():
		animated_sprite.play("jump")

	elif direction != 0:
		if Input.is_key_pressed(KEY_SHIFT):
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")

	else:
		animated_sprite.stop()


	# Actually move the character
	move_and_slide()
