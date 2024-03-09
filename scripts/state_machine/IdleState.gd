class_name IdleState

extends State

func next_state():
    var transitions = [
        {
            'input': "up",
            'next_state': MoveUpState
        },{
            'input': "left",
            'next_state': MoveLeftState
        },{
            'input': "down",
            'next_state': MoveDownState
        },{
            'input': "right",
            'next_state': MoveRightState
        },
    ]
    for transition in transitions:
        if inputs.get(transition['input']):
            return transition['next_state'].new(subject)
