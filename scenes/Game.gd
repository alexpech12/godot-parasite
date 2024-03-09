extends Node2D
@export var transition_time = 1.0
@export var player: Player
 
enum TransitionState { None, FadingOut, Loading, FadingIn }
var transition_state = TransitionState.None
var transition_scene: PackedScene
var transition_location: Vector2

var t = 0.0

@export var current_room: Node2D

func _process(delta):
    match transition_state:
        TransitionState.FadingOut:
            t += delta
            var color = $Curtain.color
            color.a = lerpf(0.0, 1.0, t / transition_time)
            $Curtain.color = color
            if t >= transition_time:
                t = 0.0
                transition_state = TransitionState.Loading
                $Curtain.color = Color(0,0,0,1);
                
        TransitionState.Loading:
            current_room.queue_free()
            
            var instance = transition_scene.instantiate()
            add_child(instance)
            current_room = instance
            (current_room as Room).transition.connect(_on_room_transition)
            transition_state = TransitionState.FadingIn
            player.position = transition_location
            player.enter_room(current_room)
            
        TransitionState.FadingIn:
            t += delta
            var color = $Curtain.color
            color.a = lerpf(1.0, 0.0, t / transition_time)
            $Curtain.color = color
            if t >= transition_time:
                t = 0.0
                transition_state = TransitionState.None
                $Curtain.color = Color(0,0,0,0);
    

func _on_room_transition(scene, player_location):
    if transition_state != TransitionState.None:
        return
    
    transition_state = TransitionState.FadingOut
    transition_scene = scene
    transition_location = player_location

