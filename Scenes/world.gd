extends Node2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var level_completed = $Node/LevelCompleted
@onready var camera_2d = $Camera2D
@onready var player = $Player

func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	Events.level_completed.connect(show_level_completed)
	player.follow_camera(camera_2d)

func show_level_completed():
	level_completed.show()
	get_tree().paused = true
