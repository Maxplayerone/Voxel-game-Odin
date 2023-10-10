package main

import "core:fmt"

import gl "vendor:openGL"
import glm "core:math/linalg/glsl"

vertex_light := `#version 330 core
layout(location=0) in vec3 aPos;

uniform mat4 mvp;

void main(){
    gl_Position = mvp * vec4(aPos, 1.0);
}
`

fragment_light : = `#version 330 core
out vec4 FragColor;

void main(){
    FragColor = vec4(1.0);
}
`

Light :: struct{
    vao: u32,
    vbo: u32, 
    ebo: u32,
    program: u32,
    uniforms: map[string]gl.Uniform_Info,
    vertices: [24]Vertex,
    indices: [36]u16,
}

build_light_object :: proc(pos: glm.vec3) -> Light{
    program, program_ok := gl.load_shaders_source(vertex_light, fragment_light)
    if !program_ok{
        fmt.eprintln("failed to create glsl program")
        return Light{}
    }

    gl.UseProgram(program)
    uniforms := gl.get_uniforms_from_program(program)

    vao: u32
    gl.GenVertexArrays(1, &vao)
    gl.BindVertexArray(vao)
    
    vbo, ebo: u32
    gl.GenBuffers(1, &vbo)
    gl.GenBuffers(1, &ebo)
    vertices, indices := generate_block_mesh(pos, {1.0, 1.0, 1.0}, 0)

	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(gl.ARRAY_BUFFER, len(vertices)*size_of(vertices[0]), &vertices, gl.STATIC_DRAW)
	gl.EnableVertexAttribArray(0)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, pos))
	
	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(indices)*size_of(indices[0]), &indices, gl.STATIC_DRAW)

    return Light{
        vao = vao,
        vbo = vbo,
        ebo = ebo,
        program = program,
        vertices = vertices,
        indices = indices,
    }
} 