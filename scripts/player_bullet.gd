extends Area2D



func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	if get_node('Timer').is_stopped() :
		queue_free()
	else:
		position += Vector2(0,-3000) * delta
	pass



func _on_player_bullet_area_entered(area):
	if area.get_groups().has("meteors"):
		area.hit(10)
		queue_free()
	pass # replace with function body
