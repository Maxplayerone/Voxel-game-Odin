package main
import glm "core:math/linalg/glsl"

Vertex :: struct {
	pos: glm.vec3,
	col: glm.vec4,
}

block_size :: 1.0
	
generate_block_mesh :: proc(pos: glm.vec3, color: glm.vec3, block_num: u16) -> ([24]Vertex, [36]u16){
	vertices := [24]Vertex{
		//front face
		{{pos.x, pos.y + block_size, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y + block_size, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		//back face
		{{pos.x + block_size, pos.y + block_size, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y + block_size, pos.z}, {color.x, color.y, color.z, 1.0}},
		//right face
		{{pos.x + block_size, pos.y + block_size, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y + block_size, pos.z}, {color.x, color.y, color.z, 1.0}},
		//left face
		{{pos.x, pos.y + block_size, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y + block_size, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		//top face
		{{pos.x, pos.y + block_size, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y + block_size, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y + block_size, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y + block_size, pos.z}, {color.x, color.y, color.z, 1.0}},
		//bottom face
		{{pos.x, pos.y, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
		{{pos.x, pos.y, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y, pos.z}, {color.x, color.y, color.z, 1.0}},
		{{pos.x + block_size, pos.y, pos.z + block_size}, {color.x, color.y, color.z, 1.0}},
	}
    
	i := 24 * block_num
	indices := [36]u16{
		i, i + 1, i + 2,
		i + 2, i + 3, i,

		i + 4, i + 5, i + 6,
		i + 6, i + 7, i + 4,

		i + 8, i + 9, i + 10,
		i + 10, i + 11, i + 8,

		i + 12, i + 13, i + 14,
		i + 14, i + 15, i + 12,

		i + 16, i + 17, i + 18,
		i + 18, i + 19, i + 16,

		i + 20, i + 21, i + 22,
		i + 22, i + 23, i + 20,
	}

    return vertices, indices
}