// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// // The root widget of the application.
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Text Processor',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: Colors.blueGrey[900],
//         scaffoldBackgroundColor: const Color(0xFF1E1E1E),
//         colorScheme: const ColorScheme.dark(
//           primary: Colors.tealAccent,
//           secondary: Colors.tealAccent,
//           background: Color(0xFF121212),
//           surface: Color(0xFF1E1E1E),
//           onPrimary: Colors.black,
//           onSecondary: Colors.black,
//           onBackground: Colors.white,
//           onSurface: Colors.white,
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.blueGrey[900]?.withOpacity(0.5),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: const BorderSide(color: Colors.tealAccent, width: 2),
//           ),
//           labelStyle: const TextStyle(color: Colors.white70),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.tealAccent,
//             foregroundColor: Colors.black,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             textStyle: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         useMaterial3: true,
//       ),
//       home: const TextProcessorPage(),
//     );
//   }
// }
//
// // The main page of the application containing the UI and logic.
// class TextProcessorPage extends StatefulWidget {
//   const TextProcessorPage({super.key});
//
//   @override
//   State<TextProcessorPage> createState() => _TextProcessorPageState();
// }
//
// class _TextProcessorPageState extends State<TextProcessorPage> {
//   // Controller to manage the text in the input field.
//   final TextEditingController _inputController = TextEditingController();
//   // State variable to hold the processed output text.
//   String _processedText = '';
//
//   /// Processes the input text by replacing all occurrences of the string "\\n"
//   /// with a newline character "\n" and "\\t" with a tab character "\t".
//   void _processText() {
//     // Get the text from the input controller.
//     final String inputText = _inputController.text;
//
//     // Chain replaceAll to handle both newlines and tabs.
//     final String outputText = inputText.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');
//
//     // Update the state to trigger a UI rebuild with the processed text.
//     setState(() {
//       _processedText = outputText;
//     });
//   }
//
//   /// Clears both the input and output fields.
//   void _clearText() {
//     setState(() {
//       _inputController.clear();
//       _processedText = '';
//     });
//   }
//
//   /// Copies the processed text to the clipboard and shows a snackbar.
//   void _copyToClipboard() {
//     if (_processedText.isNotEmpty) {
//       Clipboard.setData(ClipboardData(text: _processedText));
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Copied to clipboard!'),
//           backgroundColor: Colors.teal,
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     _inputController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fragment Formatter'),
//         centerTitle: true,
//         backgroundColor: Colors.blueGrey[900],
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               // Input text field
//               const Text(
//                 'Paste Your Code Below:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _inputController,
//                 maxLines: 10,
//                 decoration: const InputDecoration(
//                   labelText: 'Input',
//                   alignLabelWithHint: true,
//                 ),
//                 style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
//               ),
//               const SizedBox(height: 20),
//
//               // Action buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.clear),
//                     label: const Text('Clear'),
//                     onPressed: _clearText,
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent.withOpacity(0.8)
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.play_arrow_rounded),
//                     label: const Text('Process'),
//                     onPressed: _processText,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//
//               // Output display area
//               const Text(
//                 'Processed Output:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(12.0),
//                 height: 300,
//                 decoration: BoxDecoration(
//                   color: Colors.blueGrey[900]?.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(12.0),
//                   border: Border.all(color: Colors.grey[800]!),
//                 ),
//                 child: Stack(
//                   children: [
//                     SingleChildScrollView(
//                       child: SelectableText(
//                         _processedText.isEmpty ? 'Your result will appear here...' : _processedText,
//                         style: TextStyle(
//                           fontFamily: 'monospace',
//                           color: _processedText.isEmpty ? Colors.white54 : Colors.white,
//                         ),
//                       ),
//                     ),
//                     if (_processedText.isNotEmpty)
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: const Icon(Icons.copy, color: Colors.white70),
//                           onPressed: _copyToClipboard,
//                           tooltip: 'Copy to Clipboard',
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
