extends KinematicBody2D
export var test = ""

var Bullet_PS = preload("res://Bullet.tscn")
var playerseen = false
var target
var speed = 50
var path : = PoolVector2Array()
var can_shoot = true
var hit_pos
var next_point
var particle_color = Color(0.4,0.4,0.4)
var offset = Vector2(-30,-30)
var anchor = Vector2()

signal path_updated(robot,start,end)
signal health_updated(health)
signal killed()


onready var muzzle = $Muzzle
onready var shoot_cooldown = $ShootCooldown
onready var health_bar = $NoRotate/Healthbar
onready var Nav2D = get_parent()

var dead_zone = 25
onready var playerseenlabel = $PlayerSeen

export (float) var max_health = 200

onready var health = max_health setget _set_health


func kill():
	queue_free()

func _ready():
	health_bar._on_max_health_updated(max_health)
	damage(1)

func _process(delta):
	update_health_bar_position(offset)


func damage(amount):
	_set_health(health-amount)
	$EffectsAnimation.play("damage")

func update_health_bar_position(offset):
	health_bar.set_position(global_position+offset)

func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")


func _dead_zone(deadZone):
	var difference = anchor.distance_to(target.position)
	if difference > deadZone:
		anchor = target.position
		_change_path(position,anchor)

func _physics_process(delta):
	if target != null:
		aim()
	var distance_to_walk = speed*delta
	
	
	while distance_to_walk >0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		next_point = path[0]
		if distance_to_walk <= distance_to_next_point:
			position += position.direction_to(path[0])*distance_to_walk
		else:
			position = path[0]
			path.remove(0)
		distance_to_walk -= distance_to_next_point

func shoot():
	var b = Bullet_PS.instance()
	owner.add_child(b)
	b.transform = muzzle.global_transform
	shoot_cooldown.start()
	can_shoot = false


func _change_path(start,end):
	path = Nav2D.get_simple_path(start,end)


func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position,target.position,[self],collision_mask)
	
	if result:
		hit_pos = result.position
		if result.collider.name == "Player":
			playerseen = true
			_dead_zone(dead_zone)
			rotation = (target.position-position).angle()
			if can_shoot:
				shoot()
		else:
			playerseen = false
	else:
		playerseen = false

func found_player_alarm(go_to):
	emit_signal("path_updated",self,global_position,go_to)



func _on_PlayerVisible_body_entered(body):
	if target:
		return
	target = body
	if target:
		anchor = target.global_position
	


func _on_PlayerVisible_body_exited(body):
	if body == target:
		target = null





func _on_ShootCooldown_timeout():
	can_shoot = true


func _on_Guard_health_updated(health):
	health_bar._on_heath_bar_updated(health)
