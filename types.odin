package box2d

// 2D vector
Vec2 :: [2]f32

// 3D vector
Vec3 :: [3]f32

// 2D rotation
Rot :: struct
{
	// Sine and cosine
	s, c: f32,
}

// A 2D rigid transform
Transform :: struct
{
	p: Vec2,
	q: Rot,
}

// A 2-by-2 Matrix
Mat22 :: struct
{
	// columns
	cx, cy: Vec2,
}

// A 3-by-3 Matrix
Mat33 :: struct
{
	// columns
	cx, cy, cz: Vec3,
}

// Axis-aligned bounding box
AABB :: struct
{
	lower_bound,
	upper_bound: Vec2,
}

// Ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
Ray_Cast_Input :: struct
{
	p1, p2: Vec2,
	radius,
	max_fraction: f32,
}

Shape_Cast_Input :: struct
{
	points: [MAX_POLYGON_VERTICES]Vec2,
	count: i32,
	radius: f32,
	translation: Vec2,
	max_fraction: f32,
}

// Ray-cast output data. The ray hits at p1 + fraction * (p2 - p1), where p1 and p2 come from b2RayCastInput.
Ray_Cast_Output :: struct
{
	normal,
	point: Vec2,
	fraction: f32,
	iterations: i32,
	hit: bool,
}

// Task interface
// This is prototype for a Box2D task. Your task system is expected to invoke the Box2D task with these arguments.
// The task spans a range of the parallel-for: [startIndex, endIndex)
// The thread index must correctly identify each thread in the user thread pool, expected in [0, workerCount)
// The task context is the context pointer sent from Box2D when it is enqueued.
Task_Callback :: #type proc "c" (start_index, end_index: i32, thread_index: u32, task_context: rawptr)

// These functions can be provided to Box2D to invoke a task system. These are designed to work well with enkiTS.
// Returns a pointer to the user's task object. May be nullptr.
Enqueue_Task_Callback :: #type proc "c" (task: Task_Callback, item_count, min_range: i32, task_context, user_context: rawptr) -> rawptr

// Finishes a user task object that wraps a Box2D task.
Finish_Task_Callback :: #type proc "c" (user_task, user_context: rawptr)

// Finishes all tasks.
Finish_All_Tasks_Callback :: #type proc "c" (user_context: rawptr)

World_Def :: struct
{
	// Gravity vector. Box2D has no up-vector defined.
	gravity: Vec2,

	// Restitution velocity threshold, usually in m/s. Collisions above this
	// speed have restitution applied (will bounce).
	restitution_threshold: f32,

	// This parameter controls how fast overlap is resolved and has units of meters per second
	contact_pushout_velocity: f32,

	// Contact stiffness. Cycles per second.
	contact_hertz: f32,

	/// Contact bounciness. Non-dimensional.
	contact_damping_ratio: f32,

	// Can bodies go to sleep to improve performance
	enable_sleep: bool,

	// Capacity for bodies. This may not be exceeded.
	body_capacity,

	// initial capacity for shapes
	shape_capacity,

	// Capacity for contacts. This may not be exceeded.
	contact_capacity,

	// Capacity for joints
	joint_capacity,

	// Stack allocator capacity. This controls how much space box2d reserves for per-frame calculations.
	// Larger worlds require more space. b2Statistics can be used to determine a good capacity for your
	// application.
	stack_allocator_capacity: i32,

	// task system hookup
	worker_count: u32,
	enqueue_task: Enqueue_Task_Callback,
	finish_task: Finish_Task_Callback,
	finish_all_tasks: Finish_All_Tasks_Callback,
	user_task_context: rawptr,
}

// The body type.
// static: zero mass, zero velocity, may be manually moved
// kinematic: zero mass, non-zero velocity set by user, moved by solver
// dynamic: positive mass, non-zero velocity determined by forces, moved by solver
Body_Type :: enum u32
{
	Static = 0,
	Kinematic = 1,
	Dynamic = 2,
}

// A body definition holds all the data needed to construct a rigid body.
// You can safely re-use body definitions. Shapes are added to a body after construction.
Body_Def :: struct
{
	// The body type: static, kinematic, or dynamic.
	// Note: if a dynamic body would have zero mass, the mass is set to one.
	type: Body_Type,

	// The world position of the body. Avoid creating bodies at the origin
	// since this can lead to many overlapping shapes.
	position: Vec2,

	// The world angle of the body in radians.
	angle: f32,

	// The linear velocity of the body's origin in world co-ordinates.
	linear_velocity: Vec2,

	// The angular velocity of the body.
	angular_velocity,

	// Linear damping is use to reduce the linear velocity. The damping parameter
	// can be larger than 1.0f but the damping effect becomes sensitive to the
	// time step when the damping parameter is large.
	linear_damping,

	// Angular damping is use to reduce the angular velocity. The damping parameter
	// can be larger than 1.0f but the damping effect becomes sensitive to the
	// time step when the damping parameter is large.
	angular_damping,

	// Scale the gravity applied to this body.
	gravity_scale: f32,

	// Use this to store application specific body data.
	user_data: rawptr,

	// Set this flag to false if this body should never fall asleep. Note that
	// this increases CPU usage.
	enable_sleep,

	// Is this body initially awake or sleeping?
	is_awake,

	// Should this body be prevented from rotating? Useful for characters.
	fixed_rotation,

	// Does this body start out enabled?
	is_enabled: bool
}

// This holds contact filtering data.
Filter :: struct
{
	// The collision category bits. Normally you would just set one bit.
	category_bits,

	// The collision mask bits. This states the categories that this
	// shape would accept for collision.
	mask_bits: u32,

	// Collision groups allow a certain group of objects to never collide (negative)
	// or always collide (positive). Zero means no collision group. Non-zero group
	// filtering always wins against the mask bits.
	group_index: i32,
}

// This holds contact filtering data.
Query_Filter :: struct
{
	// The collision category bits. Normally you would just set one bit.
	category_bits,

	// The collision mask bits. This states the categories that this
	// shape would accept for collision.
	mask_bits: u32,
}

DEFAULT_QUERY_FILTER :: Query_Filter{0x00000001, 0xFFFFFFFF};

// Used to create a shape
Shape_Def :: struct
{
	// Use this to store application specific shape data.
	user_data: rawptr,

	// The friction coefficient, usually in the range [0,1].
	friction,

	// The restitution (elasticity) usually in the range [0,1].
	restitution,

	// The density, usually in kg/m^2.
	density: f32,

	// Contact filtering data.
	filter: Filter,

	// A sensor shape collects contact information but never generates a collision
	// response.
	is_sensor: bool,

}

DEFAULT_FILTER :: Filter{0x00000001, 0xFFFFFFFF, 0}

// Used to create a chain of edges. This is designed to eliminate ghost collisions with some limitations.
// - DO NOT use chain shapes unless you understand the limitations. This is an advanced feature!
// - chains are one-sided
// - chains have no mass and should be used on static bodies
// - the front side of the chain points the right of the point sequence
// - chains are either a loop or open
// - a chain must have at least 4 points
// - the distance between any two points must be greater than b2_linearSlop
// - a chain shape should not self intersect (this is not validated)
// - an open chain shape has NO COLLISION on the first and final edge
// - you may overlap two open chains on their first three and/or last three points to get smooth collision
// - a chain shape creates multiple hidden shapes on the body
Chain_Def :: struct
{
	// An array of at least 4 points. These are cloned and may be temporary.
	points: [^]Vec2,

	// The point count, must be 4 or more.
	count: u32,

	// Indicates a closed chain formed by connecting the first and last points
	loop: bool,

	// Use this to store application specific shape data.
	user_data: rawptr,

	// The friction coefficient, usually in the range [0,1].
	friction,

	// The restitution (elasticity) usually in the range [0,1].
	restitution: f32,

	// Contact filtering data.
	filter: Filter,
}

// Make a world definition with default values.
DEFAULT_WORLD_DEF :: World_Def{
	{0, -10},
	1.0 * 1,
	3.0 * 1,
	30.0,
	1.0,
	true,
	8,
	8,
	8,
	8,
	1024 * 1024,
	0,
	nil,
	nil,
	nil,
	nil,
}

// Make a body definition with default values.
DEFAULT_BODY_DEF :: Body_Def{
	.Static,
	{0, 0},
	0,
	{0, 0},
	0,
	0,
	0,
	1,
	nil,
	true,
	true,
	false,
	true,
}

DEFAULT_SHAPE_DEF :: Shape_Def {
	nil,
	0.6,
	0,
	0,
	DEFAULT_FILTER,
	false,
}

DEFAULT_CHAIN_DEF :: Chain_Def {
	nil,
	0,
	false,
	nil,
	0.6,
	0.0,
	DEFAULT_FILTER,
}