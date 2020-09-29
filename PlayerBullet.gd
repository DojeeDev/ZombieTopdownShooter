extends Area2D

var Particle_PS = preload("res://BloodParticles.tscn")

var hit = false
var damage = 25
var speed = 1000

func _physics_process(delta):
	if hit:
		speed = 0
	position += transform.x *speed*delta


func explode():
	$Sprite.hide()
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)
	$CollisionShape2D.set_deferred("disabled", true)

func make_particles(color):
	var p = Particle_PS.instance()
	add_child(p)
	p.emitting = true
	p.color_it(color)
	p.global_transform = self.global_transform


func _on_VisibilityNotifier2D_screen_exited():
	explode()


func _on_LifeTime_timeout():
	explode()


func _on_PlayerBullet_body_entered(body):
	$Despawn.start()
	hit = true
	explode()
	if body.has_method("shatter"):
		body.shatter()
	if body.is_in_group("enemies"):
		make_particles(body.particle_color)
	if body.has_method("damage"):
		body.damage(damage)



func _on_Despawn_timeout():
	queue_free()
