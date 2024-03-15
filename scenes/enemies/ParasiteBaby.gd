extends Parasite

var wait_time = null
var t = 0.0    
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_inputs(delta):
    var inputs = {}
    
    if wait_time == null:
        #wait_time = randi_range(1,3)
        wait_time = 1
        
    t += delta
    
    if t > wait_time:
        # Move towards closest creature or player
        var target = find_closest_monster_or_player()
        if target:
            inputs = inputs_move_to_target(target)
        else:
            inputs = inputs_random_direction()
        t = 0
        wait_time = null
        
    return inputs
