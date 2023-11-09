package box2d

Alloc_Fcn :: #type proc "c" (size: u32) -> rawptr
Free_Fcn :: #type proc "c" (mem: rawptr)

// Return 0 to
Assert_Fcn :: #type proc "c" (condition, file_name: cstring, line_number: u32) -> u32

// /// Default allocation functions
//TODO: void b2SetAllocator(b2AllocFcn* allocFcn, b2FreeFcn* freeFcn);

// /// Total bytes allocated by Box2D
//TODO: int b2GetByteCount(void);


// Export 'Box2DAssertCallback' symbol
@(export, link_name="Box2DAssertCallback")
box2d_assert_callback: Assert_Fcn