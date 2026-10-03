extends CanvasLayer

@onready var left_button: Button = $Control/LeftButton
@onready var right_button: Button = $Control/RightButton
@onready var accel_button: Button = $Control/AccelButton
@onready var brake_button: Button = $Control/BrakeButton
@onready var handbrake_button: Button = $Control/HandbrakeButton
@onready var nitro_button: Button = $Control/NitroButton

func _ready() -> void:
    _bind_button(left_button, "steer_left")
    _bind_button(right_button, "steer_right")
    _bind_button(accel_button, "accelerate")
    _bind_button(brake_button, "brake")
    _bind_button(handbrake_button, "handbrake")
    _bind_button(nitro_button, "nitro")

func _bind_button(button: Button, action: String) -> void:
    button.button_down.connect(func() -> void:
        Input.action_press(action)
    )
    button.button_up.connect(func() -> void:
        Input.action_release(action)
    )
    button.focus_mode = Control.FOCUS_NONE
