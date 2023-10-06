package box2d

// 2D vector
Vec2 :: struct
{
	x, y: f32,
}

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
	maxFraction: f32,
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
Task_Callback :: #type proc "c" (startIndex, endIndex: i32, threadIndex: u32, taskContext: rawptr)

// These functions can be provided to Box2D to invoke a task system. These are designed to work well with enkiTS.
// Returns a pointer to the user's task object. May be nullptr.
Enqueue_Task_Callback :: #type proc "c" (task: Task_Callback, itemCount, minRange: i32, taskContext, userContext: rawptr) -> rawptr

// Finishes a user task object that wraps a Box2D task.
Finish_Task_Callback :: #type proc "c" (userTask, userContext: rawptr)

// Finishes all tasks.
Finish_All_Tasks_Callback :: #type proc "c" (userContext: rawptr)

World_Def :: struct
{
	// Gravity vector. Box2D has no up-vector defined.
	gravity: Vec2,

	// Restitution velocity threshold, usually in m/s. Collisions above this
	// speed have restitution applied (will bounce).
	restitutionThreshold: f32,

	// Can bodies go to sleep to improve performance
	enableSleep: bool,

	// Capacity for bodies. This may not be exceeded.
	bodyCapacity,

	// initial capacity for shapes
	shapeCapacity,

	// Capacity for contacts. This may not be exceeded.
	contactCapacity,

	// Capacity for joints
	jointCapacity,

	// Stack allocator capacity. This controls how much space box2d reserves for per-frame calculations.
	// Larger worlds require more space. b2Statistics can be used to determine a good capacity for your
	// application.
	stackAllocatorCapacity: i32,

	// task system hookup
	workerCount: u32,
	enqueueTask: Enqueue_Task_Callback,
	finishTask: Finish_Task_Callback,
	finishAllTasks: Finish_All_Tasks_Callback,
	userTaskContext: rawptr,

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
	linearVelocity: Vec2,

	// The angular velocity of the body.
	angularVelocity,

	// Linear damping is use to reduce the linear velocity. The damping parameter
	// can be larger than 1.0f but the damping effect becomes sensitive to the
	// time step when the damping parameter is large.
	linearDamping,

	// Angular damping is use to reduce the angular velocity. The damping parameter
	// can be larger than 1.0f but the damping effect becomes sensitive to the
	// time step when the damping parameter is large.
	angularDamping,

	// Scale the gravity applied to this body.
	gravityScale: f32,

	// Use this to store application specific body data.
	userData: rawptr,

	// Set this flag to false if this body should never fall asleep. Note that
	// this increases CPU usage.
	enableSleep,

	// Is this body initially awake or sleeping?
	isAwake,

	// Should this body be prevented from rotating? Useful for characters.
	fixedRotation,

	// Does this body start out enabled?
	isEnabled: bool
}

// This holds contact filtering data.
Filter :: struct
{
	// The collision category bits. Normally you would just set one bit.
	categoryBits,

	// The collision mask bits. This states the categories that this
	// shape would accept for collision.
	maskBits: u32,

	// Collision groups allow a certain group of objects to never collide (negative)
	// or always collide (positive). Zero means no collision group. Non-zero group
	// filtering always wins against the mask bits.
	groupIndex: i32,
}

// Used to create a shape
Shape_Def :: struct
{
	// Use this to store application specific shape data.
	userData: rawptr,

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
	isSensor: bool,

}

DEFAULT_FILTER :: Filter{0x00000001, 0xFFFFFFFF, 0}

// Make a world definition with default values.
DEFAULT_WORLD_DEF :: World_Def{
	Vec2{0, -10},
	1.0 * 1,
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

DEFAULT_SHAPE_DEF :: Shape_Def{
	nil,
	0.6,
	0,
	0,
	DEFAULT_FILTER,
	false,
}