extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	var is_flying = false
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite.play("jump")
		is_flying = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		if not is_flying:
			sprite.play('walk')
	else:
		velocity.x = move_toward(velocity.x, 0,  SPEED)
		if not is_flying:
			sprite.play('idle')
	
	move_and_slide()
	# Pushing Logic
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Check if the object has the "ball_group" tag
		if collider.is_in_group("balls"):
			# 'normal' is the direction of the hit
			# We multiply by a negative number to push AWAY from the player
			var push_direction = -collision.get_normal()
			
			# 200.0 is the force. Adjust this to your liking!
			collider.apply_central_impulse(push_direction * 200.0)
