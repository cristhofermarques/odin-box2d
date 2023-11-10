package box2d

// Distance joint definition. This requires defining an anchor point on both
// bodies and the non-zero distance of the distance joint. The definition uses
// local anchor points so that the initial configuration can violate the
// constraint slightly. This helps when saving and loading a game.
Distance_Joint_Def :: struct
{
	// The first attached body.
	body_id_a: Body_ID,

	// The second attached body.
	body_id_b: Body_ID,

	// The local anchor point relative to bodyA's origin.
	local_anchor_a: Vec2,

	// The local anchor point relative to bodyB's origin.
	local_anchor_b: Vec2,

	// The rest length of this joint. Clamped to a stable minimum value.
	length: f32,

	// Minimum length. Clamped to a stable minimum value.
	min_length: f32,

	// Maximum length. Must be greater than or equal to the minimum length.
	max_length: f32,

	/// The linear stiffness hertz (cycles per second)
	hertz: f32,

	// The linear damping ratio (non-dimensional)
	damping_ratio: f32,

	// Set this flag to true if the attached bodies should collide.
	collide_connected: bool,

}

DEFAULT_DISTANCE_JOINT_DEF :: Distance_Joint_Def {
	NULL_BODY_ID,
	NULL_BODY_ID,
	{0, 0},
	{0, 0},
	1,
	0,
	HUGE,
	0,
	0,
	false,
}

// A mouse joint is used to make a point on a body track a
// specified world point. This a soft constraint with a maximum
// force. This allows the constraint to stretch without
// applying huge forces.
// NOTE: this joint is not documented in the manual because it was
// developed to be used in samples. If you want to learn how to
// use the mouse joint, look at the samples app.
Mouse_Joint_Def :: struct
{
	// The first attached body.
	body_id_a,

	// The second attached body.
	body_id_b: Body_ID,

	// The initial target point in world space
	target: Vec2,

	// The maximum constraint force that can be exerted
	// to move the candidate body. Usually you will express
	// as some multiple of the weight (multiplier * mass * gravity).
	max_force,

	// The linear stiffness in N/m
	stiffness,

	// The linear damping in N*s/m
	damping: f32,
}

DEFAULT_MOUSE_JOINT_DEF :: Mouse_Joint_Def{
	NULL_BODY_ID,
	NULL_BODY_ID,
	{0, 0},
	0,
	0,
	0,
}

/// Prismatic joint definition. This requires defining a line of
/// motion using an axis and an anchor point. The definition uses local
/// anchor points and a local axis so that the initial configuration
/// can violate the constraint slightly. The joint translation is zero
/// when the local anchor points coincide in world space.
Prismatic_Joint_Def :: struct
{
	// The first attached body.
	body_id_a: Body_ID,

	// The second attached body.
	body_id_b: Body_ID,

	/// The local anchor point relative to bodyA's origin.
	local_anchor_a: Vec2,

	// The local anchor point relative to bodyB's origin.
	local_anchor_b: Vec2,

	// The local translation unit axis in bodyA.
	local_axis_a: Vec2,

	// The constrained angle between the bodies: bodyB_angle - bodyA_angle.
	reference_angle: f32,

	// Enable/disable the joint limit.
	enable_limit: bool,

	// The lower translation limit, usually in meters.
	lower_translation: f32,

	// The upper translation limit, usually in meters.
	upper_translation: f32,

	// Enable/disable the joint motor.
	enable_motor: bool,

	// The maximum motor torque, usually in N-m.
	max_motor_force: f32,

	// The desired motor speed in radians per second.
	motor_speed: f32,

	// Set this flag to true if the attached bodies should collide.
	collide_connected: bool,
}

DEFAULT_PRISMATIC_JOINT_DEF :: Prismatic_Joint_Def{
	NULL_BODY_ID,
	NULL_BODY_ID,
	{0, 0},
	{0, 0},
	{0, 0},
	0,
	false,
	0,
	0,
	false,
	0,
	0,
	false,
}

// Revolute joint definition. This requires defining an anchor point where the
// bodies are joined. The definition uses local anchor points so that the
// initial configuration can violate the constraint slightly. You also need to
// specify the initial relative angle for joint limits. This helps when saving
// and loading a game.
// The local anchor points are measured from the body's origin
// rather than the center of mass because:
// 1. you might not know where the center of mass will be.
// 2. if you add/remove shapes from a body and recompute the mass,
//    the joints will be broken.
Revolute_Joint_Def :: struct
{
	// The first attached body.
	body_id_a,

	// The second attached body.
	body_id_b: Body_ID,

	// The local anchor point relative to bodyA's origin.
	local_anchor_a,

	// The local anchor point relative to bodyB's origin.
	local_anchor_b: Vec2,

	// The bodyB angle minus bodyA angle in the reference state (radians).
	// This defines the zero angle for the joint limit.
	reference_angle: f32,

	// A flag to enable joint limits.
	enable_limit: bool,

	// The lower angle for the joint limit (radians).
	lower_angle,

	// The upper angle for the joint limit (radians).
	upper_angle: f32,

	// A flag to enable the joint motor.
	enable_motor: bool,

	// The desired motor speed. Usually in radians per second.
	motor_speed,

	// The maximum motor torque used to achieve the desired motor speed.
	// Usually in N-m.
	max_motor_torque: f32,

	// Set this flag to true if the attached bodies should collide.
	collide_connected: bool,
}

DEFAULT_REVOLUTE_JOINT_DEF :: Revolute_Joint_Def{
	NULL_BODY_ID,
	NULL_BODY_ID,
    {0, 0},
    {0, 0},
	0,
    false,
	0,
	0,
    false,
	0,
	0,
	false,
}

Weld_Joint_Def :: struct
{
	// The first attached body.
	body_id_a: Body_ID,

	// The second attached body.
	body_id_b: Body_ID,

	// The local anchor point relative to bodyA's origin.
	local_anchor_a: Vec2,

	// The local anchor point relative to bodyB's origin.
	local_anchor_b: Vec2,

	// The bodyB angle minus bodyA angle in the reference state (radians).
	// This defines the zero angle for the joint limit.
	reference_angle: f32,

	// Stiffness expressed as hertz (oscillations per second). Use zero for maximum stiffness.
	linear_hertz: f32,
	angular_hertz: f32,

	// Damping ratio, non-dimensional. Use 1 for critical damping.
	linear_damping_ratio: f32,
	angular_damping_ratio: f32,

	// Set this flag to true if the attached bodies should collide.
	collide_connected: bool,
}

// Use this to initialize your joint definition
DEFAULT_WELD_JOINT_DEF :: Weld_Joint_Def{
	NULL_BODY_ID,
	NULL_BODY_ID,
	{0, 0},
	{0, 0},
	0,
	0,
	0,
	1,
	1,
	false,
}
