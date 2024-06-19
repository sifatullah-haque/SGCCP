// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:test/homepage.dart';

// class NewAuthentication extends StatefulWidget {
//   const NewAuthentication({super.key});

//   @override
//   _NewAuthenticationState createState() => _NewAuthenticationState();
// }

// class _NewAuthenticationState extends State<NewAuthentication> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> login(
//       BuildContext context, String email, String password) async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final url = Uri.parse('https://app.sgccp-bd.com/api/login');
//       final headers = {'Content-Type': 'application/json'};
//       final body = jsonEncode({'email': email, 'password': password});

//       print('Sending POST request to $url');
//       print('Request headers: $headers');
//       print('Request body: $body');

//       final response = await http.post(url, headers: headers, body: body);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('Login response: $data');

//         if (data['success'] == true) {
//           // Navigate to homepage
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomePage()),
//           );
//         } else {
//           // Show error dialog
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Text('Login Failed'),
//               content: Text('Error: ${data['message']}'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//           );
//         }
//       } else {
//         // Handle error response
//         print(
//             'Login failed: ${response.statusCode} - ${response.reasonPhrase}');
//         print('Response body: ${response.body}');

//         // Show error dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Login Failed'),
//             content: Text('Error: ${response.reasonPhrase}'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (error) {
//       print('An error occurred: $error');

//       // Show error dialog
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('An Error Occurred'),
//           content: Text('Error: $error'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             // logo
//             Center(
//               child: Text(
//                 "Logo",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),

//             // email field
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: "Email",
//                 labelText: "Email",
//               ),
//             ),
//             SizedBox(height: 20),

//             // password field
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                 hintText: "Password",
//                 labelText: "Password",
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),

//             // login button
//             ElevatedButton(
//               onPressed: isLoading
//                   ? null
//                   : () {
//                       final email = emailController.text;
//                       final password = passwordController.text;
//                       login(context, email, password);
//                     },
//               child: isLoading
//                   ? CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     )
//                   : Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
