extends Node2D

@export var tilemap: TileMap

@export var move_frames = 10

var sprite: AnimatedSprite2D
var STEP_SIZE = 16
    
class State:
    var player
    var animation
    
    func _init(player, animation):
        self.player = player
        self.animation = animation
        
    func enter():
        player.sprite.play(animation)
        
    func exit():
        pass

    func process(_delta):
        pass
        
    func next_state() -> State:
        return null
        
class IdleState:
    extends State
    
    func next_state():
        var transitions = [
            {
                'input': "ui_up",
                'next_state': MoveUpState
            },{
                'input': "ui_left",
                'next_state': MoveLeftState
            },{
                'input': "ui_down",
                'next_state': MoveDownState
            },{
                'input': "ui_right",
                'next_state': MoveRightState
            },
        ]
        for transition in transitions:
            if Input.is_action_pressed(transition['input']):
                return transition['next_state'].new(player)
        
class IdleLeftState:
    extends IdleState
    
    func _init(player):
        super(player, "face_left")
        
class IdleRightState:
    extends IdleState
    
    func _init(player):
        super(player, "face_right")
        
class IdleUpState:
    extends IdleState
    
    func _init(player):
        super(player, "face_up")
        
class IdleDownState:
    extends IdleState
    
    func _init(player):
        super(player, "face_down")
    

class MoveState:
    extends State
    
    var start
    var target
    var t = 0
    
    func _init(player, animation, movement):
        super(player, animation)
        self.start = player.position
        self.target = player.position + movement
        # Prevent the player from walking into a wall
        # TODO: In future, this could became a 'bump into wall' animation
        if player.collision_test(target):
            self.target = player.position
        else:
            self.target = player.position + movement
        
    func process(delta):
        t += 1
        player.position = start.lerp(target, (t as float) / player.move_frames)
        
        if movement_complete():
            snap_position()

    func next_state():
        if movement_complete():
            return _next_state()
        
    func _next_state():
        assert(false, "_next_state must be implemented!")
        
    func movement_complete():
        return t >= player.move_frames
    
    func snap_position():
        player.position = Vector2i(
            ((target.x as int) / player.STEP_SIZE) * player.STEP_SIZE + player.STEP_SIZE / 2,
            ((target.y as int) / player.STEP_SIZE) * player.STEP_SIZE + player.STEP_SIZE / 2
        )
        
    
class MoveUpState:
    extends MoveState
    
    func _init(player):
        super(player, "step_up", Vector2(0, -player.STEP_SIZE))
    
    func _next_state():
        if Input.is_action_pressed("ui_up"):
            return MoveUpState.new(player)
        else:
            return IdleUpState.new(player)
        
class MoveDownState:
    extends MoveState
    
    func _init(player):
        super(player, "step_down", Vector2(0, player.STEP_SIZE))
    
    func _next_state():
        return IdleDownState.new(player)
        
class MoveLeftState:
    extends MoveState
    
    func _init(player):
        super(player, "step_left", Vector2(-player.STEP_SIZE, 0))
    
    func _next_state():
        return IdleLeftState.new(player)
    
class MoveRightState:
    extends MoveState
    
    func _init(player):
        super(player, "step_right", Vector2(player.STEP_SIZE, 0))
    
    func _next_state():
        return IdleRightState.new(player)


var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready():
    sprite = $AnimatedSprite2D
    current_state = IdleUpState.new(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    current_state.process(delta)
    var next_state = current_state.next_state()
    
    if next_state:
        current_state.exit()
        current_state = next_state
        current_state.enter()
         
func collision_test(pos):
    var cell = tilemap.local_to_map(pos)
    var data = tilemap.get_cell_tile_data(0, cell)
    if data:
        return data.get_custom_data("wall")

    return false

