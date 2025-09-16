#include <flutter/runtime_effect.glsl>

// Uniforms provided by the Flutter app
uniform vec2 u_resolution;
uniform float u_time;

// The final output color for the fragment
out vec4 outColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution.xy;
    float time = u_time * 0.8;

    float color = 0.0;
    color += sin(uv.x * 10.0 + time) * 0.5 + 0.5;
    color += sin(uv.y * 10.0 + time) * 0.5 + 0.5;
    color += sin((uv.x + uv.y) * 10.0 + time) * 0.5 + 0.5;
    color = mod(color, 1.0);

    // Create a vibrant color from the plasma value
    vec3 plasmaColor = vec3(
    sin(color * 3.14159) * 0.8 + 0.2,
    cos(color * 2.0 * 3.14159) * 0.5 + 0.5,
    sin((color + 0.5) * 3.14159) * 0.7 + 0.3
    );

    // Assign the final color to the out variable
    outColor = vec4(plasmaColor, 1.0);
}
