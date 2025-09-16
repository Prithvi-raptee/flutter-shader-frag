import 'package:flutter/material.dart';
import 'package:frag/screens/shader_lab_screen.dart';
import 'package:provider/provider.dart';

import 'models/shader_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a ChangeNotifierProvider to manage the app's state.
    return ChangeNotifierProvider(
      create: (context) => ShaderConfig(),
      child: MaterialApp(
        title: 'Flutter Shader Lab',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFF1C1F26),
          cardColor: const Color(0xFF282C34),
          useMaterial3: true,
        ),
        home: const ShaderLabScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}