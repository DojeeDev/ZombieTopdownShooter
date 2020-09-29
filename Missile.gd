extends Area2D


export var speed = 200
export var steer_force = 400.0
export var damage = 10

var velocity = Vector2()
var acceleration = Vector2()
var target = null

func start(_transform,_target):
	target = _target
	global_transform = _transform
	velocity = transform.x *speed

func seek():
	var steer = Vector2()
	if target:
		var desired = (target.position-position).normalized()*speed
		steer = (desired-velocity).normalized()*steer_force
	
	
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration*delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity*delta

func _on_Missile_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)
	explode()


func _on_Timer_timeout():
	explode()


func explode():
	queue_free()
