class_name Room

extends Node2D

signal transition(scene: String, player_location: Vector2)

func _on_door_transition(scene, player_location):
    transition.emit(scene, player_location)
    
func get_tilemap():
    return $TileMap
