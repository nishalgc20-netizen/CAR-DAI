extends Node

var settings: Dictionary = {
    "graphics": "high",
    "fps": 60,
    "steering_mode": "buttons",
    "audio_volume": 0.8,
    "abs": true,
    "traction_control": true,
    "esp": true,
    "auto_transmission": true,
}

var money: int = 2500
var unlocked_vehicles: Array = ["DAI S""]
var current_vehicle: String = "DAI S"

func _ready() -> void:
    _setup_input_actions()

func _setup_input_actions() -> void:
    var action_map: Dictionary = {
        "accelerate": KEY_W,
        "brake": KEY_S,
        "steer_left": KEY_A,
        "steer_right": KEY_D,
        "handbrake": KEY_SPACE,
        "nitro": KEY_SHIFT,
    }
    for action in action_map.keys():
        if not InputMap.has_action(action):
            InputMap.add_action(action)
            var event := InputEventKey.new()
            event.physical_keycode = int(action_map[action])
            InputMap.action_add_event(action, event)

func add_currency(amount: int) -> void:
    money += amount

func set_setting(key: String, value) -> void:
    settings[key] = value
