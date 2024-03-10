class_name Door

extends Area2D

enum DestinationLocation { Top, Bottom, Left, Right }

#@export var destination_scene: String
@export var destination_coordinates: Vector2i
@export var destination_location: DestinationLocation

signal transition(destination: Vector2i, player_location: Vector2)
#var next_scene = preload("res://scenes/test_scene_2.tscn")

func set_destination(destination):
    destination_coordinates = destination

func _on_area_entered(_area):
    
    print_debug("Moving to ", destination_coordinates)
    transition.emit(destination_coordinates, player_destination())
    #print_debug("Transition to " + str(destination_scene.resource_name()))
    #var scene = load("res://scenes/" + destination_scene + ".tscn")
    #transition.emit(scene, player_destination())
    #get_tree().change_scene_to_packed(destination_scene)
    
func player_destination():
    match destination_location:
        DestinationLocation.Top: return grid_to_world(9, 0)
        DestinationLocation.Bottom: return grid_to_world(9, 11)
        DestinationLocation.Left: return grid_to_world(3, 6)
        DestinationLocation.Right: return grid_to_world(14, 6)
        
func grid_to_world(grid_x, grid_y):
    return Vector2(grid_x, grid_y) * 16 + Vector2(8, 8)
