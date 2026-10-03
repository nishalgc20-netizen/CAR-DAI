extends Control

@onready var back_button: Button = $VBoxContainer/BackButton
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var upgrade_button: Button = $VBoxContainer/UpgradeButton
@onready var preview: Node3D = $Preview

func _ready() -> void:
    _build_preview_car()
    back_button.pressed.connect(_on_back_pressed)
    start_button.pressed.connect(_on_start_pressed)
    upgrade_button.pressed.connect(_on_upgrade_pressed)

func _build_preview_car() -> void:
    var body := MeshInstance3D.new(); var body_mesh := BoxMesh.new(); body_mesh.size = Vector3(2.0, 0.7, 3.6); body.mesh = body_mesh; body.position = Vector3(0, 0.4, 0); preview.add_child(body)
    var roof := MeshInstance3D.new(); var roof_mesh := BoxMesh.new(); roof_mesh.size = Vector3(1.2, 0.6, 1.8); roof.mesh = roof_mesh; roof.position = Vector3(0, 1.0, 0); preview.add_child(roof)
    for i in range(4):
        var wheel := MeshInstance3D.new(); var wheel_mesh := CylinderMesh.new(); wheel_mesh.top_radius = 0.24; wheel_mesh.bottom_radius = 0.24; wheel_mesh.height = 0.2; wheel.mesh = wheel_mesh; wheel.rotation_degrees.x = 90.0
        var x := [-1.0, 1.0, -1.0, 1.0][i]; var z := [-1.3, -1.3, 1.3, 1.3][i]; wheel.position = Vector3(x, -0.1, z); preview.add_child(wheel)
    preview.position = Vector3(0, -0.3, 0)
    preview.rotation_degrees.x = 18
    preview.rotation_degrees.y = 30

func _on_start_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_upgrade_pressed() -> void:
    print("Upgrade system placeholder active.")

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
