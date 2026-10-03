extends RigidBody3D

@export var max_speed_kmh: float = 155.0
@export var engine_force: float = 2500.0
@export var brake_force: float = 2200.0
@export var steering_strength: float = 2.0
@export var nitro_meter: float = 100.0
@export var max_nitro: float = 100.0

var current_gear: String = "D"

func _ready() -> void:
    add_to_group("player_car")
    mass = 1200.0
    linear_damp = 0.35
    angular_damp = 1.4
    freeze = false
    _setup_input_actions()

func _physics_process(delta: float) -> void:
    var throttle = Input.get_action_strength("accelerate")
    var brake = Input.get_action_strength("brake")
    var steer = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
    var handbrake = Input.get_action_strength("handbrake")
    var nitro = Input.get_action_strength("nitro")

    var speed_kmh = abs(linear_velocity.length() * 3.6)
    if global_position.y < 0.7:
        global_position.y = 0.7
        linear_velocity.y = min(linear_velocity.y, 0.0)

    if throttle > 0.0 and speed_kmh < max_speed_kmh:
        var forward: Vector3 = -global_transform.basis.z
        apply_central_force(forward * engine_force * throttle * delta * 60.0)

    if brake > 0.0 and speed_kmh > 0.5:
        var brake_vector: Vector3 = linear_velocity.normalized()
        apply_central_force(-brake_vector * brake_force * brake * delta * 60.0)

    if handbrake > 0.0 and speed_kmh > 10.0:
        angular_velocity.y = lerp(angular_velocity.y, steer * steering_strength * 1.8, delta * 2.4)
        linear_velocity *= Vector3(1.0, 1.0, 1.0) * (1.0 - delta * 0.18)
    else:
        angular_velocity.y = lerp(angular_velocity.y, steer * steering_strength, delta * 2.6)

    if nitro > 0.0 and nitro_meter > 0.0:
        var nitro_force := 1200.0
        apply_central_force((-global_transform.basis.z) * nitro_force * delta * 60.0)
        nitro_meter = max(0.0, nitro_meter - delta * 26.0)
    else:
        nitro_meter = min(max_nitro, nitro_meter + delta * 7.0)

    if throttle < 0.1 and brake < 0.1 and speed_kmh > 0.0:
        linear_velocity.x *= 0.99
        linear_velocity.z *= 0.99

    if speed_kmh > max_speed_kmh:
        var scale := max_speed_kmh / max(speed_kmh, 0.1)
        linear_velocity *= scale

    current_gear = "D"
    if speed_kmh < 5.0 and throttle <= 0.2:
        current_gear = "N"

func _setup_input_actions() -> void:
    var actions: Array[String] = [
        "accelerate",
        "brake",
        "steer_left",
        "steer_right",
        "handbrake",
        "nitro"
    ]
    for action in actions:
        if not InputMap.has_action(action):
            InputMap.add_action(action)
            var input_event := InputEventKey.new()
            match action:
                "accelerate": input_event.physical_keycode = KEY_W
                "brake": input_event.physical_keycode = KEY_S
                "steer_left": input_event.physical_keycode = KEY_A
                "steer_right": input_event.physical_keycode = KEY_D
                "handbrake": input_event.physical_keycode = KEY_SPACE
                "nitro": input_event.physical_keycode = KEY_SHIFT
            InputMap.action_add_event(action, input_event)
