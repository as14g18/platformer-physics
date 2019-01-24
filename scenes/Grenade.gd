extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func start(pos, speed, mouse_pos):
	position = pos
	apply_impulse((pos - mouse_pos), (pos - mouse_pos).normalized() * speed * -1)