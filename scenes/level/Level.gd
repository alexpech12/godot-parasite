class_name Level

extends Node2D

#@export var room_count = 10
@export var main_path_length = 10
@export var secondary_path_count = 2
@export var secondary_path_length = 3

enum RoomType {
    Start, End, Normal, Treasure
}


class RoomDefinition:
    var RoomTypeString = {
        RoomType.Start: 'start',
        RoomType.End: 'end',
        RoomType.Normal: 'normal',
        RoomType.Treasure: 'treasure'
    }

    var location: Vector2i
    var type: RoomType
    var key: String
    enum Direction { Up, Down, Left, Right }
    var connections = {
        Direction.Up: null,
        Direction.Down: null,
        Direction.Left: null,
        Direction.Right: null,
    }
    
    static func key_for_location(x, y):
        return str(x) + "," + str(y)
        
    func _init(x: int, y: int, type = RoomType.Normal):
        location = Vector2i(x,y)
        self.type = type
        key = key_for_location(x,y)
    
    func type_string():
        return RoomTypeString[type]
        
    func connections_string():
        var str = ""
        if connections[Direction.Up]: str = str + "n"
        if connections[Direction.Right]: str = str + "e"
        if connections[Direction.Left]: str = str + "w"
        if connections[Direction.Down]: str = str + "s"
        return str
        
    func neighbour_locations():
        return [
            Vector2i(location.x - 1, location.y),
            Vector2i(location.x + 1, location.y),
            Vector2i(location.x, location.y - 1),
            Vector2i(location.x, location.y + 1)
        ]
        
    func connect_room(other_room: RoomDefinition):
        if other_room.location == Vector2i(location.x, location.y - 1):
            # Top connection
            connections[Direction.Up] = other_room
            other_room.connections[Direction.Down] = self
        elif other_room.location == Vector2i(location.x, location.y + 1):
            # Bottom connection
            connections[Direction.Down] = other_room
            other_room.connections[Direction.Up] = self
        elif other_room.location == Vector2i(location.x - 1, location.y):
            # Left connection
            connections[Direction.Left] = other_room
            other_room.connections[Direction.Right] = self
        elif other_room.location == Vector2i(location.x + 1, location.y):
            # Right connection
            connections[Direction.Right] = other_room
            other_room.connections[Direction.Left] = self
        else:
            assert(false, "Room at " + str(other_room.location) + " is not adjacent to current room at " + str(location))
        

var rooms = {}
var focussed_room

@export var generate_on_ready = false
@export var generate_debug = false
@export var debug_start: Node
@export var debug_normal: Node
@export var debug_end: Node
@export var debug_treasure: Node
@export var debug_connection: Node
@export var debug_scale = 12.0

func starting_room() -> RoomDefinition:
    for key in rooms:
        var room = rooms[key]
        if room.type == RoomType.Start:
            return room
    return null

func get_room(location: Vector2i) -> RoomDefinition:
    var key = RoomDefinition.key_for_location(location.x, location.y)
    return rooms.get(key)

func _ready():
    if generate_on_ready:
        generate()

func generate():
    var result = null
    while result != 'OK':
        rooms = {}
        result = generate_level()
        
    if generate_debug:
        generate_debug_layout()
    else:
        $Debug.visible = false
    
func generate_level():
    # Generate start room
    var start_room = add_room(Vector2i.ZERO, RoomType.Start, false)
    
    # Generate main path to end
    add_random_path(start_room, main_path_length, RoomType.End)
    
    # Add secondary paths off existing rooms
    for path_num in secondary_path_count:
        var random_room_key = rooms.keys()[randi() % rooms.size()]
        var random_room = rooms[random_room_key]
        add_random_path(random_room, secondary_path_length, RoomType.Treasure)
        
    return 'OK'

        
func generate_debug_layout():
    # Show a debug version of the room
    for key in rooms:
        var room = rooms[key]
        var debug_room = null
        match room.type:
            RoomType.Start: debug_room = debug_start.duplicate()
            RoomType.End: debug_room = debug_end.duplicate()
            RoomType.Normal: debug_room = debug_normal.duplicate()
            RoomType.Treasure: debug_room = debug_treasure.duplicate()
            
        $Debug.add_child(debug_room)
        debug_room.position = room.location * debug_scale
        
        for direction_key in room.connections:
            var connection = room.connections[direction_key]
            if connection != null:
                var connection_instance = debug_connection.duplicate()
                debug_room.add_child(connection_instance)
                connection_instance.position = Vector2.ZERO
                match direction_key:
                    RoomDefinition.Direction.Up: 
                        connection_instance.position = Vector2(debug_room.size.x / 2, 0)
                        connection_instance.set_rotation_degrees(90)
                    RoomDefinition.Direction.Right: 
                        connection_instance.position = Vector2(debug_room.size.x, debug_room.size.y / 2)
                        connection_instance.set_rotation_degrees(180)
                    RoomDefinition.Direction.Down: 
                        connection_instance.position = Vector2(debug_room.size.x / 2, debug_room.size.y)
                        connection_instance.set_rotation_degrees(270)
                    RoomDefinition.Direction.Left: 
                        connection_instance.position = Vector2(0, debug_room.size.y / 2)
            
func add_random_path(start_room: RoomDefinition, length, end_type: RoomType):
    focussed_room = start_room
    
    var visited_rooms = [start_room]
    var path_length = 1
    
    while path_length < length:
        # Find an empty adjacent space
        var next_location = null
        var neighbour_locations = focussed_room.neighbour_locations()
        neighbour_locations.shuffle()
        for location in neighbour_locations:
            var tmp_room = RoomDefinition.new(location.x, location.y)
            if !rooms.has(tmp_room.key):
                next_location = location
                break
        
        if next_location == null:
            print_debug(" - Could not find free location. Backtracking...")
            # Couldn't find a spare space, so we need to back-track
            var previous_room = visited_rooms.pop_back()
            if previous_room == null:
                print_debug(" - Nowhere else to backtrack to. Aborting...")
                # This is a dead-end. Abort this path
                break

            focussed_room = previous_room
            continue
        
        var room_type = end_type if path_length == length-1 else RoomType.Normal
        var new_room = add_room(next_location, room_type)
        focussed_room = new_room
        visited_rooms.append(new_room)
        path_length += 1
        
        
    
func add_room(location: Vector2i, type = RoomType.Normal, connect_to_focussed = true):
    var room = RoomDefinition.new(location.x, location.y, type)
    rooms[room.key] = room
    #visited_rooms.append(room)
    # Create connection between current focussed room and new room
    if connect_to_focussed:
        focussed_room.connect_room(room)
    return room
    
    
    
