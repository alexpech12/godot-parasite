extends Area2D

@export var tilemap: TileMap

@export var move_frames = 10

var sprite: AnimatedSprite2D
var STEP_SIZE = 16

var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready():
    sprite = $AnimatedSprite2D
    current_state = IdleUpState.new(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    current_state.set_inputs({
        up = Input.is_action_pressed("ui_up"),
        down = Input.is_action_pressed("ui_down"),
        left = Input.is_action_pressed("ui_left"),
        right = Input.is_action_pressed("ui_right"),
    })
    
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
    print_debug("Area entered - " + area.name)
    
func damage(amount):
    print_debug("Damaged " + str(amount))
