class_name BaseCreature

extends Area2D

@export var health = 1
@export var damage = 1

enum CreatureType { Player, Parasite, Monster }

var STEP_SIZE = 16
var move_frames = 10

var facing_direction = Vector2i.DOWN

var current_state: State

var player: Player
    
# Called when the node enters the scene tree for the first time.
func _ready():
    current_state = IdleState.new(self)
    
    player = get_tree().root.find_child("Player", true, false)
    assert(player, "player could not be found")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    process_state_machine(get_inputs(delta), delta)
    
    play_animation(get_current_animation())

func get_current_animation():
    var animation_string = current_state.animation_name
    return animation_string
    
func play_animation(animation):
    $AnimatedSprite2D.play(animation)

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
    var tween = get_tree().create_tween()
    tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 0.1)
    tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.1)
        
func dead():
    return health <= 0
    
func on_death_entered():
    print_debug("on_death_entered()")
    var death_sprite = $AnimatedSprite2D.duplicate()
    add_sibling(death_sprite)
    death_sprite.position = position
    death_sprite.play("death")
    
