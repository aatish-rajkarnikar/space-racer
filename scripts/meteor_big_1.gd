extends Area2D

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	position += Vector2(0,500) * delta