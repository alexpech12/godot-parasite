extends BaseCreature

var wait_time = null
var t = 0.0

var energy = 0

var duplicate_self = false
var duplicate_location: Vector2

var creature_type = CreatureType.Parasite

var parasite_scene: PackedScene

func _ready():
    super()
    
    #parasite_scene = load("res://scenes/enemies/parasite_baby.tscn")

func on_move_entered():
    print_debug("Starting move")
    duplicate_location = position
    
func on_move_exited(success):
    if !success:
        print_debug("Move not successful!")
        return
        
    if energy >= 1:
        print_debug("Enough energy to duplicate")
        #var new_parasite = parasite_scene.instantiate()
        var new_parasite = self.duplicate()
        add_sibling(new_parasite)
        new_parasite.position = duplicate_location
        energy = 0
        
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_inputs(delta):
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
        
    return inputs

func consume_monster(monster):
    print_debug("Consuming ", monster)
    # When energy passes a threshold, spawn an identical parasite
    # Stronger monsters give more energy
    energy += monster.damage

func on_touched_by_player(player):
    player.receive_damage(damage)

func on_touched_by_monster(monster):
    monster.receive_damage(damage)
    if monster.dead():
        consume_monster(monster)
        
func on_touched_by_parasite(parasite):
    pass
    # TODO: Unsure if we want this or not
    #print_debug("Parasites are touching!")
    #if self.is_greater_than(parasite):
        #return
        #
    #health += parasite.health
    #parasite.health = 0
