extends CharacterBody2D


const SPEED = 550.0
const AIR_FRICTION = 0.5

var is_jumping: bool
var can_jump := true
var life := 10
var knockback_vector := Vector2.ZERO
var knockback_power := 20
var wall_normal
var jump_count = 0
var max_jumps = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var jump_height := 200
@export var max_time_to_peak := 0.5

var jump_velocity
var gravity 
var fall_gravity

@onready var player_body := $Body as Sprite2D
@onready var remote_transform := $Remote as RemoteTransform2D
@onready var life_label := $Life as Label
@onready var coyote_timer := $CoyoteTimer as Timer

func _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2) 
	fall_gravity = gravity * 2

func _physics_process(delta):	
	life_label.text = str(life)
	
	# Add the gravity.
	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.x = 0

	if is_on_wall_only() and not is_on_floor():
		#velocity.y = fall_gravity
		wall_normal = get_wall_normal()

	# Handle jump.
	if Input.is_action_just_pressed("action") and jump_count < max_jumps and can_jump:
		velocity.y = -jump_velocity
		is_jumping = true
		jump_count += 1
			
			
		if is_on_wall():
			jump_count = 1
			print(wall_normal)
			if wall_normal == Vector2.LEFT:
				velocity = lerp(wall_normal, Vector2(wall_normal.x * jump_velocity, -jump_velocity), 1.8)
			if wall_normal == Vector2.RIGHT:
				velocity = lerp(wall_normal, Vector2(wall_normal.x * jump_velocity, -jump_velocity), 1.8)
			
			
	elif is_on_floor():
		is_jumping = false
		jump_count = 0
		
	if is_on_floor() and !can_jump:
		can_jump = true
	elif can_jump and coyote_timer.is_stopped():
		coyote_timer.start()
	
	if velocity.y > 0 or not Input.is_action_pressed("action"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		player_body.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	
	move_and_slide()
	
func follow_camera(camera): 
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func _on_hurtbox_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	if life <= 0:
		queue_free()
	else:		
		take_damage(knockback)

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		player_body.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(player_body, "modulate", Color(1,1,1,1), duration)


func _on_coyote_timer_timeout():
	can_jump = false
