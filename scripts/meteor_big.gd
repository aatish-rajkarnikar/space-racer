extends "res://scripts/meteor.gd"

func _ready():
	health = 50
	speed = rand_range(300,400)
	rotation_speed = rand_range(-3,3)