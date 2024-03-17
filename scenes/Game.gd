extends Node2D
@export var transition_time = 0.3
@export var player: Player
@export var ui: UI
@export var room_scene: PackedScene
 
@export var starting_room_override: String

signal game_over
signal exit_reached

enum TransitionState { None, FadingOut, Loading, FadingIn }
var transition_state = TransitionState.None
var transition_scene: PackedScene
var transition_location: Vector2
var transition_destination: Vector2i

var t = 0.0

var current_room: Node2D

var current_room_definition: Level.RoomDefinition
    
func _ready():
    $Level.generate()
    
    if starting_room_override:
        load_room_from_file($Level.starting_room(), starting_room_override)
    else:
        load_room($Level.starting_room())
    
    player.enter_room(current_room)
    
func load_room_from_file(room_definition, filename):
    # Instantiate room
    var room = room_scene.instantiate()
    add_child(room)
        
    # Apply file to room
    room.configure(filename, room_definition)
    
    # Set player location, if room provides one
    if room.player_start:
        player.position = room.player_start
        
    # Hook up doors for room transitions
    for door: Door in room.doors():
        door.transition.connect(_on_room_transition)
        
    if room.exit():
        room.exit().exit_reached.connect(_on_exit_reached)
        
    if room.chest():
        room.chest().open.connect(player._on_open_chest)
        
    current_room_definition = room_definition
    current_room = room
    
func load_room(room_definition):
    #var filename = find_random_matching_file(room_definition)
    var filename = room_definition.filename
    load_room_from_file(room_definition, filename)

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
    
func _on_exit_reached():
    print_debug("_on_exit_reached")
    exit_reached.emit()



func _on_player_game_over():
    game_over.emit()
