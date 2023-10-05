package main

import glm "core:math/linalg/glsl"
import "vendor:glfw"

Camera :: struct{
    pos: glm.vec3,
    front: glm.vec3,
    up: glm.vec3,
    speed: f32,
}

update_camera :: proc(window :glfw.WindowHandle, camera: Camera, delta_time: f64) -> Camera{
    camera := camera

    speed := camera.speed * cast(f32)delta_time

	if glfw.GetKey(window, glfw.KEY_W) == glfw.PRESS{
		camera.pos += speed * camera.front
	}
	if glfw.GetKey(window, glfw.KEY_S) == glfw.PRESS{
		camera.pos -= speed * camera.front
	}
	if glfw.GetKey(window, glfw.KEY_A) == glfw.PRESS{
		camera.pos -= glm.normalize(glm.cross(camera.front, camera.up)) * speed
	}
	if glfw.GetKey(window, glfw.KEY_D) == glfw.PRESS{
		camera.pos += glm.normalize(glm.cross(camera.front, camera.up)) * speed
	}

    return camera
}

get_view :: proc(camera: Camera) -> glm.mat4{
    return glm.mat4LookAt(camera.pos, camera.front + camera.up, camera.up)
}