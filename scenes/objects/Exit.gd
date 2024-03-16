extends Area2D

signal exit_reached

func _on_area_entered(area):
    print_debug("_on_area_entered")
    exit_reached.emit()
