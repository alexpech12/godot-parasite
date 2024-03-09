class_name IdleRightState

extends IdleState

func _init(subject):
    super(subject, "face_right")

func facing_direction():
    return Vector2.RIGHT
    
func next_state():
    var next_state = super()
    
    if next_state:
        return next_state
        
    if inputs.get("attack"):
        return AttackRightState.new(subject)
