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