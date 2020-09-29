extends Node2D


var last_known_player_position = Vector2()
var player_position = Vector2()
var no_rotation

func _ready():
	no_rotation = global_rotation


func _input(event):
	if event.is_action_pressed("test_button"):
		get_tree().reload_current_scene()

"""
export (float) var max_health = 100

onready var health = max_health setget _set_health


func kill():
	print_debug("ded boi")



func damage(amount):
	_set_health(health-amount)


func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")






"""
