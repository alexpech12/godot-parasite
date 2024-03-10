class_name State

var subject
var inputs

func _init(subject):
    self.subject = subject
    
func enter():
    pass
    
func exit():
    pass

func set_inputs(inputs):
    self.inputs = inputs

func process(_delta):
    pass
    
func next_state() -> State:
    return null
