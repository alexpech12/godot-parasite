class_name IdleUpState

extends IdleState

func _init(subject):
    super(subject, "face_up")

func facing_direction():
    return Vector2.UP
    
func next_state():
    var next_state = super()
    
    if next_state:
        return next_state
        
    if inputs.get("attack"):
        return AttackUpState.new(subject)
