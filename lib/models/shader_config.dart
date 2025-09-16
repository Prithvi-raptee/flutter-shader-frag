import 'package:flutter/material.dart';

class ShaderConfig with ChangeNotifier {
  // Shader Selection
  String? _selectedShader;
  List<String> _availableShaders = [];

  // Animation
  bool _isPlaying = true;
  double _timeSpeed = 1.0;

  // Viewport Controls
  double _width = 800.0;
  double _height = 500.0;
  double _viewX = 0.0; // Pan X
  double _viewY = 0.0; // Pan Y

  // Uniforms for rays.frag
  double _intensity = 1.0;
  double _rays = 0.1;
  double _reach = 0.35;

  // --- Getters ---
  String? get selectedShader => _selectedShader;
  List<String> get availableShaders => _availableShaders;
  bool get isPlaying => _isPlaying;
  double get timeSpeed => _timeSpeed;
  double get width => _width;
  double get height => _height;
  double get viewX => _viewX;
  double get viewY => _viewY;
  double get intensity => _intensity;
  double get rays => _rays;
  double get reach => _reach;

  // --- Setters ---
  void setAvailableShaders(List<String> shaders) {
    _availableShaders = shaders;
    if (shaders.isNotEmpty && _selectedShader == null) {
      _selectedShader = shaders.first;
    }
    notifyListeners();
  }

  void setSelectedShader(String? shaderPath) {
    _selectedShader = shaderPath;
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void updateValue(String key, double value) {
    switch (key) {
      case 'timeSpeed':
        _timeSpeed = value;
        break;
      case 'width':
        _width = value;
        break;
      case 'height':
        _height = value;
        break;
      case 'viewX':
        _viewX = value;
        break;
      case 'viewY':
        _viewY = value;
        break;
      case 'intensity':
        _intensity = value;
        break;
      case 'rays':
        _rays = value;
        break;
      case 'reach':
        _reach = value;
        break;
    }
    notifyListeners();
  }
}