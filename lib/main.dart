import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showSuccessAlert = false;
  bool showErrorAlert = false;
  String alertMessage = "";

  Future<void> login() async {
    final String apiUrl = "https://reqres.in/api/login";

    // Membuat HttpClient dengan sertifikat yang dapat diandalkan
    HttpClient httpClient = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await httpClient.postUrl(Uri.parse(apiUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "email": emailController.text,
      "password": passwordController.text,
    })));

    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      Map<String, dynamic> data = json.decode(responseBody);
      String token = data["token"];
      alertMessage = "Login Berhasil! Token: $token";
      showSuccessAlert = true;
      showErrorAlert = false;
      print("Status: Berhasil login");
      print("Token: $token");
    } else {
      alertMessage = "Login Gagal, Silakan Coba Lagi";
      showErrorAlert = true;
      showSuccessAlert = false;
      print("Status: Gagal login");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250, // Mengatur lebar form
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Jarak antara form email dan password
                  Container(
                    width: 250, // Mengatur lebar form
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 10), // Jarak antara form password dan tombol login
                  ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
          if (showSuccessAlert)
            Positioned(
              top: 90, // Menempatkan alert lebih dekat dengan form email
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  alertMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (showErrorAlert)
            Positioned(
              top: 90, // Menempatkan alert lebih dekat dengan form email
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  alertMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
