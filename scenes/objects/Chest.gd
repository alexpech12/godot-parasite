class_name Chest

extends Area2D

@export var item_scene: PackedScene
var item_taken = false

signal open

func _ready():
    $AnimatedSprite2D.play("closed")

func _on_area_entered(area):
    if item_taken:
        return

    open.emit()
    $AnimatedSprite2D.play("open")
    
    var item = item_scene.instantiate()
    add_child(item)
    await get_tree().create_timer(2).timeout
    item.queue_free()
    
