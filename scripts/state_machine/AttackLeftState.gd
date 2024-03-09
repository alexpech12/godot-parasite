class_name AttackLeftState

extends AttackState

func _init(subject):
    super(subject, "attack_left")
    

func facing_direction():
    print_debug(Vector2.LEFT)
    return Vector2.LEFT
    
func _next_state():
    if inputs.get("attack"):
        return AttackLeftState.new(subject)
    else:
        return IdleLeftState.new(subject)
