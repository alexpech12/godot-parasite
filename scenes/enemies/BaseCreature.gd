class_name BaseCreature

extends Area2D

@export var health = 1
@export var damage = 1

enum CreatureType { Player, Parasite, Monster }

var STEP_SIZE = 16
var move_frames = 10

var facing_direction = Vector2i.DOWN

var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready():
    current_state = IdleState.new(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    process_state_machine(get_inputs(delta), delta)

func get_inputs(delta):
    return {}

func process_state_machine(inputs, delta):
    inputs["dead"] = dead()
    current_state.set_inputs(inputs)
    
    current_state.process(delta)
    var next_state = current_state.next_state()
    
    if next_state:
        current_state.exit()
        current_state = next_state
        current_state.enter()

func collision_test(tilemap, pos):
    var cell = tilemap.local_to_map(pos)
    var data = tilemap.get_cell_tile_data(0, cell)
    if data:
        return data.get_custom_data("wall")

    return false

func _on_area_entered(area):
    match area.get("creature_type"):
        CreatureType.Player:
            on_touched_by_player(area)
        CreatureType.Parasite:
            on_touched_by_parasite(area)
        CreatureType.Monster:
            on_touched_by_monster(area)
 
func on_touched_by_player(player):
    pass

func on_touched_by_monster(monster):
    pass
    
func on_touched_by_parasite(parasite):
    pass
           
func receive_damage(amount):
    print_debug(amount, " damage, (", health, " -> ", health - amount, ")")
    health -= amount
        
func dead():
    return health <= 0
