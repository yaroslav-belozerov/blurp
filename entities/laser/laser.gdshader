shader_type canvas_item;
uniform float opacity;

float random (float a) {
    return fract(sin(dot(vec2(a,a),
        vec2(12.9898,78.233))) * 43758.5453123)/2.0 + 0.5;
}

void vertex() {
	VERTEX += vec2(0.0, UV.x * 10.0 * sin(TIME * 10.0)); 
	// Called for every vertex the mat erial is visible on.
}

bool sinn(float x, float y, float t) {
	return (y < 0.5 && (y > (sin(x * 40.0 * random(t) - 4.0*t) / 2.0 + 0.5) / 2.0)) || (y > 0.5 && (y < (sin(x * 40.0 * random(t) - 4.0*t) / 2.0 + 1.5) / 2.0));
}

bool aaargh(float x, float y, float t) {
	return sinn(x, y, t * 30.0) || sinn(x + 0.5, y, t * 20.0) || sinn(x, y, t * 15.0);
}

void fragment() {
	COLOR = vec4(1.0, sin(TIME * 2.0 + UV.x), 0.0, aaargh(UV.x, UV.y, TIME) && UV.x / 2.0 > abs(UV.y - 0.5) && (UV.x < opacity) ? 1.0 * clamp(opacity, 0.0, 0.9) : 0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
