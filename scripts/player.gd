extends Area2D

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")
onready var screen_size = get_viewport_rect().size
func _ready():
	set_physics_process(true)
	set_process_input(true)
	pass

func _input(event):
	if event is InputEventScreenDrag:
		position += event.relative * 2
		if position.x < 0:
			position.x = 0
		elif position.x > screen_size.x:
			position.x = screen_size.x 
		
		if position.y < 0:
			position.y = 0
		elif position.y > screen_size.y:
			position.y = screen_size.y
	pass

func _physics_process(delta):
	if gun_timer.is_stopped():
		shoot()
	
	pass

func shoot():
	gun_timer.start()
	var new_left_bullet = bullet.instance()
	new_left_bullet.position = get_node('muzzle_left').get_global_transform().get_origin()
	bullet_container.add_child(new_left_bullet)
	
	var new_right_bullet = bullet.instance()
	new_right_bullet.position = get_node('muzzle_right').get_global_transform().get_origin()
	bullet_container.add_child(new_right_bullet)
