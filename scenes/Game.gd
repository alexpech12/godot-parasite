extends Node2D
@export var transition_time = 1.0
@export var player: Player
@export var ui: UI
@export var room_scene: PackedScene
 
enum TransitionState { None, FadingOut, Loading, FadingIn }
var transition_state = TransitionState.None
var transition_scene: PackedScene
var transition_location: Vector2
var transition_destination: Vector2i

var t = 0.0

@export var current_room: Node2D

var current_room_definition: Level.RoomDefinition

func _ready():
    $Level.generate()
    
    load_room($Level.starting_room())
    
func load_room(room_definition):
    
    # Find file matching definition
    # Path format is res://levels/{type}/{n?}{e?}{w?}{s?}/*
    # Or, res://levels/{type}/* for a level without specific connections
    var selected_file = null
    var path = "res://levels/%s/%s/" % [
        room_definition.type_string(), 
        room_definition.connections_string()
        ]
    var dir = DirAccess.open(path)
    if not dir:
        path = "res://levels/%s" % room_definition.type_string()
        print_debug("Using backup path ", path)
        dir = DirAccess.open(path)
        print_debug(dir)
        
    var file_list = dir.get_files()
    var selection = (randi() % file_list.size()) + 1
    var file_name = "%02d.txt" % selection
    selected_file = "%s/%s" % [path,file_name]
        
    print_debug("Using ", selected_file)
    
    # Instantiate room
    var room = room_scene.instantiate()
    add_child(room)
        
    # Apply file to room
    room.configure(selected_file, room_definition)
    
    # Set player location, if room provides one
    if room.player_start:
        player.position = room.player_start
        
    # Hook up doors for room transitions
    for door: Door in room.doors():
        door.transition.connect(_on_room_transition)
        
    current_room_definition = room_definition
    current_room = room

func _process(delta):
    match transition_state:
        TransitionState.FadingOut:
            t += delta
            ui.set_curtain_alpha(lerpf(0.0, 1.0, t / transition_time))
            if t >= transition_time:
                t = 0.0
                transition_state = TransitionState.Loading
                ui.set_curtain_alpha(1.0)
                
        TransitionState.Loading:
            current_room.queue_free()
            
            var destination_room_definition = $Level.get_room(transition_destination)
            
            load_room(destination_room_definition)
            
            #var instance = transition_scene.instantiate()
            #add_child(instance)
            #current_room = instance
            #(current_room as Room).transition.connect(_on_room_transition)
            transition_state = TransitionState.FadingIn
            player.position = transition_location
            
        TransitionState.FadingIn:
            t += delta
            ui.set_curtain_alpha(lerpf(1.0, 0.0, t / transition_time))
            if t >= transition_time:
                t = 0.0
                transition_state = TransitionState.None
                ui.set_curtain_alpha(0)
                player.enter_room(current_room)
    

func _on_room_transition(destination, player_location):
    if transition_state != TransitionState.None:
        return
    
    transition_state = TransitionState.FadingOut
    transition_destination = destination
    transition_location = player_location
    player.exit_room(current_room)

