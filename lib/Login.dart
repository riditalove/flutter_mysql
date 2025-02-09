import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Function to handle login API request
Future<void> _login() async {
  final String apiUrl = "http://10.0.2.2/on_duty/lib/login.php";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );


    print("Raw Response: ${response.body}"); // Debugging step

    // final data = jsonDecode(response.body);

    final trimmedResponse = response.body.trim(); // Remove unwanted characters
    final data = json.decode(trimmedResponse);
    // Error happens here if JSON is invalid


    if (response.statusCode == 200 && data['status'] == "success") {
      print("Login sucessful");
     
    } else {

      print("sorry");
      print(response.statusCode);
      _showErrorDialog(data['message']);
    }
  } catch (e) {

    _showErrorDialog("Error: $e"); // Show error in dialog
    print("Login error: $e"); // Debugging step
  }
}


  // Function to show error messages
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login Failed"),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Section
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image.asset(
                  'Assets/indesore.png',
                  height: 250,
                  width: 250,
                ),
              ),

              // Card Section with Text Field and Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 18,
                  shadowColor: Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Let's Work!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3C3C3C),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Email Input Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Password Input Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),

                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _login, // Disable button while loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB3A9A0),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
