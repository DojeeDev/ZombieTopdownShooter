extends KinematicBody2D

signal zombie_path_changed(zombie,start,end)
signal health_updated(health)
signal killed

var damage = 50
var speed = 100
var path : = PoolVector2Array()
var next_point
var target
var particle_color = Color(1.0,0.1,0.0)
var offset = Vector2(-20,-20)
var velocity = Vector2()
var anchor = Vector2()
var dead_zone_radius = 15

export (float) var max_health = 50

onready var health = max_health setget _set_health
onready var health_bar = $NoRotate/Healthbar
onready var Nav2D = get_parent()


func _change_path(start,end):
	var path_to_player = Nav2D.get_simple_path(start,end)
	path = path_to_player


func _dead_zone(deadZone):
	var difference = anchor.distance_to(target.position)
	if difference > deadZone:
		anchor = target.position
		_change_path(position,anchor)


func kill():
	queue_free()

func _ready():
	health_bar._on_max_health_updated(max_health)

func damage(amount):
	_set_health(health-amount)
	$Effects.play("damage")

func _process(delta):
	update_health_bar_position(offset)

func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")

func hear_player(go_to):
	emit_signal("zombie_path_changed",self,global_position,go_to)

func update_health_bar_position(offset):
	health_bar.set_position(global_position+offset)

func _physics_process(delta):
	if target != null:
		var look_towards = (target.global_position-global_position).angle()
		rotation = look_towards
		_dead_zone(dead_zone_radius)
#		_change_path(global_position,target.global_position)
#		hear_player(target.global_position)
	
	
	
	#walk code
	var distance_to_walk = speed*delta
	
	
	while distance_to_walk >0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		velocity = position.direction_to(path[0])*speed
		next_point = path[0]
		if distance_to_walk <= distance_to_next_point:
			move_and_slide(velocity)
		else:
			position = path[0]
			path.remove(0)
		distance_to_walk -= distance_to_next_point

func _on_PlayerHear_body_entered(body):
	if target:
		return
	target = body
	if target:
		anchor = target.position
		_change_path(position,anchor)

func _on_PlayerHear_body_exited(body):
	if body == target:
		target = null


func _on_PlayerKill_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)


func _on_Zombie_health_updated(health):
	health_bar._on_heath_bar_updated(health)

