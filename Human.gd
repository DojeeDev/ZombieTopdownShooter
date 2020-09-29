extends Area2D


signal human_freed


var offset = Vector2(-50,-50)
onready var human_say_label = $Node/HumanSay


func _ready():
	_set_label_position()

func _set_label_position():
	human_say_label.set_global_position(global_position+offset)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	emit_signal("human_freed")


func _on_Human_body_entered(body):
	$AnimationPlayer.play("fade")

