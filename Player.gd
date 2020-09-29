extends KinematicBody2D


signal health_updated(health)
signal killed()

var Bullet_PS = preload("res://PlayerBullet.tscn")

onready var muzzle = $Muzzle
onready var i_frames_timer = $Iframes
onready var effects_animation = $Effects
onready var anim_player = $AnimationPlayer
onready var health_bar = $NotRotate/Healthbar

export var speed = 300
export var friction = 0.1
export var acceleration = 0.1

var velocity = Vector2()
var offset = Vector2(-10,-20)

export (float) var max_health = 100

onready var health = max_health setget _set_health


func _process(delta):
	update_health_bar_position(offset)

func kill():
	queue_free()

func _ready():
	health_bar._on_max_health_updated(max_health)

func damage(amount):
	if i_frames_timer.is_stopped():
		i_frames_timer.start()
		_set_health(health-amount)
		effects_animation.play("damage_flash")
		effects_animation.queue("flash")


func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")





func update_global_position():
	Global.player_position = global_position

func shoot():
	var b = Bullet_PS.instance()
	owner.add_child(b)
	b.transform = muzzle.global_transform
	anim_player.play("MuzzleFlash")


func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()



func get_input():
	var input = Vector2()
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_down"):
		input.y += 1
	if Input.is_action_pressed("move_up"):
		input.y -= 1
	return input


func look_at_cursor():
	var rotate_to_mouse = get_global_mouse_position() - global_position
	return rotate_to_mouse.angle()

func _physics_process(delta):
	
	update_global_position()
	rotation = look_at_cursor()
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity,direction.normalized()*speed,acceleration)
	else:
		velocity = lerp(velocity,Vector2.ZERO,friction)
	velocity = move_and_slide(velocity)

func update_health_bar_position(offset):
	health_bar.set_position(global_position+offset)

func _on_Iframes_timeout():
	effects_animation.play("rest")


func _on_Player_health_updated(health):
	health_bar._on_heath_bar_updated(health)
