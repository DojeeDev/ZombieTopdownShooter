extends Area2D

signal human_escaped

var offset = Vector2(-50,-50)
onready var human_say_label = $Node/HumanSay

func _set_label_position():
	human_say_label.set_global_position(global_position+offset)

func _ready():
	_set_label_position()


func _on_Human3_body_entered(body):
	$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	emit_signal("human_escaped")
