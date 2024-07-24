extends CharacterBody2D


const SPEED = 300.0
const ACCELERATION = 600.0
const FRICTION = 1400.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var body = $Body
@onready var coyote_jump_timer = $CoyoteJumpTimer

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump() 
	handle_direction(Input.get_axis("ui_left", "ui_right"), delta)
	var was_on_floor = is_on_floor()	
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("action"):
			velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if Input.is_action_just_pressed("action") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

func handle_direction(direction, delta):
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		#Change this when the character have the properly sprite
		body.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
