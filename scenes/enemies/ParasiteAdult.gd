extends Parasite

@export var min_ranged_distance = 5
@export var max_melee_distance = 3
@export var turn_wait_time = 0.5
@export var projectile_scene: PackedScene

var wait_time = null
var t = 0.0   
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_inputs(delta):
    var inputs = {}
    
    if wait_time == null:
        wait_time = turn_wait_time
        
    t += delta
    
    if t > wait_time:
        if is_instance_valid(player):
            var x_diff = player.position.x - position.x
            var y_diff = player.position.y - position.y
            var dist = absf(x_diff) + absf(y_diff)
            print_debug("x_diff: ", x_diff, ", y_diff: ", y_diff, ", dist: ", dist)
            
            # If close enough to melee, move toward player
            if dist < max_melee_distance * STEP_SIZE:
                print_debug("Move toward")
                inputs = inputs_move_to_target(player)
            
            # Else if not far away enough for ranged, move away from player
            elif dist < min_ranged_distance * STEP_SIZE:
                print_debug("Move away")
                inputs = inputs_move_to_target(player, true)
            
            # Else if aligned, fire
            elif absf(x_diff) < STEP_SIZE / 2:
                # Aligned horizontally
                if y_diff > 0:
                    print_debug("Shoot down")
                    shoot(0,1)
                else:
                    print_debug("Shoot up")
                    shoot(0,-1)
                    #inputs.left = true
                
            # Else if not aligned for ranged, move laterally
            elif absf(y_diff) < STEP_SIZE / 2:
                #print_debug("Strafe vertical")
                if x_diff > 0:
                    print_debug("Shoot right")
                    shoot(1,0)
                    #inputs.down = true
                else:
                    print_debug("Shoot left")
                    shoot(-1,0)
                    #inputs.up = true
                    
            # Else, move laterally
            else:
                # Move shortest to alignment
                if absf(y_diff) < absf(x_diff):
                    if y_diff > 0: inputs.down = true
                    else: inputs.up = true
                else:
                    if x_diff > 0: inputs.right = true
                    else: inputs.left = true
        else:
            inputs = inputs_random_direction()
       
        t = 0
        wait_time = null
        
    return inputs

func shoot(x, y):
    var projectile = projectile_scene.instantiate()
    print_debug(projectile)
    add_sibling(projectile)
    projectile.position = position
    projectile.direction = Vector2i(x,y)
