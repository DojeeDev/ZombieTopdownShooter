extends Node2D

signal win

func _check_if_saved():
	if get_child_count() == 0:
		emit_signal("win")
