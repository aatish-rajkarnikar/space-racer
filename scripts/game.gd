extends Node

onready var state = ReadyState.new(self)
var player_node

const STATE_READY = 0
const STATE_PLAY = 1
const STATE_FINISH = 2

func _ready():
	set_physics_process(true)
	set_process_input(true)
	pass

func _input(event):
	state.input(event)

func _physics_process(delta):
	state.update(delta)

func set_state(new_state):
	state.exit()
	if new_state == STATE_READY:
		state = ReadyState.new(self)
		pass
	elif new_state == STATE_PLAY:
		state = PlayingState.new(self)
		pass
	elif new_state == STATE_FINISH:
		state = FinishState.new(self)
		pass


class ReadyState:
	var game
	var start_node
	var start_scene = preload("res://scenes/start.tscn")
	var player_scene = preload("res://scenes/player.tscn")
	
	func _init(game):
		self.game = game
		self.game.player_node = player_scene.instance()
		start_node = start_scene.instance()
		game.add_child(self.game.player_node)
		game.add_child(start_node)
		pass
	
	func input(event):
		if event is InputEventScreenTouch && event.is_pressed():
			game.set_state(game.STATE_PLAY)
		pass
	
	func update(delta):
		pass
	
	func exit():
		start_node.queue_free()
		pass

class PlayingState:
	var hud_scene = preload("res://scenes/hud.tscn")
	var meteor_big_1 = preload("res://scenes/meteor_big_1.tscn")
	var meteor_big_2 = preload("res://scenes/meteor_big_2.tscn")
	var meteor_big_3 = preload("res://scenes/meteor_big_3.tscn")
	var meteor_medium = preload("res://scenes/meteor_medium.tscn")
	var meteor_small = preload("res://scenes/meteor_small.tscn")
	var explosion_animation = preload("res://scenes/explosion.tscn")
	var big_meteor_spwaner = Timer.new()
	var medium_meteor_spwaner = Timer.new()
	var small_meteor_spwaner = Timer.new()
	var game
	var screen_size
	var meteors_node
	var hud_node
	func _init(game):
		self.game = game
		screen_size = game.get_viewport().get_visible_rect().size
		meteors_node = Node.new()
		game.add_child(meteors_node)
		
		hud_node = hud_scene.instance()
		game.add_child(hud_node)
		
		game.player_node.set_state(game.player_node.STATE_PLAYING)
		game.player_node.connect('finish',self, '_on_player_finish')
		
		big_meteor_spwaner.wait_time = 0.3
		medium_meteor_spwaner.wait_time = 0.1
		small_meteor_spwaner.wait_time = 0.05
		
		big_meteor_spwaner.connect("timeout",self,"_on_big_meteor_spwan_timer_timeout")
		medium_meteor_spwaner.connect("timeout",self,"_on_medium_meteor_spwan_timer_timeout")
		small_meteor_spwaner.connect("timeout",self,"_on_small_meteor_spwan_timer_timeout")
		
		self.game.add_child(big_meteor_spwaner)
		self.game.add_child(medium_meteor_spwaner)
		self.game.add_child(small_meteor_spwaner)
		
		big_meteor_spwaner.start()
		medium_meteor_spwaner.start()
		small_meteor_spwaner.start()
		pass
	
	func input(event):
		pass
	
	func update(delta):
		hud_node.get_node('fuel').value = game.player_node.fuel
		hud_node.get_node('distance').text = str(game.player_node.distance) + 'm'
		pass
	
	func exit():
		big_meteor_spwaner.stop()
		medium_meteor_spwaner.stop()
		small_meteor_spwaner.stop()
		game.player_node.queue_free()
		hud_node.queue_free()
		pass
	
	func _on_big_meteor_spwan_timer_timeout():
		var random_x = randf()*screen_size.y
		var big_meteors = [meteor_big_1, meteor_big_2, meteor_big_3]
		
		var new_meteor = big_meteors[int(rand_range(0,3))].instance()
		new_meteor.connect("exploded",self,"_on_big_meteor_explode")
		meteors_node.add_child(new_meteor)
		new_meteor.position = Vector2(random_x,0)


	func _on_medium_meteor_spwan_timer_timeout():
		var random_x = randf()*screen_size.y
		var new_meteor = meteor_medium.instance()
		new_meteor.connect("exploded",self,"_on_medium_meteor_explode")
		meteors_node.add_child(new_meteor)
		new_meteor.position = Vector2(random_x,0)

	func _on_small_meteor_spwan_timer_timeout():
		var random_x = randf()*screen_size.y
		var new_meteor = meteor_small.instance()
		new_meteor.connect("exploded",self,"_on_small_meteor_explode")
		meteors_node.add_child(new_meteor)
		new_meteor.position = Vector2(random_x,0)

	func _on_big_meteor_explode(position):
		var new = explosion_animation.instance()
		game.add_child(new)
		new.position = position
		new.play()

	func _on_medium_meteor_explode(position):
		var new = explosion_animation.instance()
		new.scale = Vector2(0.5,0.5)
		game.add_child(new)
		new.position = position
		new.play()

	func _on_small_meteor_explode(position):
		var new = explosion_animation.instance()
		new.scale = Vector2(0.3,0.3)
		game.add_child(new)
		new.position = position
		new.play()
	
	func _on_player_finish():
		game.set_state(game.STATE_FINISH)


class FinishState:
	var game
	var finish_scene = preload('res://scenes/finish.tscn')
	var finish_node
	
	func _init(game):
		self.game = game
		finish_node = finish_scene.instance()
		game.add_child(finish_node)
		pass
	
	func input(event):
		if event is InputEventScreenTouch && event.is_pressed():
			game.set_state(game.STATE_READY)
		pass
	
	func update(delta):
		pass
	
	func exit():
		finish_node.queue_free()
		pass