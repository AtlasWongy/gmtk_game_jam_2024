shader_type spatial;

uniform sampler2D main_texture : hint_normal;
uniform sampler2D dissolve_texture;

void fragment() {
	vec4 color = texture(main_texture, UV);
	float dissolve_value = mix(0.5, 0.6, sin(TIME));
	vec4 noise_texture = texture(dissolve_texture, UV + vec2(10.0 * sin(TIME / 5.0), 10.0 * cos(TIME / 5.0)) / 5.0);
	float mult = floor(dissolve_value + min(1.0, noise_texture.x));
	color.g *= mult;
    color.r -= mult - 0.1;
    color.g -= mult - 0.1;
    color.b -= mult - 0.1;
    ALBEDO = color.rgb;
}

