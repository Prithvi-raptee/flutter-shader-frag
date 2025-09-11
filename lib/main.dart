import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient Light Rays',
      theme: ThemeData.dark(useMaterial3: true),
      home: const GradientRaysScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GradientRaysScreen extends StatefulWidget {
  const GradientRaysScreen({super.key});

  @override
  State<GradientRaysScreen> createState() => _GradientRaysScreenState();
}

class _GradientRaysScreenState extends State<GradientRaysScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _time = 0.0;

  // Same colors from your original JSON
  final _uIntensity = 1.2; // Increased for better visibility with transparency
  final _uRays = 0.096;
  final _uReach = 0.335;
  final _uColors = [
    // Green color: R, G, B, A
    0.5725490196078431, 0.996078431372549, 0.615686274509804, 1.0,
    // Blue color: R, G, B, A
    0.0, 0.788235294117647, 1.0, 1.0,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Slower for smoother effect
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _time = _controller.value * 15;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Light Rays'),
        elevation: 4,
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001122),
              Color(0xFF000511),
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 800,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ShaderBuilder(
                assetKey: 'assets/shaders/rays.frag',
                    (context, shader, child) {
                  return Transform.rotate(
                    angle: 3.14159, // Rotate 180 degrees (in radians)

                    child: AnimatedSampler(
                          (image, size, canvas) {
                        // Set uniforms
                        shader.setFloat(0, size.width);   // u_resolution.x
                        shader.setFloat(1, size.height);  // u_resolution.y
                        shader.setFloat(2, 0.0);          // u_mouse.x (unused)
                        shader.setFloat(3, 0.0);          // u_mouse.y (unused)
                        shader.setFloat(4, _time);        // u_time

                        // u_colors array (2 vec4s = 8 floats)
                        for (var i = 0; i < _uColors.length; i++) {
                          shader.setFloat(5 + i, _uColors[i]);
                        }

                        // Other uniforms
                        shader.setFloat(13, _uIntensity); // u_intensity
                        shader.setFloat(14, _uRays);      // u_rays
                        shader.setFloat(15, _uReach);     // u_reach

                        // Draw the shader
                        canvas.drawRect(
                          Rect.fromLTWH(0, 0, size.width, size.height),
                          Paint()..shader = shader,
                        );
                      },
                      child: const SizedBox.expand(),
                    ),
                  );
                },
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5AFF9D)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}