#version 460 core

// Declare an output for the final color
out vec4 fragColor;

// Uniforms (inputs from our Flutter app)
uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 u_colors[2];

void main() {
    // Get normalized coordinates, where uv.y is 0.0 at the bottom and 1.0 at the top.
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // --- Light Rays Effect ---
    // Create a smooth, time-varying pattern using sine waves based on the horizontal position.
    // Multiplying by a larger number (like 20.0) creates more rays.
    // Adding a touch of uv.y gives the rays a slight, dynamic slant.
    float pattern = 0.5 + 0.5 * sin(uv.x * 20.0 + u_time * 1.5 + uv.y * 4.0);

    // Smooth the pattern to create softer edges for the rays.
    pattern = smoothstep(0.35, 0.65, pattern);

    // Mix the two main colors based on the generated pattern.
    vec3 mixedColor = mix(u_colors[0].rgb, u_colors[1].rgb, pattern);

    // --- Vertical Transparency Gradient ---
    // "Transparency increases as you go down" means alpha should be 1.0 at the top (uv.y=1)
    // and 0.0 at the bottom (uv.y=0). So, we can just use the uv.y value for alpha.
    float alpha = uv.y;

    // Use smoothstep to make the fade-out more gradual and visually pleasing.
    // This starts the fade from the bottom and completes it 80% of the way up.
    alpha = smoothstep(0.0, 0.8, alpha);

    // Combine the final color and alpha.
    fragColor = vec4(mixedColor, alpha);
}
