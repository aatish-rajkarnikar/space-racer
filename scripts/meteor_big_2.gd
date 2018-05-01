extends Area2D

export var speed = 300
export var rotation_speed = 1
onready var screen_size = get_viewport().get_visible_rect().size

var health = 50
signal exploded

func _ready():
	add_to_group("meteors")
	set_physics_process(true)

func _physics_process(delta):
	position += Vector2(0,speed) * delta
	rotation += rotation_speed * delta
	if position.y > screen_size.y + 50 || health <= 0:
		emit_signal("exploded",position)
		queue_free()

func _on_Area2D_area_entered(area):
	pass # replace with function body
	
func hit(value):
	health -= value