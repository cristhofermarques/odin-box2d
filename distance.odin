package box2d

Segment_Distance_Result :: struct
{
	closest1,
	closest2: Vec2,
	fraction1,
	fraction2,
	distance_squared: f32,
}

// Compute the distance between two line segments, clamping at the end points if needed.
//b2SegmentDistanceResult b2SegmentDistance(b2Vec2 p1, b2Vec2 q1, b2Vec2 p2, b2Vec2 q2); TODO

// A distance proxy is used by the GJK algorithm.
// It encapsulates any shape.
Distance_Proxy :: struct
{
	vertices: [MAX_POLYGON_VERTICES]Vec2,
	count: i32,
	radius: f32,
}

// Used to warm start b2Distance.
// Set count to zero on first call.
Distance_Cache :: struct
{
	metric: f32, ///< length or area
	count: u16,
	index_a: [3]u8, ///< vertices on shape A
	index_b: [3]u8, ///< vertices on shape B
}

EMPTY_DISTANCE_CACHE :: Distance_Cache{}

// Input for b2Distance.
// You have to option to use the shape radii
// in the computation. Even
DistanceInput :: struct
{
	proxy_a,
	proxy_b: Distance_Proxy,
	transform_a,
	transform_b: Transform,
	use_radii: bool,
}

// Output for b2Distance.
Distance_Output :: struct
{
	point_a, ///< closest point on shapeA
	point_b: Vec2, ///< closest point on shapeB
	distance: f32,
	iterations: i32 ///< number of GJK iterations used
}

// Compute the closest points between two shapes. Supports any combination of:
// b2Circle, b2Polygon, b2EdgeShape. The simplex cache is input/output.
// On the first call set b2SimplexCache.count to zero.
//TODO: b2DistanceOutput b2ShapeDistance(b2DistanceCache* cache, const b2DistanceInput* input);

// Input parameters for b2ShapeCast
Shape_Cast_Input :: struct
{
	proxy_a,
	proxy_b: Distance_Proxy,
	transform_a,
	transform_b: Transform,
	translation_b: Vec2,
	max_fraction: f32,
}

// Perform a linear shape cast of shape B moving and shape A fixed. Determines the hit point, normal, and translation fraction.
// @returns true if hit, false if there is no hit or an initial overlap
//TODO: b2RayCastOutput b2ShapeCast(const b2ShapeCastInput* input);

//TODO: b2DistanceProxy b2MakeProxy(const b2Vec2* vertices, int32_t count, float radius);

// This describes the motion of a body/shape for TOI computation. Shapes are defined with respect to the body origin,
// which may not coincide with the center of mass. However, to support dynamics we must interpolate the center of mass
// position.
Sweep :: struct
{
	// local center of mass position
	local_center,

	// center world positions
	c1, c2: Vec2,

	// world angles
	a1, a2: f32,
}

//TODO: b2Transform b2GetSweepTransform(const b2Sweep* sweep, float time);

// Input parameters for b2TimeOfImpact
TOI_Input :: struct
{
	proxy_a,
	proxy_b: Distance_Proxy,
	sweep_a,
	sweep_b: Sweep,

	// defines sweep interval [0, tMax]
	t_max: f32
}

TOI_State :: enum
{
	Unknown,
	Failed,
	Overlapped,
	Hit,
	Separated
}

// Output parameters for b2TimeOfImpact.
TOI_Output :: struct
{
	state: TOI_State,
	t: f32,
}

// Compute the upper bound on time before two shapes penetrate. Time is represented as
// a fraction between [0,tMax]. This uses a swept separating axis and may miss some intermediate,
// non-tunneling collisions. If you change the time interval, you should call this function
// again.
//TODO: b2TOIOutput b2TimeOfImpact(const b2TOIInput* input);