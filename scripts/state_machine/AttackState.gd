class_name AttackState

extends State

var attack_complete = false
var t = 0.0

func enter():
    super()
    
    subject.attack()
    
func process(delta):
    t += delta
    
    if t >= subject.attack_time:
        attack_complete = true

func next_state():
    if attack_complete:
        return _next_state()
        
func _next_state():
    assert(false, "_next_state must be implemented!")

