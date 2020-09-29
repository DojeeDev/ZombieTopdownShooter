extends Node2D

onready var humans = $Humans
onready var timer = $Timer

func _on_Timer_timeout():
	humans._check_if_saved()


func _on_Humans_win():
	timer.set_deferred("one_shot",true)
	timer.stop()
	print_debug("win")

