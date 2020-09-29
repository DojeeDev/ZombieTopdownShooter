extends Control


export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2

onready var health_bar = $TextureProgress
onready var health_under = $health_under
onready var update_tween = $UpdateTween


func _assign_color(health):
	if health < health_bar.max_value *danger_zone:
		health_bar.tint_progress = danger_color
	elif health < health_bar.max_value *caution_zone:
		health_bar.tint_progress = caution_color
	else:
		health_bar.tint_progress = healthy_color
	

func _on_heath_bar_updated(health):
	health_bar.value = health
	update_tween.interpolate_property(health_under,"value",health_under.value, health,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	update_tween.start()
	
	
	
	_assign_color(health)


func _on_max_health_updated(max_health):
	_on_heath_bar_updated(max_health)
	health_bar.value = max_health
	health_under.value = max_health
	health_under.max_value = max_health
	health_bar.max_value = max_health
	health_bar.value = health_under.value

