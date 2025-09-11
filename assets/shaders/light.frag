#version 460 core
#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform vec4 u_colors[2];
uniform float u_intensity;
uniform float u_rays;
uniform float u_reach;

out vec4 fragColor;

// Simple noise function for ray variation
float noise(vec2 p) {
    return sin(p.x * 0.129 + p.y * 0.15) * sin(p.x * 0.15 + p.y * 0.121);
}

// Smooth step function for gradients
float smootherstep(float edge0, float edge1, float x) {
    x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}

// Generate light rays from top
float rayPattern(vec2 uv, float time) {
    vec2 center = vec2(0.5, 0.0); // Ray source at top center
    vec2 dir = uv - center;
    float angle = atan(dir.y, dir.x);
    float dist = length(dir);

    // Create multiple rays with different speeds and intensities
    float rays = 0.0;

    // Main rays
    for (int i = 0; i < 12; i++) {
        float rayAngle = float(i) * 0.524; // ~30 degrees apart
        float angleDiff = abs(angle - rayAngle);
        angleDiff = min(angleDiff, 6.283 - angleDiff); // Wrap around

        float rayWidth = 0.15 + 0.05 * sin(time * 0.8 + float(i));
        float rayIntensity = 1.0 - smoothstep(0.0, rayWidth, angleDiff);

        // Animate ray intensity
        rayIntensity *= 0.7 + 0.3 * sin(time * 1.2 + float(i) * 0.5);

        // Distance falloff
        rayIntensity *= 1.0 - smoothstep(0.0, 1.5, dist);

        rays += rayIntensity;
    }

    // Add some additional scattered rays
    float scatteredRays = 0.0;
    for (int i = 0; i < 8; i++) {
        float rayAngle = float(i) * 0.785 + 0.3; // Different spacing
        float angleDiff = abs(angle - rayAngle);
        angleDiff = min(angleDiff, 6.283 - angleDiff);

        float rayWidth = 0.08 + 0.03 * sin(time * 1.5 + float(i) * 0.7);
        float rayIntensity = 1.0 - smoothstep(0.0, rayWidth, angleDiff);

        rayIntensity *= 0.4 + 0.2 * sin(time * 0.9 + float(i) * 0.3);
        rayIntensity *= 1.0 - smoothstep(0.0, 1.2, dist);

        scatteredRays += rayIntensity * 0.6;
    }

    return clamp(rays + scatteredRays, 0.0, 1.0);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // Create smooth transparency gradient from top to bottom
    float alphaGradient = smootherstep(0.0, 1.0, 1.0 - uv.y);

    // Generate ray pattern
    float rayMask = rayPattern(uv, u_time);

    // Add some subtle noise for organic feel
    float noiseValue = noise(uv * 10.0 + u_time * 0.2) * 0.05;
    rayMask += noiseValue;

    // Mix the two colors based on horizontal position and time
    float colorMix = 0.5 + 0.3 * sin(u_time * 0.7 + uv.x * 3.14);
    vec4 finalColor = mix(u_colors[0], u_colors[1], colorMix);

    // Apply ray intensity
    finalColor.rgb *= rayMask * u_intensity;

    // Apply smooth transparency gradient
    finalColor.a *= alphaGradient;

    // Additional brightness boost at the top
    float topBrightness = 1.0 + (1.0 - uv.y) * 0.5;
    finalColor.rgb *= topBrightness;

    // Ensure smooth falloff
    finalColor.rgb *= finalColor.a;

    fragColor = finalColor;
}