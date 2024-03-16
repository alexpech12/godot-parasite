class_name Chest

extends Area2D

@export var item_scene: PackedScene

signal open

func _ready():
    $AnimatedSprite2D.play("closed")

func _on_area_entered(area):
    open.emit()
    $AnimatedSprite2D.play("open")
    
    var item = item_scene.instantiate()
    add_child(item)
    await get_tree().create_timer(2).timeout
    item.queue_free()
    
