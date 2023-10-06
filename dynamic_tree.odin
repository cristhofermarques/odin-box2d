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

    parent_or_next: i32, // 4

	child1, // 4
	child2: i32, // 4

	// TODO_ERIN could be union with child index
	user_data: i32, // 4

	// leaf = 0, free node = -1
	height: i16, // 2

	enlarged: bool, // 1

	pad: [9]u8,
}

/// A dynamic AABB tree broad-phase, inspired by Nathanael Presson's btDbvt.
/// A dynamic tree arranges data in a binary tree to accelerate
/// queries such as volume queries and ray casts. Leaf nodes are proxies
/// with an AABB. These are used to hold a user collision object, such as a reference to a Shape.
///
/// Nodes are pooled and relocatable, so I use node indices rather than pointers.
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

// /// Constructing the tree initializes the node pool.
// DynamicTree DynamicTree_Create(void);

// /// Destroy the tree, freeing the node pool.
// void DynamicTree_Destroy(DynamicTree* tree);

// /// Create a proxy. Provide a tight fitting AABB and a userData value.
// int32_t DynamicTree_CreateProxy(DynamicTree* tree, AABB aabb, uint32_t categoryBits, int32_t userData);

// /// Destroy a proxy. This asserts if the id is invalid.
// void DynamicTree_DestroyProxy(DynamicTree* tree, int32_t proxyId);

// // Clone one tree to another, reusing storage in the outTree if possible
// void DynamicTree_Clone(DynamicTree* outTree, const DynamicTree* inTree);

// /// Move a proxy to a new AABB by removing and reinserting into the tree.
// void DynamicTree_MoveProxy(DynamicTree* tree, int32_t proxyId, AABB aabb);

// /// Enlarge a proxy and enlarge ancestors as necessary.
// void DynamicTree_EnlargeProxy(DynamicTree* tree, int32_t proxyId, AABB aabb);

// /// This function receives proxies found in the AABB query.
// /// @return true if the query should continue
// typedef bool TreeQueryCallbackFcn(int32_t proxyId, int32_t userData, void* context);

// /// Query an AABB for overlapping proxies. The callback class
// /// is called for each proxy that overlaps the supplied AABB.
// void DynamicTree_QueryFiltered(const DynamicTree* tree, AABB aabb, uint32_t maskBits, TreeQueryCallbackFcn* callback,
// 								 void* context);

// /// Query an AABB for overlapping proxies. The callback class
// /// is called for each proxy that overlaps the supplied AABB.
// void DynamicTree_Query(const DynamicTree* tree, AABB aabb, TreeQueryCallbackFcn* callback, void* context);

// /// This function receives clipped raycast input for a proxy. The function
// /// returns the new ray fraction.
// /// - return a value of 0 to terminate the ray cast
// /// - return a value less than input->maxFraction to clip the ray
// /// - return a value of input->maxFraction to continue the ray cast without clipping
// typedef float TreeRayCastCallbackFcn(const RayCastInput* input, int32_t proxyId, int32_t userData, void* context);

// /// Ray-cast against the proxies in the tree. This relies on the callback
// /// to perform a exact ray-cast in the case were the proxy contains a shape.
// /// The callback also performs the any collision filtering. This has performance
// /// roughly equal to k * log(n), where k is the number of collisions and n is the
// /// number of proxies in the tree.
// /// @param input the ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
// /// @param callback a callback class that is called for each proxy that is hit by the ray.
// void DynamicTree_RayCast(const DynamicTree* tree, const RayCastInput* input, uint32_t maskBits, TreeRayCastCallbackFcn* callback,
// 						   void* context);

// /// Validate this tree. For testing.
// void DynamicTree_Validate(const DynamicTree* tree);

// /// Compute the height of the binary tree in O(N) time. Should not be
// /// called often.
// int32_t DynamicTree_GetHeight(const DynamicTree* tree);

// /// Get the maximum balance of the tree. The balance is the difference in height of the two children of a node.
// int32_t DynamicTree_GetMaxBalance(const DynamicTree* tree);

// /// Get the ratio of the sum of the node areas to the root area.
// float DynamicTree_GetAreaRatio(const DynamicTree* tree);

// /// Build an optimal tree. Very expensive. For testing.
// void DynamicTree_RebuildBottomUp(DynamicTree* tree);

// /// Get the number of proxies created
// int32_t DynamicTree_GetProxyCount(const DynamicTree* tree);

// /// Rebuild the tree while retaining subtrees that haven't changed. Returns the number of boxes sorted.
// int32_t DynamicTree_Rebuild(DynamicTree* tree, bool fullBuild);

// /// Shift the world origin. Useful for large worlds.
// /// The shift formula is: position -= newOrigin
// /// @param newOrigin the new origin with respect to the old origin
// void DynamicTree_ShiftOrigin(DynamicTree* tree, Vec2 newOrigin);

// /// Get proxy user data.
// /// @return the proxy user data or 0 if the id is invalid.
// static inline int32_t DynamicTree_GetUserData(const DynamicTree* tree, int32_t proxyId)
// {
// 	return tree->nodes[proxyId].userData;
// }

// static inline AABB DynamicTree_GetAABB(const DynamicTree* tree, int32_t proxyId)
// {
// 	return tree->nodes[proxyId].aabb;
// }

// static inline uint32_t DynamicTree_GetCategoryBits(const DynamicTree* tree, int32_t proxyId)
// {
// 	return tree->nodes[proxyId].categoryBits;
// }