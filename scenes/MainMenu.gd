extends Node2D

@export var active = true

signal start_game

func _ready():
    for child in find_children('','AnimatedSprite2D'):
        child.play()

func _process(delta):
    if not active:
        return

    if Input.is_action_just_pressed("ui_accept"):
        active = false
        
        start_game.emit()
