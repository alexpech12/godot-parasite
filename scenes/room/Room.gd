class_name Room

extends Node2D

@export var filepath: String
@export var enemy_scene: PackedScene

var ROOM_SIZE = 12

signal transition(scene: String, player_location: Vector2)

var Symbol = {
    Wall = 'X',
    Enemy01 = 'q'    
}

func _ready():
    var file = FileAccess.open("res://" + filepath + ".txt", FileAccess.READ)
    var content = file.get_as_text()
    
    var rows = content.split("\n")
    
    for y in ROOM_SIZE:
        var row = rows[y]
        for x in ROOM_SIZE:
            match row[x]:
                Symbol.Wall:
                    add_wall(x, y)
                Symbol.Enemy01:
                    add_enemy(x, y)
            

func _on_door_transition(scene, player_location):
    transition.emit(scene, player_location)
    
func get_tilemap():
    return $TileMap
    
func add_wall(x, y):
    $TileMap.set_cells_terrain_connect (0, [Vector2i(3+x, y)], 0, 0)
    
func add_enemy(x, y):
    var enemy = enemy_scene.instantiate()
    add_child(enemy)
    enemy.position = map_to_world(x, y)
    
func map_to_world(x, y):
    return Vector2((x+3) * 16, y * 16)
