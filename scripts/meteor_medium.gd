extends "res://scripts/meteor.gd"

func _ready():
	health = 20
	speed = rand_range(400,500)
	rotation_speed = rand_range(-3,3)