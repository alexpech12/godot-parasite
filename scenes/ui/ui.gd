class_name UI

extends CanvasLayer

@export var curtain: ColorRect

func set_curtain_alpha(value):
    var color = curtain.color
    color.a = value
    curtain.color = color


