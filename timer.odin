package box2d

/// Profiling data. Times are in milliseconds.
/// TODO_ERIN change to ticks due to variable frequency
Profile :: struct
{
	step,
	pairs,
	collide,
	solve,
	build_islands,
	solve_islands,
	broadphase,
	continuous: f32,
}

EMPTY_PROFILE :: Profile{}

Statistics :: struct
{
	island_count,
	body_count,
	contact_count,
	joint_count,
	proxy_count,
	tree_height,
	stack_capacity,
	stack_used,
	byte_count: i32,
	colors_count: [GRAPH_COLORS_COUNT + 1]i32,
}

when ODIN_OS == .Windows
{
    /// Timer for profiling. This has platform specific code and may
    /// not work on every platform.
    Timer :: struct
    {
        start: i64,
    }
}

when ODIN_OS == .Linux
{
    /// Timer for profiling. This has platform specific code and may
    /// not work on every platform.
    Timer :: struct
    {
        start_sec,
        start_usec: u64,
    }
}