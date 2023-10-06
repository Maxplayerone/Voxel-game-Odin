package main

import "core:fmt"
import "core:c"
import glm "core:math/linalg/glsl"
import "core:math"

import gl "vendor:openGL"
import "vendor:glfw"

main :: proc() {
    window := InitWindow(960, 720, "voxel") 
    defer WindowCleanup(window)

	gl.Enable(gl.CULL_FACE)  
	chunk := build_chunk()
	for vertex in chunk.vertices{
		fmt.println(vertex)
	}

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
        gl.UniformMatrix4fv(chunk.uniforms["mvp"].location, 1, false, &u_transform[0, 0])

	    gl.ClearColor(0.2, 0.3, 0.3, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

    	gl.DrawElements(gl.TRIANGLES, i32(len(chunk.indices)), gl.UNSIGNED_SHORT, nil)

		glfw.SwapBuffers((window))

		current_frame := glfw.GetTime()
		delta_time = current_frame - last_frame
		last_frame = current_frame

		changed_mouse = false
	}

}
