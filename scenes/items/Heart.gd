extends AnimatedSprite2D

@export var speed = 10.0

func _process(delta):
    position.y -= delta * speed
