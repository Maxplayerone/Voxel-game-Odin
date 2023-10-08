package main
import glm "core:math/linalg/glsl"

Vertex :: struct {
	pos: glm.vec3,
	col: glm.vec4,
}

block_size :: 1.0
	
generate_block_mesh :: proc(pos: glm.vec3, color: glm.vec3) -> ([dynamic]Vertex, [dynamic]u16){
	vertices_slice := []Vertex{
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
    
	indices_slice := []u16{
		0, 1, 2,
		2, 3, 0,

		4, 5, 6,
		6, 7, 4,

		8, 9, 10,
		10, 11, 8,

		12, 13, 14,
		14, 15, 12,

		16, 17, 18,
		18, 19, 16,

		20, 21, 22,
		22, 23, 20,
	}
    vertices : [dynamic]Vertex
    append(&vertices, ..vertices_slice[:])

    indices: [dynamic]u16
    append(&indices, ..indices_slice[:])

    return vertices, indices
}