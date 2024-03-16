extends Node2D

signal restart_game

@export var active = false

func _process(delta):
    if not active:
        return
        
    if Input.is_action_just_pressed("ui_accept"):
        restart_game.emit()
