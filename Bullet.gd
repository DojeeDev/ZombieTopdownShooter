extends Area2D

var speed = 800
var damage = 10

func _physics_process(delta):
	position += transform.x *speed*delta

func explode():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method('damage'):
		body.damage(damage)
	explode()




func _on_VisibilityNotifier2D_screen_exited():
	explode()


func _on_LifeTime_timeout():
	explode()
