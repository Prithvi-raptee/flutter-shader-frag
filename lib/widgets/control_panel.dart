import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shader_config.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer widget to listen to changes in ShaderConfig
    return Consumer<ShaderConfig>(
      builder: (context, config, child) {
        return Container(
          width: 280,
          color: Theme.of(context).cardColor,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildShaderSelector(context, config),
              const Divider(height: 32),
              _buildAnimationControls(context, config),
              const Divider(height: 32),
              _buildViewportControls(context, config),
              // Conditionally show controls for the 'rays.frag' shader
              if (config.selectedShader?.contains('rays') ?? false) ...[
                const Divider(height: 32),
                _buildRaysUniformControls(context, config),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildShaderSelector(BuildContext context, ShaderConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Shader", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.black26,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: config.selectedShader,
              items: config.availableShaders.map((path) {
                final fileName = path.split('/').last;
                return DropdownMenuItem(value: path, child: Text(fileName));
              }).toList(),
              onChanged: (value) => config.setSelectedShader(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimationControls(BuildContext context, ShaderConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Animation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(config.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
              onPressed: () => config.togglePlayPause(),
              color: Theme.of(context).primaryColor,
              iconSize: 32,
            )
          ],
        ),
        _ControlSlider(
          label: 'Speed',
          value: config.timeSpeed,
          min: 0.0,
          max: 5.0,
          onChanged: (val) => config.updateValue('timeSpeed', val),
        )
      ],
    );
  }

  Widget _buildViewportControls(BuildContext context, ShaderConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Viewport", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _ControlSlider(
          label: 'Width',
          value: config.width,
          min: 100,
          max: 1920,
          onChanged: (val) => config.updateValue('width', val),
        ),
        _ControlSlider(
          label: 'Height',
          value: config.height,
          min: 100,
          max: 1080,
          onChanged: (val) => config.updateValue('height', val),
        ),
        _ControlSlider(
          label: 'Pan X',
          value: config.viewX,
          min: -config.width,
          max: config.width,
          onChanged: (val) => config.updateValue('viewX', val),
        ),
        _ControlSlider(
          label: 'Pan Y',
          value: config.viewY,
          min: -config.height,
          max: config.height,
          onChanged: (val) => config.updateValue('viewY', val),
        ),
      ],
    );
  }

  Widget _buildRaysUniformControls(BuildContext context, ShaderConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rays Uniforms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _ControlSlider(
          label: 'Intensity',
          value: config.intensity,
          min: 0.0,
          max: 5.0,
          onChanged: (val) => config.updateValue('intensity', val),
        ),
        _ControlSlider(
          label: 'Rays',
          value: config.rays,
          min: 0.0,
          max: 1.0,
          onChanged: (val) => config.updateValue('rays', val),
        ),
        _ControlSlider(
          label: 'Reach',
          value: config.reach,
          min: 0.0,
          max: 1.0,
          onChanged: (val) => config.updateValue('reach', val),
        ),
      ],
    );
  }
}

// A helper widget to reduce boilerplate for sliders
class _ControlSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _ControlSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}