extends Area2D

signal finish

var fuel = 100
var health = 100
var distance = 0
onready var state = ReadyState.new(self)

const STATE_READY = 0
const STATE_PLAYING = 1
const STATE_HIT = 2
const STATE_FINISH = 3

func _ready():
	set_physics_process(true)
	set_process_input(true)
	pass

func _input(event):
	state.input(event)

func _physics_process(delta):
	state.update(delta)


func _on_player_area_entered(area):
	if area.get_groups().has("meteors"):
		area.hit(100)
		health -= area.health


func set_state(new_state):
	state.exit()
	if new_state == STATE_READY:
		state = ReadyState.new(self)
		pass
	elif new_state == STATE_PLAYING:
		state = PlayingState.new(self)
		pass
	elif new_state == STATE_HIT:
		state = HitState.new(self)
		pass
	elif new_state == STATE_FINISH:
		state = FinishState.new(self)
		pass


class ReadyState:
	var player
	func _init(player):
		self.player = player
		player.position = Vector2(600,1200)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass


class PlayingState:
	var player
	var screen_size
	var bullets
	var bullet = preload("res://scenes/bullet.tscn")
	var shooter = Timer.new()
	var fuel_timer = Timer.new()
	var distance_timer = Timer.new()
	
	func _init(player):
		self.player = player
		screen_size = player.get_viewport_rect().size
		
		bullets = Node.new()
		player.add_child(bullets)
		
		player.add_child(shooter)
		shooter.connect('timeout', self, '_on_shoot_bullet')
		shooter.wait_time = 0.1
		shooter.start()
		
		player.add_child(fuel_timer)
		fuel_timer.connect('timeout', self, '_on_fuel_timer_timeout')
		fuel_timer.wait_time = 0.5
		fuel_timer.start()
		
		player.add_child(distance_timer)
		distance_timer.connect('timeout', self, '_on_distance_timer_timeout')
		distance_timer.wait_time = 0.1
		distance_timer.start()
		pass
	
	func update(delta):
		if player.health <= 0:
			player.set_state(player.STATE_HIT)
		elif player.fuel <= 0:
			player.set_state(player.STATE_FINISH)
		pass
	
	func input(event):
		if event is InputEventScreenDrag:
			player.position += event.relative * 2
			if player.position.x < 0:
				player.position.x = 0
			elif player.position.x > screen_size.x:
				player.position.x = screen_size.x 
			
			if player.position.y < 0:
				player.position.y = 0
			elif player.position.y > screen_size.y:
				player.position.y = screen_size.y
		pass
	
	func exit():
		shooter.stop()
		fuel_timer.stop()
		bullets.queue_free()
		pass
	
	func _on_shoot_bullet():
		var new_left_bullet = bullet.instance()
		new_left_bullet.position = player.get_node('muzzle_left').get_global_transform().get_origin()
		bullets.add_child(new_left_bullet)
		
		var new_right_bullet = bullet.instance()
		new_right_bullet.position = player.get_node('muzzle_right').get_global_transform().get_origin()
		bullets.add_child(new_right_bullet)
	
	func _on_fuel_timer_timeout():
		player.fuel -= 1
	
	func _on_distance_timer_timeout():
		player.distance += 1

class HitState:
	var player
	var explosion_animation = preload("res://scenes/explosion.tscn")
	func _init(player):
		self.player = player
		var new = explosion_animation.instance()
		player.add_child(new)
		new.position = player.position
		new.play()
		player.set_state(player.STATE_FINISH)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass

class FinishState:
	var player
	
	func _init(player):
		self.player = player
		self.player.emit_signal('finish')
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass

