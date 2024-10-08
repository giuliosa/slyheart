extends Node2D

const WAIT_DURATION := 1.0

@onready var plataform := $plataform as AnimatableBody2D
@export var move_speed := 3.0
@export var distance := 192
@export var direction := Vector2.RIGHT

var follow := Vector2.ZERO
var plataform_center := 16

func _ready()-> void:
	move_plataform()
	
func _physics_process(delta: float)-> void:
	plataform.position = plataform.position.lerp(follow, 0.5 * delta)

func move_plataform()-> void:
	var move_direction := direction * distance 
	var duration := move_direction.length() / float(move_speed * plataform_center)
	
	var plataform_tween := create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	plataform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
	plataform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(duration + WAIT_DURATION * 2)
