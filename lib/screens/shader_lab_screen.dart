import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/shader_config.dart';
import '../widgets/control_panel.dart';
import '../widgets/shader_view.dart';

class ShaderLabScreen extends StatefulWidget {
  const ShaderLabScreen({super.key});

  @override
  State<ShaderLabScreen> createState() => _ShaderLabScreenState();
}

class _ShaderLabScreenState extends State<ShaderLabScreen> {
  @override
  void initState() {
    super.initState();
    // After the first frame, load the list of shaders from the assets.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvailableShaders();
    });
  }

  Future<void> _loadAvailableShaders() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final shaderPaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/shaders/'))
        .where((key) => key.endsWith('.frag'))
        .toList();

    if (mounted) {
      Provider.of<ShaderConfig>(context, listen: false)
          .setAvailableShaders(shaderPaths);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Shader Lab'),
        backgroundColor: const Color(0xFF282C34),
        elevation: 4,
        leading: isDesktop
            ? null
            : Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: isDesktop ? null : const Drawer(child: ControlPanel()),
      body: Row(
        children: [
          if (isDesktop) const ControlPanel(),
          const Expanded(
            child: ShaderView(),
          ),
        ],
      ),
    );
  }
}