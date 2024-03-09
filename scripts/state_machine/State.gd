class_name State

var subject
var animation
var inputs

func _init(subject, animation):
    self.subject = subject
    self.animation = animation
    
func enter():
    subject.play_animation(animation)
    
func exit():
    pass

func set_inputs(inputs):
    self.inputs = inputs

func process(_delta):
    pass
    
func next_state() -> State:
    return null
