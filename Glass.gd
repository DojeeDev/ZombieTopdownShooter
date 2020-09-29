extends KinematicBody2D


func shatter():
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled",true)
	$Despawn.start()
	$CPUParticles2D.emitting = true

func _on_Despawn_timeout():
	queue_free()
