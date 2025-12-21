//
// // lib/presentation/pages/setup_password_screen.dart
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert';
// import 'private_notes.dart';
//
// class SetupPasswordScreen extends StatefulWidget {
//   @override
//   _SetupPasswordScreenState createState() => _SetupPasswordScreenState();
// }
//
// class _SetupPasswordScreenState extends State<SetupPasswordScreen> {
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _questionController = TextEditingController();
//   final _answerController = TextEditingController();
//
//   String hashPassword(String password) {
//     var bytes = utf8.encode(password);
//     var digest = sha256.convert(bytes);
//     return digest.toString();
//   }
//
//   void showMessage(String message, bool isError) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   Future<void> setupPassword() async {
//     if (_passwordController.text.length < 4) {
//       showMessage('Password must be at least 4 characters', true);
//       return;
//     }
//     if (_passwordController.text != _confirmPasswordController.text) {
//       showMessage('Passwords do not match', true);
//       return;
//     }
//     if (_questionController.text.trim().isEmpty ||
//         _answerController.text.trim().isEmpty) {
//       showMessage('Please set security question and answer', true);
//       return;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('password', hashPassword(_passwordController.text));
//     await prefs.setString('securityQuestion', _questionController.text);
//     await prefs.setString('securityAnswer', _answerController.text.toLowerCase());
//
//     showMessage('Password setup successful!', false);
//     await Future.delayed(Duration(seconds: 1));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => PrivateNotes()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF181818),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF181818),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'Setup Password',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Protect your private notes',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Enter password',
//                     labelStyle: TextStyle(color: Colors.grey),
//                     filled: true,
//                     fillColor: Color(0xFF202020),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Confirm password',
//                     labelStyle: TextStyle(color: Colors.grey),
//                     filled: true,
//                     fillColor: Color(0xFF202020),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _questionController,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Security question',
//                     hintText: "e.g., What's your pet's name?",
//                     hintStyle: TextStyle(color: Colors.grey[700]),
//                     labelStyle: TextStyle(color: Colors.grey),
//                     filled: true,
//                     fillColor: Color(0xFF202020),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _answerController,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: 'Security answer',
//                     labelStyle: TextStyle(color: Colors.grey),
//                     filled: true,
//                     fillColor: Color(0xFF202020),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: setupPassword,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFF6D14C),
//                     foregroundColor: Colors.black,
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     'Proceed',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _questionController.dispose();
//     _answerController.dispose();
//     super.dispose();
//   }
// }