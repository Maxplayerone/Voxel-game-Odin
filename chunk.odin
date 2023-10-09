package main

import "core:fmt"

import gl "vendor:openGL"
import glm "core:math/linalg/glsl"

vertex_source := `#version 330 core
layout(location=0) in vec3 aPos;
layout(location=1) in vec4 aColor;

uniform mat4 mvp;

out vec4 fColor;

void main(){
    fColor = aColor;
    gl_Position = mvp * vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
`

fragment_source : = `#version 330 core
out vec4 FragColor;

in vec4 fColor;

void main(){
    FragColor = fColor;
}
`

Chunk :: struct{
    vbo: u32,
    ebo: u32,
    vao: u32,
    program: u32,
    vertices: [dynamic]Vertex,
	indices: [dynamic]u16,
	chunk_data: [dynamic]u8, //storing data if the block is in the coordinate
	uniforms: map[string]gl.Uniform_Info,
}

CHUNK_WIDTH :: 16
CHUNK_DEPTH :: 16
CHUNK_HEIGHT :: 1

to_1d_array :: proc(x: int, y: int, z: int) -> int{
	return x + (z * CHUNK_WIDTH)
}

build_chunk :: proc() -> Chunk{
    program, program_ok := gl.load_shaders_source(vertex_source, fragment_source)
	if !program_ok {
		fmt.eprintln("Failed to create GLSL program")
		return Chunk{}
	}
	//defer gl.DeleteProgram(program)
	
	gl.UseProgram(program)
	
	uniforms := gl.get_uniforms_from_program(program)
	//defer delete(uniforms)
	
	vao: u32
	gl.GenVertexArrays(1, &vao) //defer gl.DeleteVertexArrays(1, &vao)
	
	// initialization of OpenGL buffers
	vbo, ebo: u32
	gl.GenBuffers(1, &vbo) //defer gl.DeleteBuffers(1, &vbo)
	gl.GenBuffers(1, &ebo) //defer gl.DeleteBuffers(1, &ebo)

	//generating chunk data
	chunk_data: [dynamic]u8
	for y in 0..<CHUNK_HEIGHT{
		for z in 0..<CHUNK_DEPTH{
			for x in 0..<CHUNK_WIDTH{
				assign_at(&chunk_data, to_1d_array(x, y, z), 1)
			}
		}
	}

	vertices := make([dynamic]Vertex)
	indices := make([dynamic]u16)
	color_light := glm.vec3{0.37, 1.0, 0.39}
	color_dark := glm.vec3{0.13, 0.81, 0.15}
	i: u16 = 0
	j: u8 = 0
	for z in 0..<CHUNK_DEPTH{
		for x in 0..<CHUNK_WIDTH{
			color := j %% 2 == 0 ? color_light : color_dark
			j += 1
			//front face
			if z == CHUNK_DEPTH - 1 || chunk_data[to_1d_array(x, 1, z + 1)] != 1{
				temp_vertices, temp_indices := generate_face_mesh({f32(x), 0.0, f32(z)}, color, .Front, i) 
				append(&vertices, ..temp_vertices[:])
				append(&indices, ..temp_indices[:])
				i += 1
			}
			//back face
			if z == 0 || chunk_data[to_1d_array(x, 1, z - 1)] != 1{
				temp_vertices, temp_indices := generate_face_mesh({f32(x), 0.0, f32(z)}, color, .Back, i) 
				append(&vertices, ..temp_vertices[:])
				append(&indices, ..temp_indices[:])
				i += 1
			}
			//right face
			fmt.println(x)
			if x == CHUNK_WIDTH - 1 || chunk_data[to_1d_array(x + 1, 1, z)] != 1{
				temp_vertices, temp_indices := generate_face_mesh({f32(x), 0.0, f32(z)}, color, .Right, i) 
				append(&vertices, ..temp_vertices[:])
				append(&indices, ..temp_indices[:])
				i += 1
			}
			//left face
			if x == 0 || chunk_data[to_1d_array(x - 1, 1, z)] != 1{
				temp_vertices, temp_indices := generate_face_mesh({f32(x), 0.0, f32(z)}, color, .Left, i) 
				append(&vertices, ..temp_vertices[:])
				append(&indices, ..temp_indices[:])
				i += 1
			}
			//top face
			if true{
				temp_vertices, temp_indices := generate_face_mesh({f32(x), 0.0, f32(z)}, color, .Top, i) 
				append(&vertices, ..temp_vertices[:])
				append(&indices, ..temp_indices[:])
				i += 1
			}
			//bottom face
			if true{
				temp_vertices, temp_indices := generate_face_mesh({f32(x), 0.0, f32(z)}, color, .Bottom, i) 
				append(&vertices, ..temp_vertices[:])
				append(&indices, ..temp_indices[:])
				i += 1
			}
		}
	}
	fmt.println("faces drawn ", i)

	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(gl.ARRAY_BUFFER, len(vertices)*size_of(vertices[0]), raw_data(vertices), gl.STATIC_DRAW)
	gl.EnableVertexAttribArray(0)
	gl.EnableVertexAttribArray(1)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, pos))
	gl.VertexAttribPointer(1, 4, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, col))
	
	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(indices)*size_of(indices[0]), raw_data(indices), gl.STATIC_DRAW)

    return Chunk{
        vao = vao,
        vbo = vbo,
        ebo = ebo,
        program = program,
		vertices = vertices,
		indices = indices,
		uniforms = uniforms,
    }
}