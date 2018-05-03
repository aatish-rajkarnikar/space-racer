extends Area2D

export var speed = 300
export var angle = 0
export var rotation_speed = 1
export var health = 100
onready var screen_size = get_viewport().get_visible_rect().size

signal exploded

func _ready():
	add_to_group("meteors")
	set_physics_process(true)

func _physics_process(delta):
	position += Vector2(angle,speed) * delta
	rotation += rotation_speed * delta
	if position.y > screen_size.y + 50 || health <= 0:
		emit_signal("exploded",position)
		queue_free()


func hit(value):
	health -= value