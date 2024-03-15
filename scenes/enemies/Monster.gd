class_name Monster

extends BaseCreature

var creature_type = CreatureType.Monster

var wait_time = null
var t = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_inputs(delta):
    var inputs = {}
    
    if wait_time == null:
        wait_time = randi_range(1,3)
        
    t += delta
    
    if t > wait_time:
        inputs = inputs_random_direction()
        
        t = 0
        wait_time = null
        
    return inputs

