package main

import "core:fmt"
import "core:c"
import glm "core:math/linalg/glsl"
import "core:math"

import gl "vendor:openGL"
import "vendor:glfw"


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

main :: proc() {
    window := InitWindow(960, 720, "voxel") 
    defer WindowCleanup(window)

	gl.Enable(gl.CULL_FACE)  

    program, program_ok := gl.load_shaders_source(vertex_source, fragment_source)
	if !program_ok {
		fmt.eprintln("Failed to create GLSL program")
		return
	}
	defer gl.DeleteProgram(program)
	
	gl.UseProgram(program)
	
	uniforms := gl.get_uniforms_from_program(program)
	defer delete(uniforms)
	
	vao: u32
	gl.GenVertexArrays(1, &vao); defer gl.DeleteVertexArrays(1, &vao)
	
	// initialization of OpenGL buffers
	vbo, ebo: u32
	gl.GenBuffers(1, &vbo); defer gl.DeleteBuffers(1, &vbo)
	gl.GenBuffers(1, &ebo); defer gl.DeleteBuffers(1, &ebo)

	vertices, indices := generate_block_mesh({0.0, 0.0, 0.0}) 
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(gl.ARRAY_BUFFER, len(vertices)*size_of(vertices[0]), raw_data(vertices), gl.STATIC_DRAW)
	gl.EnableVertexAttribArray(0)
	gl.EnableVertexAttribArray(1)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, pos))
	gl.VertexAttribPointer(1, 4, gl.FLOAT, false, size_of(Vertex), offset_of(Vertex, col))
	
	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(indices)*size_of(indices[0]), raw_data(indices), gl.STATIC_DRAW)


	/*
	camera := Camera{
		pos = glm.vec3{0.0, 0.0, -3.0},
		front = glm.vec3{0.0, 0.0, -1.0},
		up = glm.vec3{0.0, 1.0, 0.0},
		speed = 2.5,
	}
	*/
	camera_pos := glm.vec3{0.0, 0.0, 3.0}
    camera_front := glm.vec3{0.0, 0.0, -1.0}
	camera_up := glm.vec3{0.0, 1.0, 0.0}

	delta_time := 0.0
	last_frame := 0.0

	for (!glfw.WindowShouldClose(window) && IsRunning()) {
		glfw.PollEvents()

		if update_dir(){
			camera_front = direction
		}

		camera_speed: f32 = 2.5 * cast(f32)delta_time

		if glfw.GetKey(window, glfw.KEY_W) == glfw.PRESS{
			camera_pos += camera_speed * camera_front
		}
		if glfw.GetKey(window, glfw.KEY_S) == glfw.PRESS{
			camera_pos -= camera_speed * camera_front
		}
		if glfw.GetKey(window, glfw.KEY_A) == glfw.PRESS{
			camera_pos -= glm.normalize(glm.cross(camera_front, camera_up)) * camera_speed
		}
		if glfw.GetKey(window, glfw.KEY_D) == glfw.PRESS{
			camera_pos += glm.normalize(glm.cross(camera_front, camera_up)) * camera_speed
		}
		if glfw.GetKey(window, glfw.KEY_SPACE) == glfw.PRESS{
			camera_pos += camera_up * camera_speed
		}
		if glfw.GetKey(window, glfw.KEY_LEFT_CONTROL) == glfw.PRESS{
			camera_pos -= camera_up * camera_speed
		}

        model := glm.mat4{
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0,
        }
		view := glm.mat4LookAt(camera_pos, 
					camera_front + camera_pos,
					camera_up)

        proj := glm.mat4Perspective(glm.radians_f32(45.0), 960.0/720.0, 0.1, 100.0)
        u_transform := proj * view * model
        gl.UniformMatrix4fv(uniforms["mvp"].location, 1, false, &u_transform[0, 0])

	    gl.ClearColor(0.2, 0.3, 0.3, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        gl.DrawElements(gl.TRIANGLES, i32(len(indices)), gl.UNSIGNED_SHORT, nil)

		glfw.SwapBuffers((window))

		current_frame := glfw.GetTime()
		delta_time = current_frame - last_frame
		last_frame = current_frame

		changed_mouse = false
	}

}
