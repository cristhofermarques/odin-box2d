package main

import b2 ".."
import "core:fmt"

main :: proc()
{
    gravity := b2.Vec2{0, -10}

    world_def := b2.DEFAULT_WORLD_DEF
    world_def.gravity = b2.Vec2{0, -10}
    world_id := b2.create_world(&world_def)
    defer b2.destroy_world(world_id)
    
    ground_body_def := b2.DEFAULT_BODY_DEF
    ground_body_def.position = b2.Vec2{0, -10}
    ground_body_id := b2.world_create_body(world_id, &ground_body_def)

    ground_box := b2.make_box(50, 10)
    ground_shape_def := b2.DEFAULT_SHAPE_DEF
    b2.body_create_polygon(ground_body_id, &ground_shape_def, &ground_box)

    body_def := b2.DEFAULT_BODY_DEF
    body_def.type = .Dynamic
    body_def.position = b2.Vec2{0, 4}
    body_id := b2.world_create_body(world_id, &body_def)

    //dynamic_box := b2.make_box(1, 1)
    shape_def := b2.DEFAULT_SHAPE_DEF
    shape_def.density = 1
    shape_def.friction = 0.3
    // b2.body_create_polygon(body_id, &shape_def, &dynamic_box)

    circle: b2.Circle
    circle.radius = 1
    b2.body_create_circle(body_id, &shape_def, &circle)

    time_step: f32 = 1.0 / 60.0
    velocity_iterations: i32 = 6
    position_iterations: i32 = 2

    pos := b2.body_get_position(body_id)
    ang := b2.body_get_angle(body_id)
    
    for i in 0..<60
    {
        b2.world_step(world_id, time_step, velocity_iterations, position_iterations)
        pos = b2.body_get_position(body_id)
        ang = b2.body_get_angle(body_id)
        fmt.println(pos, ang)
    }
}