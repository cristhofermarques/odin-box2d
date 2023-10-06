package box2d

Hull :: struct
{
	points: [MAX_POLYGON_VERTICES]Vec2,
	count: i32,
}

// Compute the convex hull of a set of points. Returns an empty hull if it fails.
// Some failure cases:
// - all points very close together
// - all points on a line
// - less than 3 points
// - more than b2_maxPolygonVertices points
// This welds close points and removes collinear points.
//TODO: b2Hull b2ComputeHull(const b2Vec2* points, int32_t count);

// This determines if a hull is valid. Checks for:
// - convexity
// - collinear points
// This is expensive and should not be called at runtime.
//TODO: bool b2ValidateHull(const b2Hull* hull);