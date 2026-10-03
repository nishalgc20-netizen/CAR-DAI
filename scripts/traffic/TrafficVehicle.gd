extends RigidBody3D

@export var move_axis: String = "z"
@export var speed: float = 10.0
@export var direction: int = 1

func _ready() -> void:
    linear_damp = 0.4
    mass = 1000.0
    freeze = false

func _physics_process(delta: float) -> void:
    if move_axis == "z":
        position.z += speed * direction * delta
        if abs(position.z) > 70.0:
            direction *= -1
    else:
        position.x += speed * direction * delta
        if abs(position.x) > 80.0:
            direction *= -1

    if global_position.y < 0.7:
        global_position.y = 0.7
