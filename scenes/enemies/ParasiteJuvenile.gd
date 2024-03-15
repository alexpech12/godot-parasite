extends Parasite

var wait_time = null
var t = 0.0   
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_inputs(delta):
    if not player:
        return {}

    var inputs = {}
    
    if wait_time == null:
        #wait_time = randi_range(1,3)
        wait_time = 1
        
    t += delta
    
    if t > wait_time:
        if is_instance_valid(player):
            inputs = inputs_move_to_target(player)
        else:
            inputs = inputs_random_direction()
        ## Move in the direction of the player
        #var player_up = player.position.y < position.y
        #var player_down = player.position.y > position.y
        #var player_left = player.position.x < position.x
        #var player_right = player.position.x > position.x
        #var input_options = []
        #if player_up: input_options.append(0)
        #if player_down: input_options.append(1)
        #if player_left: input_options.append(2)
        #if player_right: input_options.append(3)
        #input_options.shuffle()
        #if input_options.size() > 0:
            #var input_i = input_options[0]
            #inputs = {
                #up = input_i == 0,
                #down = input_i == 1,
                #left = input_i == 2,
                #right = input_i == 3,
            #}
        t = 0
        wait_time = null
        
    return inputs
