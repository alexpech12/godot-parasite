extends BaseCreature

var wait_time = null
var t = 0.0

var creature_type = CreatureType.Monster

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
