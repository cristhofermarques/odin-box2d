package box2d

// This holds the mass data computed for a shape.
Mass_Data :: struct
{
	// The mass of the shape, usually in kilograms.
	mass: f32,

	// The position of the shape's centroid relative to the shape's origin.
	center: Vec2,

	// The rotational inertia of the shape about the local origin.
	i: f32,

	// Distance from shape centroid to closest point on perimeter.
	min_extent,

	// Distance from shape origin to furthest point on perimeter.
	max_extent: f32,
}

// A solid circle
Circle :: struct
{
	point: Vec2,
	radius: f32,
}

// A solid capsule
Capsule :: struct
{
	point1, point2: Vec2,
	radius: f32,
}

// A solid convex polygon. It is assumed that the interior of the polygon is to
// the left of each edge.
// Polygons have a maximum number of vertices equal to _maxPolygonVertices.
// In most cases you should not need many vertices for a convex polygon.
Polygon :: struct
{
	vertices: [MAX_POLYGON_VERTICES]Vec2,
	normals: [MAX_POLYGON_VERTICES]Vec2,
	centroid: Vec2,
	radius: f32,
	count: i32,
}

// A line segment with two-sided collision.
Segment :: struct
{
	point1, point2: Vec2
}

// A smooth line segment with one-sided collision. Only collides on the right side.
// Normally these are generated from a chain shape.
// ghost1 -> point1 -> point2 -> ghost2
// This is only relevant for contact manifolds, otherwise use a regular segment.
Smooth_Segment :: struct
{
	// The tail ghost vertex
	ghost1,

	// The line segment
	point1, point2,

	// The head ghost vertex
	ghost2: Vec2
}