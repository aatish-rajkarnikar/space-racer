extends Node

var meteor_big = preload("res://scenes/meteor_big_2.tscn")
var meteor_medium = preload("res://scenes/meteor_medium.tscn")
var meteor_small = preload("res://scenes/meteor_small.tscn")
var explosion_animation = preload("res://scenes/explosion.tscn")
onready var screen_size = get_viewport().get_visible_rect().size
onready var meteor_spwan_timer = get_node("meteor_spwan_timer")

func _ready():
	meteor_spwan_timer.connect("timeout",self,"_on_meteor_spwan_timer_timeout")
	


func _on_meteor_spwan_timer_timeout():
	var random_x = randf()*screen_size.y
	var new_meteor = meteor_big.instance()
	new_meteor.connect("exploded",self,"_on_big_meteor_explode")
	add_child(new_meteor)
	new_meteor.position = Vector2(random_x,0)


func _on_medium_meteor_spwan_timer_timeout():
	var random_x = randf()*screen_size.y
	var new_meteor = meteor_medium.instance()
	new_meteor.connect("exploded",self,"_on_medium_meteor_explode")
	add_child(new_meteor)
	new_meteor.position = Vector2(random_x,0)



func _on_small_meteor_spwan_timer_timeout():
	var random_x = randf()*screen_size.y
	var new_meteor = meteor_small.instance()
	new_meteor.connect("exploded",self,"_on_small_meteor_explode")
	add_child(new_meteor)
	new_meteor.position = Vector2(random_x,0)

func _on_big_meteor_explode(position):
	var new = explosion_animation.instance()
	add_child(new)
	new.position = position
	new.play()
	
func _on_medium_meteor_explode(position):
	var new = explosion_animation.instance()
	new.scale = Vector2(0.5,0.5)
	add_child(new)
	new.position = position
	new.play()

func _on_small_meteor_explode(position):
	var new = explosion_animation.instance()
	new.scale = Vector2(0.3,0.3)
	add_child(new)
	new.position = position
	new.play()

