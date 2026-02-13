shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D shape_texture: filter_nearest_mipmap;
uniform sampler2D noise_texture: filter_nearest_mipmap;
uniform sampler2D gradient_texture: filter_nearest_mipmap;


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}


void fragment() {
	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float randomness = texture(noise_texture, vec2(world_vertex.x, world_vertex.z)).x;

	vec4 noise = texture(noise_texture, UV + vec2(0.0, TIME * 2.0));
	vec4 gradient = texture(gradient_texture, rotateUV(UV, vec2(0.0, 0.0), radians(90.0)));

	vec4 shape = texture(shape_texture, UV);
	float shape_av = (shape.x + shape.y + shape.z)/3.0;
	shape.x = shape_av;
	shape.y = shape_av;
	shape.z = shape_av;

	ALBEDO = noise.xyz * gradient.xyz * shape_av;
	//ALPHA = noise.x * 3.0;
	ALPHA = shape.w * noise.x;
	//if (noise.x < 0.4)
	//{
	//	ALPHA = 0.0;
	//}
}


void vertex()
{
	// Y billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);


	//VERTEX.y += 1.0;
	float height = VERTEX.y + 0.5;
	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//float randomness = world_vertex.x + world_vertex.z;
	float randomness = texture(noise_texture, vec2(world_vertex.x, world_vertex.z)).x * 1000.0;
	//float randomness = fract(sin(world_vertex.x + world_vertex.z) * 23949.23949);
	//VERTEX.y += sin(height * cos(VERTEX.x * VERTEX.z) * TIME)/8.0;
	//VERTEX.xz *= (VERTEX.y - 3.0)/4.0;
	//VERTEX.x += height * sin(float(VERTEX.y + 1.0) * TIME * 8.0 + randomness)/20.0;
	//VERTEX.z += height * cos(float(VERTEX.y + 1.0) * TIME * 8.0 + randomness)/20.0;
	//VERTEX.y += height * sin(float(VERTEX.y + 1.0) * TIME * 8.0 + randomness)/20.0;
}