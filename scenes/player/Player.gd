class_name Player

extends Area2D

@export var room: Room
var tilemap: TileMap

@export var move_frames = 10

@export var projectile: Projectile

var sprite: AnimatedSprite2D
var STEP_SIZE = 16
var attack_time = 0.5
var attack_cooldown = 0

var current_state: State
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
    sprite = $AnimatedSprite2D
    current_state = IdleUpState.new(self)
    current_state.enter()
    
func enter_room(room):
    tilemap = room.get_tilemap()
    paused = false
    current_state = IdleUpState.new(self)
    current_state.enter()
    
func exit_room(room):
    paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if paused:
        return

    current_state.set_inputs({
        up = Input.is_action_pressed("ui_up"),
        down = Input.is_action_pressed("ui_down"),
        left = Input.is_action_pressed("ui_left"),
        right = Input.is_action_pressed("ui_right"),
        #attack = Input.is_action_pressed("attack")
    })
    
    current_state.process(delta)
    var next_state = current_state.next_state()
    
    if next_state:
        current_state.exit()
        current_state = next_state
        current_state.enter()
        
    attack_cooldown -= delta
    if Input.is_action_pressed("attack") && attack_cooldown <= 0:
        attack()
         
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
    
func facing_direction():
    print_debug(current_state.facing_direction())
    current_state.facing_direction()
        
func attack():
    print_debug("Attacking!")
    #var p = projectile.instantiate()
    var p = projectile.duplicate()
    p.position = position
    print_debug("Setting direction to " + str(facing_direction()))
    p.direction = current_state.facing_direction()
    if p.direction.x > 0:
        p.rotate(deg_to_rad(90))
    elif p.direction.y > 0:
        p.rotate(deg_to_rad(180))
    elif p.direction.x < 0:
        p.rotate(deg_to_rad(270))
    tilemap.add_child(p)
    
    attack_cooldown = attack_time
    
    
