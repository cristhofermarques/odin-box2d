package box2d

/// A begin touch event is generated when a shape starts to overlap a sensor shape.
Sensor_Begin_Touch_Event :: struct
{
	sensor_shape_id,
	visitor_shape_id: Shape_ID,
}

/// An end touch event is generated when a shape stops overlapping a sensor shape.
Sensor_End_Touch_Event :: struct
{
	sensor_shape_id,
	visitor_shape_id: Shape_ID,
}

/// Sensor events are buffered in the Box2D world and are available
///	as begin/end overlap event arrays after the time step is complete.
Sensor_Events :: struct
{
	begin_events: [^]Sensor_Begin_Touch_Event,
	end_events: [^]Sensor_End_Touch_Event,
	begin_count,
	end_count: i32,
}