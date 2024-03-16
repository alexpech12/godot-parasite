class_name Room

extends Node2D

@export var filepath: String
@export var player_start: Vector2
@export var enemy_scene: PackedScene
var definition: Level.RoomDefinition

var ROOM_SIZE = 12

signal transition(scene: String, player_location: Vector2)
signal exit_reached
var exit_node: Node2D

var Symbol = {
    Wall = 'X',
    Player = 'P',
    Entrance = 'E',
    Exit = 'G',
    Torch = 'Y',
    Treasure = 'T',
    ParasiteBaby = 'q',
    ParasiteJuvenile = 'w',
    ParasiteAdult = 'e',
    MonsterBaby = 'a' ,
    MonsterJuvenile = 's' ,
    MonsterAdult = 'd' 
}

func configure(filepath: String, definition: Level.RoomDefinition):
    self.filepath = filepath
    self.definition = definition
    apply_file()
    apply_definition()
    
func doors():
    return [
        $DoorTop, 
        $DoorBottom,
        $DoorLeft,
        $DoorRight
    ]
    
func exit():
    return exit_node
    
func chest():
    for child in find_children('', "Chest", true, false):
        return child

func _ready():
    if filepath:
        apply_file()

func apply_file():
    print_debug("applying file ", filepath)
    var file = FileAccess.open(filepath, FileAccess.READ)
    var content = file.get_as_text()
    
    var rows = content.split("\n")
    
    for y in ROOM_SIZE:
        var row = rows[y]
        for x in ROOM_SIZE:
            match row[x]:
                Symbol.Wall:
                    add_wall(x, y)
                Symbol.Torch:
                    add_object("torch", x, y)
                Symbol.Entrance:
                    add_object("entrance", x, y)
                Symbol.Exit:
                    add_exit(x, y)
                Symbol.Treasure:
                    add_treasure(x, y)
                Symbol.ParasiteBaby:
                    add_enemy("parasite_baby", x, y)
                Symbol.ParasiteJuvenile:
                    add_enemy("parasite_juvenile", x, y)
                Symbol.ParasiteAdult:
                    add_enemy("parasite_adult", x, y)
                Symbol.MonsterBaby:
                    add_enemy("monster_baby", x, y)
                Symbol.MonsterJuvenile:
                    add_enemy("monster_juvenile", x, y)
                Symbol.MonsterAdult:
                    add_enemy("monster_adult", x, y)
                Symbol.Player:
                    player_start = map_to_world(x, y) + Vector2(8, 8)

func apply_definition():
    # Create / close off connections
    for direction_key in definition.connections:
        var destination = definition.connections[direction_key]
        if destination:
            # Link it up
            var door = {
                Level.RoomDefinition.Direction.Up: $DoorTop,
                Level.RoomDefinition.Direction.Down: $DoorBottom,
                Level.RoomDefinition.Direction.Left: $DoorLeft,
                Level.RoomDefinition.Direction.Right: $DoorRight,
            }[direction_key]

            door.set_destination(destination.location)
        else:
            # Close it off 
            match direction_key:
                Level.RoomDefinition.Direction.Up:
                    add_wall(5, 0)
                    add_wall(6, 0)
                    add_wall(5, -1)
                    add_wall(6, -1)
                Level.RoomDefinition.Direction.Down:
                    add_wall(5, 11)
                    add_wall(6, 11)
                    add_wall(5, 12)
                    add_wall(6, 12)
                Level.RoomDefinition.Direction.Left:
                    add_wall(0, 5)
                    add_wall(0, 6)
                    add_wall(-1, 5)
                    add_wall(-1, 6)
                Level.RoomDefinition.Direction.Right:
                    add_wall(11, 5)
                    add_wall(11, 6)
                    add_wall(12, 5)
                    add_wall(12, 6)

func _on_door_transition(scene, player_location):
    transition.emit(scene, player_location)
    
func _on_exit_reached():
    print_debug("_on_exit_reached")
    exit_reached.emit()
    
func get_tilemap():
    return $TileMap
    
func add_wall(x, y):
    $TileMap.set_cells_terrain_connect (0, [Vector2i(3+x, y)], 0, 0)
    
func add_object(type, x, y):
    var object_scene = load("res://scenes/objects/%s.tscn" % type)
    var object = object_scene.instantiate()
    add_child(object)
    object.position = map_to_world(x, y) + Vector2(8, 8)
    
func add_exit(x, y):
    var object_scene = load("res://scenes/objects/exit.tscn")
    var object = object_scene.instantiate()
    add_child(object)
    object.position = map_to_world(x, y) + Vector2(8, 8)
    object.connect("exit_reached", _on_exit_reached)
    exit_node = object
    
func add_treasure(x, y):
    var treasure_scene = load("res://scenes/objects/chest.tscn")
    var treasure = treasure_scene.instantiate()
    add_child(treasure)
    treasure.position = map_to_world(x, y) + Vector2(8, 8)
    
func add_enemy(type, x, y):
    var enemy_scene = load("res://scenes/enemies/%s.tscn" % type)
    var enemy = enemy_scene.instantiate()
    add_child(enemy)
    enemy.position = map_to_world(x, y) + Vector2(8, 8)
    
func map_to_world(x, y):
    return Vector2((x+3) * 16, y * 16)
