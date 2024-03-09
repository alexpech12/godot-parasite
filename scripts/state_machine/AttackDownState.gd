class_name AttackDownState

extends AttackState

func _init(subject):
    super(subject, "attack_down")
    

func facing_direction():
    return Vector2.DOWN
    
func _next_state():
    if inputs.get("attack"):
        return AttackDownState.new(subject)
    else:
        return IdleDownState.new(subject)
