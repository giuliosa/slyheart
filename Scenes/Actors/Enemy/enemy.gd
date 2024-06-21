extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $WallDetector as RayCast2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := 1 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta 
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1 
		
	velocity.x = direction * SPEED 
	
	move_and_slide()
	
func must_die():
	return true
