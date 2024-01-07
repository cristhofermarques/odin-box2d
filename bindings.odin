package box2d

// This function receives shapes found in the AABB query.
// @return true if the query should continue
Query_Callback_Fcn :: #type proc "c" (shape_id: Shape_ID, context_: rawptr) -> bool

when ODIN_OS == .Windows && ODIN_ARCH == .amd64 do foreign import box2d {
    "binaries/box2d_windows_amd64.lib",
}

@(default_calling_convention="c")
foreign box2d
{
    @(link_name="b2_parallel")
    parallel: bool

    /* constants.h */

    
    // Current version.
    @(link_name="b2_version")
    version: Version

    
    /* box2d.h */


    // Create a world for rigid body simulation. This contains all the bodies, shapes, and constraints.
    @(link_name="b2CreateWorld")
    create_world :: proc(def: ^World_Def) -> World_ID ---

    // Destroy a world.
    @(link_name="b2DestroyWorld")
    destroy_world :: proc(world_id: World_ID) ---

    // Take a time step. This performs collision detection, integration,
    // and constraint solution.
    // @param timeStep the amount of time to simulate, this should not vary.
    // @param velocityIterations for the velocity constraint solver.
    // @param positionIterations for the position constraint solver.
    @(link_name="b2World_Step") 
    world_step :: proc(world_id: World_ID, time_step: f32, velocity_iterations, position_iterations: i32) ---

    // Call this to draw shapes and other debug draw data. This is intentionally non-const.
    @(link_name="b2World_Draw")
    world_draw :: proc(world_id: World_ID, debug_draw: ^Debug_Draw) ---

    // Create a rigid body given a definition. No reference to the definition is retained.
    // @warning This function is locked during callbacks.
    @(link_name="b2World_CreateBody")
    world_create_body :: proc(world_id: World_ID, def: ^Body_Def) -> Body_ID ---

    // Destroy a rigid body given an id.
    // @warning This function is locked during callbacks.
    @(link_name="b2World_DestroyBody")
    world_destroy_body :: proc(body_id: Body_ID) ---


    @(link_name="b2Body_GetPosition")
    body_get_position :: proc(body_id: Body_ID) -> Vec2 ---

    @(link_name="b2Body_GetAngle")
    body_get_angle :: proc(body_id: Body_ID) -> f32 ---

    @(link_name="b2Body_SetTransform")
    body_set_transform :: proc(body_id: Body_ID, position: Vec2, angle: f32) ---


    @(link_name="b2Body_GetLocalPoint")
    body_get_local_point :: proc(body_id: Body_ID, global_point: Vec2) -> Vec2 ---

    @(link_name="b2Body_GetWorldPoint")
    body_get_world_point :: proc(body_id: Body_ID, local_point: Vec2) -> Vec2 ---


    @(link_name="b2Body_GetLocalVector")
    body_get_local_vector :: proc(body_id: Body_ID, global_vector: Vec2) -> Vec2 ---

    @(link_name="b2Body_GetWorldVector")
    body_get_world_vector :: proc(body_id: Body_ID, local_vector: Vec2) -> Vec2 ---


    @(link_name="b2Body_GetLinearVelocity")
    body_get_linear_velocity :: proc(body_id: Body_ID) -> Vec2 ---

    @(link_name="b2Body_GetAngularVelocity")
    body_get_angular_velocity :: proc(body_id: Body_ID) -> f32 ---
    
    @(link_name="b2Body_SetLinearVelocity")
    body_set_linear_velocity :: proc(body_id: Body_ID, linear_velocity: Vec2) ---

    @(link_name="b2Body_SetAngularVelocity")
    body_set_angular_velocity :: proc(body_id: Body_ID, angular_velocity: f32) ---


    @(link_name="b2Body_GetType")
    body_get_type :: proc(body_id: Body_ID) -> Body_Type ---

    @(link_name="b2Body_SetType")
    body_set_type :: proc(body_id: Body_ID, type: Body_Type) ---
    

    /// Get the user data stored in a body
    @(link_name="b2Body_GetUserData")
    body_get_user_data :: proc(body_id: Body_ID) -> rawptr ---

    // Get the mass of the body (kilograms)
    @(link_name="b2Body_GetMass")
    body_get_mass :: proc(body_id: Body_ID) -> f32 ---

    // Get the inertia tensor of the body. In 2D this is a single number. (kilograms * meters^2)
    @(link_name="b2Body_GetInertiaTensor")
    body_get_inertia_tensor :: proc(body_id: Body_ID) -> f32 ---

    // Get the center of mass position of the body in local space.
    @(link_name="b2Body_GetLocalCenterOfMass")
    body_get_local_center_of_mass :: proc(body_id: Body_ID) -> Vec2 ---

    // Get the center of mass position of the body in world space.
    @(link_name="b2Body_GetWorldCenterOfMass")
    body_get_world_center_of_mass :: proc(body_id: Body_ID) -> Vec2 ---

    // Override the body's mass properties. Normally this is computed automatically using the
    // shape geometry and density. This information is lost if a shape is added or removed or if the
    // body type changes.
    @(link_name="b2Body_SetMassData")
    body_set_mass_data :: proc(mass_data: Mass_Data) ---
    
    // Is this body awake?
    @(link_name="b2Body_IsAwake")
    body_is_awake :: proc(body_id: Body_ID) ---

    // Wake a body from sleep. This wakes the entire island the body is touching.
    @(link_name="b2Body_Wake")
    body_wake :: proc(body_id: Body_ID) ---

    // Is this body enabled?
    @(link_name="b2Body_IsEnabled")
    body_is_enabled :: proc(body_id: Body_ID) -> bool ---

    // Disable a body by removing it completely from the simulation
    @(link_name="b2Body_Disable")
    body_disable :: proc(body_id: Body_ID) ---

    // Enable a body by adding it to the simulation
    @(link_name="b2Body_Enable")
    body_enable :: proc(body_id: Body_ID) ---


    // Create a shape and attach it to a body. Contacts are not created until the next time step.
    // @warning This function is locked during callbacks.
    @(link_name="b2Body_CreateCircle")
    body_create_circle :: proc(body_id: Body_ID, def: ^Shape_Def, circle: ^Circle) -> Shape_ID ---

    // Create a shape and attach it to a body. Contacts are not created until the next time step.
    // @warning This function is locked during callbacks.
    @(link_name="b2Body_CreateSegment")
    body_create_segment :: proc(body_id: Body_ID, def: ^Shape_Def, segment: ^Segment) -> Shape_ID ---

    // Create a shape and attach it to a body. Contacts are not created until the next time step.
    // @warning This function is locked during callbacks.
    @(link_name="b2Body_CreateCapsule")
    body_create_capsule :: proc(body_id: Body_ID, def: ^Shape_Def, capsule: ^Capsule) -> Shape_ID ---

    // Create a shape and attach it to a body. Contacts are not created until the next time step.
    // @warning This function is locked during callbacks.
    @(link_name="b2Body_CreatePolygon")
    body_create_polygon :: proc(body_id: Body_ID, def: ^Shape_Def, polygon: ^Polygon) -> Shape_ID ---

    @(link_name="b2Body_DestroyShape")
    body_destroy_shape :: proc(shape_id: Shape_ID) ---


    @(link_name="b2Shape_GetBody")
    shape_get_body :: proc(shape_id: Shape_ID) -> Body_ID ---

    @(link_name="b2Shape_GetUserData")
    shape_get_user_data :: proc(shape_id: Shape_ID) -> rawptr ---

    @(link_name="b2Shape_TestPoint")
    shape_test_point :: proc(shape_id: Shape_ID, point: Vec2) -> bool ---

    @(link_name="b2Shape_SetFriction")
    shape_set_friction :: proc(shape_id: Shape_ID, friction: f32) ---

    @(link_name="b2Shape_SetRestitution")
    shape_set_restitution :: proc(shape_id: Shape_ID, restitution: f32) ---


    @(link_name="b2Body_CreateChain")
    body_create_chain :: proc(body_id: Body_ID, def: ^Chain_Def) -> Chain_ID ---

    @(link_name="b2Body_DestroyChain")
    body_destroy_chain :: proc(chain_id: Chain_ID) ---

    @(link_name="b2Chain_SetFriction")
    chain_set_friction :: proc(chain_id: Chain_ID, friction: f32) ---

    @(link_name="b2Chain_SetRestitution")
    chain_set_restitution :: proc(chain_id: Chain_ID, restitution: f32) ---


    // Create a joint
    @(link_name="b2World_CreateDistanceJoint")
    world_create_distance_joint :: proc(world_id: World_ID, def: ^Distance_Joint_Def) -> Joint_ID ---

    @(link_name="b2World_CreateMouseJoint")
    world_create_mouse_joint :: proc(world_id: World_ID, def: ^Mouse_Joint_Def) -> Joint_ID ---

    @(link_name="b2World_CreatePrismaticJoint")
    world_create_prismatic_joint :: proc(world_id: World_ID, def: ^Prismatic_Joint_Def) -> Joint_ID ---

    @(link_name="b2World_CreateRevoluteJoint")
    world_create_revolute_joint :: proc(world_id: World_ID, def: ^Revolute_Joint_Def) -> Joint_ID ---

    @(link_name="b2World_CreateWeldJoint")
    world_create_weld_joint :: proc(world_id: World_ID, def: ^Weld_Joint_Def) -> Joint_ID ---


    // Destroy a joint
    @(link_name="b2World_DestroyJoint")
    world_destroy_joint :: proc(joint_id: Joint_ID) ---

    @(link_name="b2Joint_GetBodyA")
    joint_get_body_a :: proc(joint_id: Joint_ID) -> Body_ID ---

    @(link_name="b2Joint_GetBodyB")
    joint_get_body_b :: proc(joint_id: Joint_ID) -> Body_ID ---


    // Distance join access
    @(link_name="b2DistanceJoint_GetConstraintForce")
    distance_joint_get_constraint_force :: proc(joint_id: Joint_ID, time_step: f32) -> f32 ---

    @(link_name="b2DistanceJoint_SetLength")
    distance_joint_set_length :: proc(joint_id: Joint_ID, length, min_length, max_length: f32) ---

    @(link_name="b2DistanceJoint_GetCurrentLength")
    distance_joint_get_current_length :: proc(joint_id: Joint_ID) -> f32 ---

    @(link_name="b2DistanceJoint_SetTuning")
    distance_joint_set_tuning :: proc(joint_id: Joint_ID, hertz, damping_ratio: f32) ---


    // Mouse joint access
    @(link_name="b2MouseJoint_SetTarget")
    mouse_joint_set_target :: proc(joint_id: Joint_ID, target: Vec2) ---


    // Revolute joint access
    @(link_name="b2RevoluteJoint_EnableLimit")
    revolute_joint_enable_limit :: proc(joint_id: Joint_ID, enable_limit: bool) ---

    @(link_name="b2RevoluteJoint_EnableMotor")
    revolute_joint_enable_motor :: proc(joint_id: Joint_ID, enable_motor: bool) ---

    @(link_name="b2RevoluteJoint_SetMotorSpeed")
    revolute_joint_set_motor_speed :: proc(joint_id: Joint_ID, motor_speed: f32) ---

    @(link_name="b2RevoluteJoint_GetMotorTorque")
    revolute_joint_get_motor_torque :: proc(joint_id: Joint_ID, inverse_time_step: f32) -> f32 ---

    @(link_name="b2RevoluteJoint_SetMaxMotorTorque")
    revolute_joint_set_max_motor_torque :: proc(joint_id: Joint_ID, torque: f32) ---

    @(link_name="b2RevoluteJoint_GetConstraintForce")
    revolute_joint_get_constraint_force :: proc(joint_id: Joint_ID) -> Vec2 ---


    // Query the world for all shapse that potentially overlap the provided AABB.
    // @param callback a user implemented callback function.
    // @param aabb the query box.
    @(link_name="b2World_QueryAABB")
    world_query_aabb :: proc(world_id: World_ID, aabb: AABB, fcn: Query_Callback_Fcn, context_: rawptr) ---
    
    /// Query the world for all shapes that overlap the provided circle.
    @(link_name="b2World_OverlapCircle")
    world_overlap_circle :: proc(world_id: World_ID, fcn: Query_Result_Fcn, circle: ^Circle, transform: Transform, filter: Query_Filter, context_: rawptr) ---
    
    /// Query the world for all shapes that overlap the provided capsule.
    @(link_name="b2World_OverlapCapsule")
    world_overlap_capsule :: proc(world_id: World_ID, fcn: Query_Result_Fcn, capsule: ^Capsule, transform: Transform, filter: Query_Filter, context_: rawptr) ---
        
    /// Query the world for all shapes that overlap the provided polygon.
    @(link_name="b2World_OverlapPolygon")
    world_overlap_polygon :: proc(world_id: World_ID, fcn: Query_Result_Fcn, polygon: ^Polygon, transform: Transform, filter: Query_Filter, context_: rawptr) ---

    // Ray-cast the world for all shapes in the path of the ray. Your callback
    // controls whether you get the closest point, any point, or n-points.
    // The ray-cast ignores shapes that contain the starting point.
    // *param 'callback' a user implemented callback class.
    // * param 'point1' the ray starting point
    // * param 'point2' the ray ending point
    @(link_name="b2World_RayCast")
    world_ray_cast :: proc(world_id: World_ID, origin, translation: Vec2, filter: Query_Filter, fcn: Ray_Result_Fcn, context_: rawptr) ---
        
    // Ray-cast closest hit. Convenience function. This is less general than b2World_RayCast and does not allow for custom filtering.
    @(link_name="b2World_RayCastClosest")
    world_ray_cast_closest :: proc(world_id: World_ID, origin, translation: Vec2, filter: Query_Filter) -> Ray_Result ---
    
    @(link_name="b2World_CircleCast")
    world_circle_cast :: proc(world_id: World_ID, circle: ^Circle, origin_transform: Transform, translation: Vec2, filter: Query_Filter, fcn: Ray_Result_Fcn, context_: rawptr) ---
        
    @(link_name="b2World_CapsuleCast")
    world_capsule_cast :: proc(world_id: World_ID, capsule: ^Capsule, origin_transform: Transform, translation: Vec2, filter: Query_Filter, fcn: Ray_Result_Fcn, context_: rawptr) ---
        
    @(link_name="b2World_PolygonCast")
    world_polygon_cast :: proc(world_id: World_ID, polygon: ^Polygon, origin_transform: Transform, translation: Vec2, filter: Query_Filter, fcn: Ray_Result_Fcn, context_: rawptr) ---

    // World events
    // Get sensor events for the current time step. Do not store a reference to this data.
    @(link_name="b2World_GetSensorEvents")
    world_get_sensor_events :: proc(world_id: World_ID) -> Sensor_Events ---
    
    // Id validation. These allow validation for up 64K allocations.
    @(link_name="b2World_IsValid")
    world_is_valid :: proc(id: World_ID) -> bool ---

    @(link_name="b2Body_IsValid")
    body_is_valid :: proc(id: Body_ID) -> bool ---

    @(link_name="b2Shape_IsValid")
    shape_is_valid :: proc(id: Shape_ID) -> bool ---

    @(link_name="b2Chain_IsValid")
    chain_is_valid :: proc(id: Chain_ID) -> bool ---

    @(link_name="b2Joint_IsValid")
    joint_is_valid :: proc(id: Joint_ID) -> bool ---
    
    // Advanced API for testing and special cases
    // Enable/disable sleep.
    @(link_name="b2World_EnableSleeping")
    world_enable_sleeping :: proc(world_id: World_ID, flag: bool) ---

    /// Enable/disable contact warm starting. Improves stacking stability.
    @(link_name="b2World_EnableWarmStarting")
    world_enable_warm_starting :: proc(world_id: World_ID, flag: bool) ---

    // Enable/disable continuous collision.
    @(link_name="b2World_EnableContinuous")
    world_enable_continuous :: proc(world_id: World_ID, flag: bool) ---

    // Adjust the restitution threshold
    @(link_name="b2World_SetRestitutionThreshold")
    world_set_restitution_threshold :: proc(world_id: World_ID, value: f32) ---

    // Adjust contact tuning parameters:
    // - hertz is the contact stiffness (cycles per second)
    // - damping ratio is the contact bounciness with 1 being critical damping (non-dimensional)
    // - push velocity is the maximum contact constraint push out velocity (meters per second)
    @(link_name="b2World_SetContactTuning")
    world_set_contact_tuning :: proc(worldId: World_ID, hertz, damping_ratio, push_velocity: f32) ---

    // Get the current profile.
    @(link_name="b2World_GetProfile")
    world_get_profile :: proc(world_id: World_ID) -> Profile ---

    @(link_name="b2World_GetStatistics")
    world_get_statistics :: proc(world_id: World_ID) -> Statistics ---
    
    /* geometry.h */
    
    @(link_name="b2IsValidRay")
    is_valid_ray :: proc(input: ^Ray_Cast_Input) -> bool ---
    

    // Helper functions to make convex polygons
    @(link_name="b2MakePolygon")
    make_polygon :: proc(hull: ^Hull, radius: f32) -> Polygon ---

    @(link_name="b2MakeOffsetPolygon")
    make_offset_polygon :: proc(hull: ^Hull, radius: f32, transform: Transform) -> Polygon ---

    @(link_name="b2MakeSquare")
    make_square :: proc(h: f32) -> Polygon ---

    @(link_name="b2MakeBox")
    make_box :: proc(hx, hy: f32) -> Polygon ---
    
    @(link_name="b2MakeRoundedBox")
    make_rounded_box :: proc(hx, hy, radius: f32) -> Polygon ---

    @(link_name="b2MakeOffsetBox")
    make_offset_box :: proc(hx, hy: f32, center: Vec2, angle: f32) -> Polygon ---

    @(link_name="b2MakeCapsule")
    make_capsule :: proc(p1, p2: Vec2, radius: f32) -> Polygon ---


    // Compute mass properties
    @(link_name="ComputeCircleMass")
    compute_circle_mass :: proc(shape: ^Circle, density: f32) -> Mass_Data ---

    @(link_name="ComputeCapsuleMass")
    compute_capsule_mass :: proc(shape: ^Capsule, density: f32) -> Mass_Data ---

    @(link_name="ComputePolygonMass")
    compute_polygon_mass :: proc(shape: ^Polygon, density: f32) -> Mass_Data ---


    // These compute the bounding box in world space
    @(link_name="b2ComputeCircleAABB")
    compute_circle_aabb :: proc(shape: ^Circle, xf: Transform) -> AABB ---

    @(link_name="b2ComputeCapsuleAABB")
    compute_capsule_aabb :: proc(shape: ^Capsule, xf: Transform) -> AABB ---

    @(link_name="b2ComputePolygonAABB")
    compute_polygon_aabb :: proc(shape: ^Polygon, xf: Transform) -> AABB ---

    @(link_name="b2ComputeSegmentAABB")
    compute_segment_aabb :: proc(shape: ^Segment, xf: Transform) -> AABB ---


    // Test a point in local space
    @(link_name="b2PointInCircle")
    point_in_circle :: proc(point: Vec2, shape: ^Circle) -> bool ---

    @(link_name="b2PointInCapsule")
    point_in_capsule :: proc(point: Vec2, shape: ^Capsule) -> bool ---

    @(link_name="b2PointInPolygon")
    point_in_polygon :: proc(point: Vec2, shape: ^Polygon) -> bool ---


    // Ray cast versus shape in shape local space. Initial overlap is treated as a miss.
    @(link_name="b2RayCastCircle")
    ray_cast_circle :: proc(input: ^Ray_Cast_Input, shape: ^Circle) -> Ray_Cast_Output ---

    @(link_name="b2RayCastCapsule")
    ray_cast_capsule :: proc(input: ^Ray_Cast_Input, shape: ^Capsule) -> Ray_Cast_Output ---

    @(link_name="b2RayCastSegment")
    ray_cast_segment :: proc(input: ^Ray_Cast_Input, shape: ^Segment) -> Ray_Cast_Output ---

    @(link_name="b2RayCastPolygon")
    ray_cast_polygon :: proc(input: ^Ray_Cast_Input, shape: ^Polygon) -> Ray_Cast_Output ---


    @(link_name="b2ShapeCastCircle")
    shape_cast_circle :: proc(input: ^Shape_Cast_Input, shape: ^Circle) -> Ray_Cast_Output ---

    @(link_name="b2ShapeCastCapsule")
    shape_cast_capsule :: proc(input: ^Shape_Cast_Input, shape: ^Capsule) -> Ray_Cast_Output ---

    @(link_name="b2ShapeCastSegment")
    shape_cast_segment :: proc(input: ^Shape_Cast_Input, shape: ^Segment) -> Ray_Cast_Output ---

    @(link_name="b2ShapeCastPolygon")
    shape_cast_polygon :: proc(input: ^Shape_Cast_Input, shape: ^Polygon) -> Ray_Cast_Output ---


    /* joint_util.h */
    
    
    // Utility to compute linear stiffness values from frequency and damping ratio
    @(link_name="b2LinearStiffness")
    linear_stiffness :: proc(stiffness, damping: ^f32, frequency_hertz, damping_ratio: f32, body_a, body_b: Body_ID) ---
    
    // Utility to compute rotational stiffness values frequency and damping ratio
    @(link_name="b2AngularStiffness")
    angular_stiffness :: proc(stiffness, damping: ^f32, frequency_hertz, damping_ratio: f32, body_a, body_b: Body_ID) ---
}