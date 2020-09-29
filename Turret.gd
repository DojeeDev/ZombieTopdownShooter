extends KinematicBody2D

var Missile_PS = preload("res://Missile.tscn")

onready var muzzle = $Body/barrel/Muzzle
onready var barrel = $Body/barrel
onready var shoot_timer = $CanShootTimer

var can_shoot = true
var target = null
var hit_pos

func shoot_missile():
	print_debug("shoot")
	var m = Missile_PS.instance()
	owner.add_child(m)
	m.start(muzzle.global_transform,target)
	shoot_timer.start()
	can_shoot = false
	


func aim_to(_target):
	var aim_to = (_target.position-position).angle()
	return aim_to


func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position,target.position,[self],collision_mask)
	
	
	if result:
		hit_pos = result.position
		if result.collider.name == "Player":
			barrel.rotation = aim_to(result)
			if can_shoot:
				print_debug("willshoot")
				shoot_missile()



func _physics_process(delta):
	if target:
		aim()
		

func _on_DetectPlayer_body_entered(body):
	if target:
		return
	target = body



func _on_DetectPlayer_body_exited(body):
	if body == target:
		target = null


func _on_CanShootTimer_timeout():
	can_shoot = true
