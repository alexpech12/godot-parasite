class_name Projectile

extends Area2D

@export var speed = 5.0
@export var damage = 1

var direction = Vector2.ZERO

func _init():
    direction = Vector2.ZERO

func _process(delta):
    position += direction * speed

func _on_area_entered(area):
    area.receive_damage(damage)
    queue_free()


func _on_body_entered(body):
    queue_free()
