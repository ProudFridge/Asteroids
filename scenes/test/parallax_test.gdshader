shader_type canvas_item;

uniform vec2 textureSize = vec2(512, 512);
uniform int starAmount = 10;

const vec2[3] stars = {vec2(0.5,1), vec2(0.2,0.9), vec2(0.2,0.9)};

void vertex() {

	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	uv *= 29.0;
	uv = mod(uv, 1.0); 
	
	COLOR = vec4(uv.x, uv.y, 1, 1); 
}