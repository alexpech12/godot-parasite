class_name AttackUpState

extends AttackState

func _init(subject):
    super(subject, "attack_up")
    
func facing_direction():
    return Vector2.UP
    
func _next_state():
    if inputs.get("attack"):
        return AttackUpState.new(subject)
    else:
        return IdleUpState.new(subject)
