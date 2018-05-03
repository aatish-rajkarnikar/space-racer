extends "res://scripts/meteor.gd"

func _ready():
	health = 10
	speed = rand_range(500,600)
	rotation_speed = rand_range(-3,3)