extends AnimatedSprite

func _process(delta):
	look_at(get_viewport().get_mouse_position())