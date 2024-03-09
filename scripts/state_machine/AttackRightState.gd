class_name AttackRightState

extends AttackState

func _init(subject):
    super(subject, "attack_right")
    

func facing_direction():
    return Vector2.RIGHT
    
func _next_state():
    if inputs.get("attack"):
        return AttackRightState.new(subject)
    else:
        return IdleRightState.new(subject)
