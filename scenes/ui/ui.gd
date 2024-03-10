class_name UI

extends CanvasLayer

@export var curtain: ColorRect
@export var heart_scene: PackedScene

func set_curtain_alpha(value):
    var color = curtain.color
    color.a = value
    curtain.color = color

func _on_player_health_changed(health):
    for child in $Hearts.get_children():
        child.queue_free()
        
    var heart_spacing = 10
    
    if health < 0:
        health = 0
    
    for n in health:
        var heart = heart_scene.instantiate()
        $Hearts.add_child(heart)
        heart.position = Vector2(n * heart_spacing, 0)
