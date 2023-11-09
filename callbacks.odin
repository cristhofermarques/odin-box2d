package box2d

//typedef struct b2ContactImpulse b2ContactImpulse;

// Joints and shapes are destroyed when their associated
// body is destroyed. Implement this listener so that you
// may nullify references to these joints and shapes.
Joint_Destroyed_Fcn :: #type proc "c" (joint_id: Joint_ID, context_: rawptr)
Shape_Destroyed_Fcn :: #type proc "c" (shape_id: Shape_ID, context_: rawptr)

// Implement this class to provide collision filtering. In other words, you can implement
// this class if you want finer control over contact creation.
// Return true if contact calculations should be performed between these two shapes.
// @warning for performance reasons this is only called when the AABBs begin to overlap.
Should_Collide_Fcn :: #type proc "c" (shape_id_a, shape_id_b: Shape_ID, context_: rawptr) -> bool

// Implement these callbacks to get contact information. You can use these results for
// things like sounds and game logic. You can also get contact results by
// traversing the contact lists after the time step. However, you might miss
// some contacts because continuous physics leads to sub-stepping.
// Additionally you may receive multiple callbacks for the same contact in a
// single time step.
// You should strive to make your callbacks efficient because there may be
// many callbacks per time step.
// @warning You cannot create/destroy Box2D entities inside these callbacks.
// Called when two shapes begin to touch.
Begin_Contact_Fcn :: #type proc "c" (shape_id_a, shape_id_b: Shape_ID, context_: rawptr)

// Called when two shapes cease to touch.
End_Contact_Fcn :: #type proc "c" (shape_id_a, shape_id_b: Shape_ID, context_: rawptr)

// This is called after a contact is updated. This allows you to inspect a
// contact before it goes to the solver. If you are careful, you can modify the
// contact manifold (e.g. disable contact).
// Notes:
// - this is called only for awake bodies.
// - this is called even when the number of contact points is zero.
// - this is not called for sensors.
// - if you set the number of contact points to zero, you will not
// get an EndContact callback. However, you may get a BeginContact callback
// the next step.
// - the supplied manifold has impulse values from the previous frame
Pre_Solve_Fcn :: #type proc "c" (shape_id_a, shape_id_b: Shape_ID, manifold: ^Manifold, context_: rawptr) -> bool
world_set_pre_solve_callback :: proc "c" (world_id: World_ID, fcn: Pre_Solve_Fcn, context_: rawptr)

// This lets you inspect a contact after the solver is finished. This is useful
// for inspecting impulses.
// Note: the contact manifold does not include time of impact impulses, which can be
// arbitrarily large if the sub-step is small. Hence the impulse is provided explicitly
// in a separate data structure.
// Note: this is only called for contacts that are touching, solid, and awake.
Post_Solve_Fcn :: #type proc "c" (shape_id_a, shape_id_b: Shape_ID, manifold: ^Manifold, context_: rawptr)
world_set_post_solve_callback :: proc "c" (world_id: World_ID, fcn: Post_Solve_Fcn, context_: rawptr)

World_Callbacks :: struct
{
	joint_destroyed_fcn: Joint_Destroyed_Fcn,
	shape_destroyed_fcn: Shape_Destroyed_Fcn,
	should_collide_fcn: Should_Collide_Fcn,
	begin_contact_fcn: Begin_Contact_Fcn,
	end_contact_fcn: End_Contact_Fcn,
	pre_solve_fcn: Pre_Solve_Fcn,
	post_solve_fcn: Post_Solve_Fcn,
}

// Callback class for AABB queries.
// See b2World_Query
// Called for each shape found in the query AABB.
// @return false to terminate the query.
Query_Result_Fcn :: #type proc "c" (shape_id: Shape_ID) -> bool

// Callback class for ray casts.
// See b2World::RayCast
// Called for each shape found in the query. You control how the ray cast
// proceeds by returning a float:
// return -1: ignore this shape and continue
// return 0: terminate the ray cast
// return fraction: clip the ray to this point
// return 1: don't clip the ray and continue
// @param shape the shape hit by the ray
// @param point the point of initial intersection
// @param normal the normal vector at the point of intersection
// @param fraction the fraction along the ray at the point of intersection
// @return -1 to filter, 0 to terminate, fraction to clip the ray for
// closest hit, 1 to continue
Ray_Result_Fcn :: #type proc "c" (shape: Shape_ID, point, normal: Vec2, fraction: f32) -> f32