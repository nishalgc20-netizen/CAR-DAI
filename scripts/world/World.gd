extends Node3D

var player_scene: PackedScene = preload("res://scenes/player/Car.tscn")
var traffic_scene: PackedScene = preload("res://scenes/traffic/TrafficCar.tscn")
var hud_scene: PackedScene = preload("res://scenes/ui/HUD.tscn")
var touch_controls_scene: PackedScene = preload("res://scenes/ui/TouchControls.tscn")

var player: RigidBody3D
var traffic_cars: Array = []

func _ready() -> void:
    build_world()
    spawn_player()
    spawn_traffic()
    add_hud()
    add_touch_controls()

func build_world() -> void:
    var ambient := DirectionalLight3D.new();
    ambient.rotation_degrees = Vector3(-30, 45, 0)
    ambient.light_energy = 1.0
    add_child(ambient)

    var sunlight := DirectionalLight3D.new()
    sunlight.rotation_degrees = Vector3(-45, 150, 0)
    sunlight.light_energy = 0.6
    add_child(sunlight)

    var world_root := Node3D.new()
    world_root.name = "WorldRoot"
    add_child(world_root)

    var ground := StaticBody3D.new()
    ground.position = Vector3(0, -0.5, 0)
    world_root.add_child(ground)
    var ground_shape := CollisionShape3D.new()
    var ground_box := BoxShape3D.new(); ground_box.size = Vector3(200, 1, 200)
    ground_shape.shape = ground_box
    ground.add_child(ground_shape)
    var ground_mesh := MeshInstance3D.new()
    var ground_mesh_data := BoxMesh.new(); ground_mesh_data.size = Vector3(200, 1, 200)
    ground_mesh.mesh = ground_mesh_data
    ground_mesh.position = Vector3(0, 0, 0)
    ground.add_child(ground_mesh)

    var main_road: StaticBody3D = _make_road(Vector3(0, 0.1, 0), Vector3(18, 0.3, 120))
    var secondary_road: StaticBody3D = _make_road(Vector3(0, 0.1, 70), Vector3(120, 0.3, 18))
    var highway: StaticBody3D = _make_road(Vector3(-35, 0.1, 30), Vector3(18, 0.3, 200))
    var parking: StaticBody3D = _make_road(Vector3(45, 0.1, -25), Vector3(80, 0.3, 18))
    world_root.add_child(main_road)
    world_root.add_child(secondary_road)
    world_root.add_child(highway)
    world_root.add_child(parking)

    for i in range(-4, 5):
        var building := MeshInstance3D.new()
        var mesh := BoxMesh.new(); mesh.size = Vector3(8, 18 + (i % 3) * 5, 8)
        building.mesh = mesh
        building.position = Vector3(24 + (i % 3) * 22, 9, 35 + (i * 10))
        world_root.add_child(building)

        var building_2 := MeshInstance3D.new();
        var mesh_2 := BoxMesh.new(); mesh_2.size = Vector3(10, 12, 10)
        building_2.mesh = mesh_2
        building_2.position = Vector3(-30 + i * 12, 6, -30 + (i % 4) * 15)
        world_root.add_child(building_2)

    var tree_positions := [
        Vector3(14, 0.5, -18), Vector3(18, 0.5, -8), Vector3(-18, 0.5, 18),
        Vector3(-12, 0.5, 45), Vector3(40, 0.5, 16), Vector3(60, 0.5, -15)
    ]
    for pos in tree_positions:
        var trunk := MeshInstance3D.new();
        var trunk_mesh := CylinderMesh.new(); trunk_mesh.top_radius = 0.18; trunk_mesh.bottom_radius = 0.26; trunk_mesh.height = 2.2
        trunk.mesh = trunk_mesh
        trunk.position = pos + Vector3(0, 1.0, 0)
        world_root.add_child(trunk)
        var crown := MeshInstance3D.new();
        var crown_mesh := SphereMesh.new(); crown_mesh.radius = 1.2; crown_mesh.height = 1.8
        crown.mesh = crown_mesh
        crown.position = pos + Vector3(0, 2.8, 0)
        world_root.add_child(crown)

    for light_pos in [Vector3(8, 2.5, 15), Vector3(-8, 2.5, 15), Vector3(8, 2.5, -15), Vector3(-8, 2.5, -15)]:
        var light := OmniLight3D.new();
        light.position = light_pos
        light.light_energy = 1.2
        light.light_color = Color(1, 0.95, 0.75)
        world_root.add_child(light)

    var garage_base := StaticBody3D.new();
    garage_base.position = Vector3(60, 0.6, 35)
    var garage_shape := CollisionShape3D.new(); var garage_box = BoxShape3D.new(); garage_box.size = Vector3(16, 1.2, 12)
    garage_shape.shape = garage_box
    garage_base.add_child(garage_shape)
    var garage_mesh := MeshInstance3D.new(); var g_mesh := BoxMesh.new(); g_mesh.size = Vector3(16, 1.2, 12)
    garage_mesh.mesh = g_mesh
    garage_base.add_child(garage_mesh)
    world_root.add_child(garage_base)

    var checkpoint := Area3D.new();
    checkpoint.position = Vector3(-24, 0.5, 48)
    checkpoint.monitoring = true
    var checkpoint_shape := CollisionShape3D.new(); var cshape = BoxShape3D.new(); cshape.size = Vector3(18, 4, 8)
    checkpoint_shape.shape = cshape
    checkpoint.add_child(checkpoint_shape)
    world_root.add_child(checkpoint)

    var camera = Camera3D.new();
    camera.position = Vector3(0, 4, 12)
    camera.rotation_degrees.x = -18
    camera.current = true
    add_child(camera)

func _make_road(position: Vector3, size: Vector3) -> StaticBody3D:
    var road := StaticBody3D.new();
    road.position = position
    var collision := CollisionShape3D.new();
    var box := BoxShape3D.new(); box.size = size
    collision.shape = box
    road.add_child(collision)
    var mesh := MeshInstance3D.new();
    var road_mat := BoxMesh.new(); road_mat.size = size
    mesh.mesh = road_mat
    mesh.position = Vector3.ZERO
    road.add_child(mesh)
    return road

func spawn_player() -> void:
    player = player_scene.instantiate()
    player.position = Vector3(0, 1.3, 8)
    add_child(player)

func spawn_traffic() -> void:
    var positions := [
        Vector3(-10, 1.2, 15), Vector3(30, 1.2, 25), Vector3(-35, 1.2, -10), Vector3(50, 1.2, -20)
    ]
    for idx in range(positions.size()):
        var traffic := traffic_scene.instantiate()
        traffic.position = positions[idx]
        traffic.set("move_axis", "z" if idx % 2 == 0 else "x")
        traffic.set("speed", 8.0 + idx)
        traffic.set("direction", 1 if idx % 2 == 0 else -1)
        add_child(traffic)
        traffic_cars.append(traffic)

func add_hud() -> void:
    var hud := hud_scene.instantiate()
    add_child(hud)

func add_touch_controls() -> void:
    var touch_controls := touch_controls_scene.instantiate()
    add_child(touch_controls)
