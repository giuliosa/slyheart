extends CharacterBody2D

@export var movement_data: PlayerMovementData

var air_jump := false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_wall_normal := Vector2.ZERO

@onready var body := $Body
@onready var coyote_jump_timer := $CoyoteJumpTimer
@onready var wall_jump_timer := $WallJumpTimer
@onready var starting_position := global_position
@onready var remote := $Remote

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	handle_wall_jump()
	handle_jump() 
	
	var input_axis := Input.get_axis("ui_left", "ui_right")
	body.flip_h = input_axis < 0
		
	handle_air_acceleration(input_axis, delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	
	var was_on_floor := is_on_floor()
	var was_on_wall := is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()
	move_and_slide()
	
	var just_left_ledge := was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
		
	var just_left_wall := was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_jump_timer.start()

func apply_gravity(delta: float)-> void:
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta

func handle_jump()-> void:
	if is_on_floor(): air_jump = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("action"):
			velocity.y = movement_data.jump_velocity
	elif not is_on_floor():
		if Input.is_action_just_pressed("action") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
			
		if Input.is_action_just_pressed("action") and air_jump:
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

func handle_wall_jump()-> void:
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0: return
	
	var wall_normal := get_wall_normal()
	
	if wall_jump_timer.time_left > 0.0:
		wall_normal = was_wall_normal
	
	if Input.is_action_just_pressed("action") and wall_normal:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity 
			
func handle_acceleration(input_axis: float, delta: float)-> void:
	if not is_on_floor(): return
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * delta)
		#Change this when the character have the properly sprite
		

func handle_air_acceleration(input_axis: float, delta: float)-> void:
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_friction(input_axis: float, delta: float)-> void:
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		

func apply_air_resistance(input_axis: float, delta: float)-> void:
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistence * delta)

func follow_camera(camera: Camera2D)-> void: 
	var camera_path := camera.get_path()
	remote.remote_path = camera_path
	


func _on_hazard_detector_area_entered(_area)-> void:
	global_position = starting_position
