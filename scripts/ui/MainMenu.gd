extends Control

@onready var play_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/PlayButton
@onready var garage_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/GarageButton
@onready var cars_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/CarsButton
@onready var missions_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/MissionsButton
@onready var settings_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/SettingsButton
@onready var controls_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/ControlsButton
@onready var exit_button: Button = $CenterContainer/Panel/VBoxContainer/ButtonGrid/ExitButton
@onready var showcase: Node3D = $ShowcasePlaceholder

func _ready() -> void:
    _build_showcase_car()
    play_button.pressed.connect(_on_play_pressed)
    garage_button.pressed.connect(_on_garage_pressed)
    cars_button.pressed.connect(_on_cars_pressed)
    missions_button.pressed.connect(_on_missions_pressed)
    settings_button.pressed.connect(_on_settings_pressed)
    controls_button.pressed.connect(_on_controls_pressed)
    exit_button.pressed.connect(_on_exit_pressed)

func _process(delta: float) -> void:
    if showcase:
        showcase.rotate_y(delta * 0.6)

func _build_showcase_car() -> void:
    var body_mesh := MeshInstance3D.new()
    var body_box := BoxMesh.new()
    body_box.size = Vector3(2.4, 0.7, 4.2)
    body_mesh.mesh = body_box
    body_mesh.position = Vector3(0, 0.6, 0)
    showcase.add_child(body_mesh)

    var roof_mesh := MeshInstance3D.new()
    var roof_box := BoxMesh.new()
    roof_box.size = Vector3(1.5, 0.6, 2.0)
    roof_mesh.mesh = roof_box
    roof_mesh.position = Vector3(0, 1.2, 0)
    showcase.add_child(roof_mesh)

    for i in range(4):
        var wheel := MeshInstance3D.new()
        var wheel_mesh := CylinderMesh.new()
        wheel_mesh.top_radius = 0.34
        wheel_mesh.bottom_radius = 0.34
        wheel_mesh.height = 0.22
        wheel_mesh.radial_segments = 16
        wheel.mesh = wheel_mesh
        wheel.rotation_degrees.x = 90.0
        var x := [-1.3, 1.3, -1.3, 1.3][i]
        var z := [-1.6, -1.6, 1.6, 1.6][i]
        wheel.position = Vector3(x, -0.1, z)
        showcase.add_child(wheel)

    showcase.position = Vector3(0, -0.3, 0)
    showcase.rotation_degrees.x = 18.0
    showcase.rotation_degrees.y = 30.0

func _on_play_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_garage_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/Garage.tscn")

func _on_cars_pressed() -> void:
    print("Cars screen not implemented yet. Placeholder menu flow enabled.")

func _on_missions_pressed() -> void:
    print("Missions screen not implemented yet. Placeholder menu flow enabled.")

func _on_settings_pressed() -> void:
    print("Settings screen not implemented yet. Placeholder menu flow enabled.")

func _on_controls_pressed() -> void:
    print("Controls screen not implemented yet. Placeholder menu flow enabled.")

func _on_exit_pressed() -> void:
    get_tree().quit()
