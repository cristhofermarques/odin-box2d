package box2d

// This function receives shapes found in the AABB query.
// @return true if the query should continue
Query_Callback_Fcn :: #type proc "c" (shape_id: Shape_ID, context_: rawptr) -> bool

when ODIN_OS == .Windows && ODIN_ARCH == .amd64 && ODIN_DEBUG do foreign import box2d {
    "binaries/windows_amd64_debug/box2d.lib",
}

when ODIN_OS == .Windows && ODIN_ARCH == .amd64 && !ODIN_DEBUG do foreign import box2d {
    "binaries/windows_amd64_release/box2d.lib",
}

foreign box2d
{    
    /* box2d.h */

    // Create a world for rigid body simulation. This contains all the bodies, shapes, and constraints.
    @(link_name="b2CreateWorld")
    create_world :: proc "c" (def: ^World_Def) -> World_ID ---

    // Destroy a world.
    @(link_name="b2DestroyWorld")
    destroy_world :: proc "c" (world_id: World_ID) ---

    // Take a time step. This performs collision detection, integration,
    // and constraint solution.
    // @param timeStep the amount of time to simulate, this should not vary.
    // @param velocityIterations for the velocity constraint solver.
    // @param positionIterations for the position constraint solver.
    @(link_name="b2World_Step") 
    world_step :: proc "c" (world_id: World_ID, time_step: f32, velocity_iterations, position_iterations: i32) ---

    // Call this to draw shapes and other debug draw data. This is intentionally non-const.
    @(link_name="b2World_Draw")
    world_draw :: proc "c" (world_id: World_ID, debug_draw: ^Debug_Draw) ---

    // Enable/disable sleep.
    @(link_name="b2World_EnableSleeping")
    world_enable_sleeping :: proc "c" (world_id: World_ID, flag: bool) ---

    // Enable/disable continuous collision.
    @(link_name="b2World_EnableContinuous")
    world_enable_continuous :: proc "c" (world_id: World_ID, flag: bool) ---

    // Get the current profile.
    @(link_name="b2World_GetProfile")
    world_get_profile :: proc "c" (world_id: World_ID) -> Profile ---

    @(link_name="b2World_GetStatistics")
    world_get_statistics :: proc "c" (world_id: World_ID) -> Statistics ---

    // Create a rigid body given a definition. No reference to the definition is retained.
    // @warning This function is locked during callbacks.
    @(link_name="b2World_CreateBody")
    world_create_body :: proc "c" (world_id: World_ID, def: ^Body_Def) -> Body_ID ---

    // Destroy a rigid body given an id.
    // @warning This function is locked during callbacks.
    @(link_name="b2World_DestroyBody")
    world_destroy_body :: proc "c" (body_id: Body_ID) ---

    @(link_name="b2Body_GetPosition")
    body_get_position :: proc "c" (body_id: Body_ID) -> Vec2 ---

    @(link_name="b2Body_GetAngle")
    body_get_angle :: proc "c" (body_id: Body_ID) -> f32 ---

    @(link_name="b2Body_GetLocalPoint")
    body_get_local_point :: proc "c" (body_id: Body_ID, global_point: Vec2) -> Vec2 ---

    @(link_name="b2Body_SetTransform")
    body_set_transform :: proc "c" (body_id: Body_ID, position: Vec2, angle: f32) ---

    @(link_name="b2Body_SetLinearVelocity")
    body_set_linear_velocity :: proc "c" (body_id: Body_ID, linear_velocity: Vec2) ---

    @(link_name="b2Body_SetAngularVelocity")
    body_set_angular_velocity :: proc "c" (body_id: Body_ID, angular_velocity: f32) ---

    @(link_name="b2Body_GetType")
    body_get_type :: proc "c" (body_id: Body_ID) -> Body_Type ---

    @(link_name="b2Body_GetMass")
    body_get_mass :: proc "c" (body_id: Body_ID) -> f32 ---

    @(link_name="b2Body_Wake")
    body_wake :: proc "c" (body_id: Body_ID) ---

    // Create a shape and attach it to a body. Contacts are not created until the next time step.
    // @warning This function is locked during callbacks.
    @(link_name="b2Body_CreateCircle")
    body_create_circle :: proc "c" (body_id: Body_ID, def: ^Shape_Def, circle: ^Circle) -> Shape_ID ---

    @(link_name="b2Body_CreateSegment")
    body_create_segment :: proc "c" (body_id: Body_ID, def: ^Shape_Def, segment: ^Segment) -> Shape_ID ---

    @(link_name="b2Body_CreateCapsule")
    body_create_capsule :: proc "c" (body_id: Body_ID, def: ^Shape_Def, capsule: ^Capsule) -> Shape_ID ---

    @(link_name="b2Body_CreatePolygon")
    body_create_polygon :: proc "c" (body_id: Body_ID, def: ^Shape_Def, polygon: ^Polygon) -> Shape_ID ---

    @(link_name="b2Shape_GetBody")
    shape_get_point :: proc "c" (shape_id: Shape_ID) -> Body_ID ---

    @(link_name="b2Shape_TestPoint")
    shape_test_point :: proc "c" (shape_id: Shape_ID, point: Vec2) -> bool ---

    @(link_name="b2World_CreateMouseJoint")
    world_create_mouse_joint :: proc "c" (world_id: World_ID, def: ^Mouse_Joint_Def) -> Joint_ID ---

    @(link_name="b2World_CreateRevoluteJoint")
    world_create_revolute_joint :: proc "c" (world_id: World_ID, def: ^Revolute_Joint_Def) -> Joint_ID ---

    @(link_name="b2World_DestroyJoint")
    world_destroy_joint :: proc "c" (joint_id: Joint_ID) ---

    @(link_name="b2MouseJoint_SetTarget")
    mouse_joint_set_target :: proc "c" (joint_id: Joint_ID, target: Vec2) ---

    @(link_name="b2RevoluteJoint_EnableLimit")
    revolute_joint_enable_limit :: proc "c" (joint_id: Joint_ID, enable_limit: bool) ---

    @(link_name="b2RevoluteJoint_EnableMotor")
    revolute_joint_enable_motor :: proc "c" (joint_id: Joint_ID, enable_motor: bool) ---

    @(link_name="b2RevoluteJoint_SetMotorSpeed")
    revolute_joint_set_motor_speed :: proc "c" (joint_id: Joint_ID, motor_speed: f32) ---

    @(link_name="b2RevoluteJoint_GetMotorTorque")
    revolute_joint_get_motor_torque :: proc "c" (joint_id: Joint_ID, inverse_time_step: f32) -> f32 ---

    // Query the world for all shapse that potentially overlap the provided AABB.
    // @param callback a user implemented callback function.
    // @param aabb the query box.
    @(link_name="b2World_QueryAABB")
    world_query_aabb :: proc "c" (world_id: World_ID, aabb: AABB, fcn: Query_Callback_Fcn, context_: rawptr) ---
    
    /* geometry.h */
    
    @(link_name="b2IsValidRay")
    is_valid_ray :: proc "c" (input: ^Ray_Cast_Input) -> bool ---
    
    // Helper functions to make convex polygons
    @(link_name="b2MakePolygon")
    make_polygon :: proc "c" (hull: ^Hull, radius: f32) -> Polygon ---

    @(link_name="b2MakeSquare")
    make_square :: proc "c" (h: f32) -> Polygon ---

    @(link_name="b2MakeBox")
    make_box :: proc "c" (hx, hy: f32) -> Polygon ---
    
    @(link_name="b2MakeRoundedBox")
    make_rounded_box :: proc "c" (hx, hy, radius: f32) -> Polygon ---

    @(link_name="b2MakeOffsetBox")
    make_offset_box :: proc "c" (hx, hy: f32, center: Vec2, angle: f32) -> Polygon ---

    @(link_name="b2MakeCapsule")
    make_capsule :: proc "c" (p1, p2: Vec2, radius: f32) -> Polygon ---

    // Compute mass properties
    @(link_name="ComputeCircleMass")
    compute_circle_mass :: proc "c" (shape: ^Circle, density: f32) -> Mass_Data ---

    @(link_name="ComputeCapsuleMass")
    compute_capsule_mass :: proc "c" (shape: ^Capsule, density: f32) -> Mass_Data ---

    @(link_name="ComputePolygonMass")
    compute_polygon_mass :: proc "c" (shape: ^Polygon, density: f32) -> Mass_Data ---

    // These compute the bounding box in world space
    @(link_name="b2ComputeCircleAABB")
    compute_circle_aabb :: proc "c" (shape: ^Circle, xf: Transform) -> AABB ---

    @(link_name="b2ComputeCapsuleAABB")
    compute_capsule_aabb :: proc "c" (shape: ^Capsule, xf: Transform) -> AABB ---

    @(link_name="b2ComputePolygonAABB")
    compute_polygon_aabb :: proc "c" (shape: ^Polygon, xf: Transform) -> AABB ---

    @(link_name="b2ComputeSegmentAABB")
    compute_segment_aabb :: proc "c" (shape: ^Segment, xf: Transform) -> AABB ---

    // Test a point in local space
    @(link_name="b2PointInCircle")
    point_in_circle :: proc "c" (point: Vec2, shape: ^Circle) -> bool ---

    @(link_name="b2PointInCapsule")
    point_in_capsule :: proc "c" (point: Vec2, shape: ^Capsule) -> bool ---

    @(link_name="b2PointInPolygon")
    point_in_polygon :: proc "c" (point: Vec2, shape: ^Polygon) -> bool ---

    // Ray cast versus shape in shape local space. Initial overlap is treated as a miss.
    @(link_name="b2RayCastCircle")
    ray_cast_circle :: proc "c" (input: ^Ray_Cast_Input, shape: ^Circle) -> Ray_Cast_Output ---

    @(link_name="b2RayCastCapsule")
    ray_cast_capsule :: proc "c" (input: ^Ray_Cast_Input, shape: ^Capsule) -> Ray_Cast_Output ---

    @(link_name="b2RayCastSegment")
    ray_cast_segment :: proc "c" (input: ^Ray_Cast_Input, shape: ^Segment) -> Ray_Cast_Output ---

    @(link_name="b2RayCastPolygon")
    ray_cast_polygon :: proc "c" (input: ^Ray_Cast_Input, shape: ^Polygon) -> Ray_Cast_Output ---

    /* joint_util.h */
    
    // Utility to compute linear stiffness values from frequency and damping ratio
    @(link_name="b2LinearStiffness")
    linear_stiffness :: proc "c" (stiffness, damping: ^f32, frequency_hertz, damping_ratio: f32, body_a, body_b: Body_ID) ---
    
    // Utility to compute rotational stiffness values frequency and damping ratio
    @(link_name="b2AngularStiffness")
    angular_stiffness :: proc "c" (stiffness, damping: ^f32, frequency_hertz, damping_ratio: f32, body_a, body_b: Body_ID) ---
}