package box2d

NULL_FEATURE :: max(u8)
MAX_MANIFOLD_POINTS :: 2

make_id :: #force_inline proc "contextless" (a, b: $T) -> u16
{
    return (u8(a) << 8 | u8(b))
}

// A manifold point is a contact point belonging to a contact
// manifold. It holds details related to the geometry and dynamics
// of the contact points.
Manifold_Point :: struct
{
	// world coordinates of contact point
	point: Vec2,

	// the separation of the contact point, negative if penetrating
	separation,

	// the non-penetration impulse
	normal_impulse,

	// the friction impulse
	tangent_impulse: f32,

	// uniquely identifies a contact point between two shapes
	id: u16,

	// did this contact point exist the previous step?
	persisted: bool,
}

// Conact manifold convex shapes.
Manifold :: struct
{
	points :[MAX_MANIFOLD_POINTS]Manifold_Point,
	normal: Vec2,
	point_count: i32,
}

EMPTY_MANIFOLD :: Manifold{}