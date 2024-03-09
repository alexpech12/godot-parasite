extends Area2D

@export var tilemap: TileMap
@export var chance_of_movement = 0.01

var STEP_SIZE = 16
var move_frames = 10

var sprite: AnimatedSprite2D
var current_state: State

var wait_time = null
var t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
    sprite = $AnimatedSprite2D
    current_state = IdleDownState.new(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var inputs = {}
    
    if wait_time == null:
        wait_time = randi_range(1,3)
        
    t += delta
    
    if t > wait_time:
        
    #if randf() < chance_of_movement:
        # Pick a random direction to try and move
        var input_i = randi_range(0, 3)
        inputs = {
            up = input_i == 0,
            down = input_i == 1,
            left = input_i == 2,
            right = input_i == 3,
        }
        t = 0
        wait_time = null
        
    current_state.set_inputs(inputs)
    
    current_state.process(delta)
    var next_state = current_state.next_state()
    
    if next_state:
        current_state.exit()
        current_state = next_state
        current_state.enter()

func play_animation(animation):
    sprite.play(animation)

func collision_test(pos):
    var cell = tilemap.local_to_map(pos)
    var data = tilemap.get_cell_tile_data(0, cell)
    if data:
        return data.get_custom_data("wall")

    return false

func _on_area_entered(area):
    if area.name == "Player":
        area.damage(1)
