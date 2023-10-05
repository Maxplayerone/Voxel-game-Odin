package main

import gl "vendor:openGL"
import "vendor:glfw"
import "core:fmt"
import "core:c"
import "core:math"
import glm "core:math/linalg/glsl"

running : b32 = true

InitWindow :: proc(window_width: i32, window_height: i32, window_name: cstring) -> glfw.WindowHandle{
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 4) 
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 6)
	glfw.WindowHint(glfw.OPENGL_PROFILE,glfw.OPENGL_CORE_PROFILE)
	
	if(glfw.Init() != 1){
		fmt.println("Failed to initialize GLFW")
	}
    
	window := glfw.CreateWindow(window_width, window_height, window_name, nil, nil)

	if window == nil {
		fmt.println("Unable to create window")
	}

	glfw.MakeContextCurrent(window)
	
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, key_callback)
	glfw.SetCursorPosCallback(window, mouse_callback)

	glfw.SetInputMode(window, glfw.CURSOR, glfw.CURSOR_DISABLED)

	glfw.SetFramebufferSizeCallback(window, size_callback)

	gl.load_up_to(4, 6, glfw.gl_set_proc_address) 

    return window
}

IsRunning :: proc() -> b32{
    return running
}

// Called when glfw keystate changes
key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	// Exit program on escape pressed
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

yaw: f32= -90.0
pitch: f32 = 0.0
direction: glm.vec3
changed_mouse := false
first_mouse := true 
lastx := 480
lasty := 360

mouse_callback :: proc "c" (window: glfw.WindowHandle, xpos, ypos: f64){
	if first_mouse{
		lastx = cast(int)xpos
		lasty = cast(int)ypos
		first_mouse = false
	} 

	xoffset := xpos - cast(f64)lastx
	yoffset := cast(f64)lasty - ypos
	lastx = cast(int)xpos
	lasty = cast(int)ypos

	sens := 0.1
	xoffset *= sens
	yoffset *= sens

	yaw += cast(f32)xoffset
	pitch += cast(f32)yoffset
	if pitch > 89.0{
		pitch = 89.0
	}
	if pitch < -89.0{
		pitch = -89.0
	}

	direction.x = math.cos(glm.radians_f32(yaw)) * math.cos(glm.radians_f32(pitch))
	direction.y = math.sin(glm.radians_f32(pitch))
	direction.z = math.sin(glm.radians_f32(yaw)) * math.cos(glm.radians_f32(pitch))
	direction = glm.normalize(direction)
	changed_mouse = true
}

update_dir :: proc() -> bool{
	return changed_mouse
}

// Called when glfw window changes size
size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	// Set the OpenGL viewport size
	gl.Viewport(0, 0, width, height)
}

WindowCleanup :: proc(window: glfw.WindowHandle){
    glfw.DestroyWindow(window)    
    glfw.Terminate()
}