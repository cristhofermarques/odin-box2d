package box2d

DEFAULT_CATEGORY_BITS ::  0x00000001
DEFAULT_MASK_BITS ::  0xFFFFFFFF

// A node in the dynamic tree. The client does not interact with this directly.
// 16 + 16 + 8 + pad(8)
Tree_Node :: struct
{
	aabb: AABB, // 16

	// Category bits for collision filtering
	category_bits: u32, // 4

    parent_or_next: struct #raw_union 
	{
		parent, next: i32,
	}, // 4

	child1, // 4
	child2: i32, // 4

	// TODO_ERIN could be union with child index
	user_data: i32, // 4

	// leaf = 0, free node = -1
	height: i16, // 2

	enlarged: bool, // 1

	pad: [9]u8,
}

// A dynamic AABB tree broad-phase, inspired by Nathanael Presson's btDbvt.
// A dynamic tree arranges data in a binary tree to accelerate
// queries such as volume queries and ray casts. Leaf nodes are proxies
// with an AABB. These are used to hold a user collision object, such as a reference to a Shape.
//
// Nodes are pooled and relocatable, so I use node indices rather than pointers.
Dynamic_Tree :: struct
{
	nodes: ^Tree_Node,

	root,
	node_count,
	node_capacity,
	free_list,
	proxy_count: i32,

	leaf_indices: ^i32,
	leaf_boxes: ^AABB,
	leaf_centers: ^Vec2,
	bin_indices: ^i32,
	rebuild_capacity: i32,
}