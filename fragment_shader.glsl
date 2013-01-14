#version 330

in vec2 uv;

out vec3 color;

uniform sampler2D background;
uniform sampler2D universe;

uniform float frame;

void main() {
	float cell_life = texture(universe, uv).r;
	float cell_bg 	= texture(background, uv).r;
    color = vec3(cell_bg + cell_life);
}