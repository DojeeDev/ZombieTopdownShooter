extends Node


onready var parent = get_parent()

var rotation
var position_of_parent
var transform


func _find_parent_info(pos):
	if parent:
		if pos ==1:
			return parent.global_position
		elif pos ==2:
			return parent.global_rotation
		elif pos ==3:
			return parent.global_transform
