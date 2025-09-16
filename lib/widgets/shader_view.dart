import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:provider/provider.dart';

import '../models/shader_config.dart';

class ShaderView extends StatefulWidget {
  const ShaderView({super.key});

  @override
  State<ShaderView> createState() => _ShaderViewState();
}

class _ShaderViewState extends State<ShaderView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _time = 0.0;

  final _uColors = [
    // Green color: R, G, B, A
    0.57, 0.99, 0.61, 1.0,
    // Blue color: R, G, B, A
    0.0, 0.78, 1.0, 1.0,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // duration doesn't matter much here
    )..addListener(() {
      final config = Provider.of<ShaderConfig>(context, listen: false);
      if (config.isPlaying) {
        setState(() {
          _time += (1 / 60) * config.timeSpeed; // Assuming 60fps
        });
      }
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderConfig>(
      builder: (context, config, child) {
        if (config.selectedShader == null) {
          return const Center(child: Text("Select a shader to begin"));
        }
        return InteractiveViewer(
          maxScale: 5.0,
          minScale: 0.1,
          child: Center(
            child: SizedBox(
              width: config.width,
              height: config.height,
              child: ClipRect(
                child: ShaderBuilder(
                  assetKey: config.selectedShader!,
                      (context, shader, child) {
                    return AnimatedSampler(
                          (image, size, canvas) {
                        // The magic happens here! We set the uniforms.
                        shader.setFloat(0, size.width);  // u_resolution.x
                        shader.setFloat(1, size.height); // u_resolution.y
                        shader.setFloat(2, _time);       // u_time

                        if (config.selectedShader!.contains('rays')) {
                          for (var i = 0; i < _uColors.length; i++) {
                            shader.setFloat(3 + i, _uColors[i]);
                          }
                          shader.setFloat(11, config.intensity);
                          shader.setFloat(12, config.rays);
                          shader.setFloat(13, config.reach);
                        }

                        // Translate canvas to simulate panning the viewport
                        canvas.save();
                        canvas.translate(-config.viewX, -config.viewY);

                        canvas.drawRect(
                          Rect.fromLTWH(0, 0, size.width, size.height),
                          Paint()..shader = shader,
                        );
                        canvas.restore();
                      },
                      child: const SizedBox.expand(),
                    );
                  },
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}