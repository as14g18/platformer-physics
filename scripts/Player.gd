extends KinematicBody2D

const GRENADE_SCENE = preload("res://scenes/Grenade.tscn")
const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_SPEED = 300
const JUMP_HEIGHT = 700
const ACCELERATION = 50
const MAX_GRENADE_CHARGE = 500
const GRENADE_CHARGE_PER_FRAME = 5

var grenade_charge = 0
var throw_grenade = false
var velocity = Vector2()

func charge_grenade():
	throw_grenade = true
	grenade_charge = min(grenade_charge + GRENADE_CHARGE_PER_FRAME, MAX_GRENADE_CHARGE)
	$Arrow.show()
	$Arrow.play("Charge")
	
func throw_grenade():
	$Sprite.play("Grenade")
	var clone = GRENADE_SCENE.instance()
	clone.start(position, grenade_charge, get_global_mouse_position())
	get_parent().add_child(clone)
	grenade_charge = 0
	throw_grenade = false
	$Arrow.stop()
	$Arrow.set_frame(0)
	$Arrow.hide()

func _physics_process(delta):
	velocity.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_down"):
		$Sprite.play("Slide")
		velocity.x = lerp(velocity.x, 0, 0.01)
	elif throw_grenade:
		$Sprite.play("Aim")
		friction = true
	else:
		$Sprite.play("Idle")
		friction = true
	
	if Input.is_mouse_button_pressed(1):
		charge_grenade()
	if !Input.is_mouse_button_pressed(1) and throw_grenade:
		throw_grenade()
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_HEIGHT
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if velocity.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.05)
		
	velocity = move_and_slide(velocity, UP)