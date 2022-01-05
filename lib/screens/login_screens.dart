import 'package:firebase_12dec/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool loadingGoogle=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  hintText: "example@mail.kom"),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "Example@123"),
            ),
            const SizedBox(
              height: 30,
            ),
            loading
                ? const CircularProgressIndicator()
                : Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('All fields are required.')));
                        } else {
                          User? result = await AuthService().loginAuth(
                              emailController.text,
                              passwordController.text,
                              context);
                          if (result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("mail:$result.email")));
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => const HomeScreen(),
                            //     ),
                            //     (route) => false);
                          }
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            loadingGoogle ? const CircularProgressIndicator():SignInButton(
              Buttons.Google,
              onPressed: () async {
                setState((){
                  loadingGoogle=true;
                });
                await AuthService().signInWithGoogle(context);
                setState((){
                  loadingGoogle=false;
                });
              },
              text: "Continue with google",
            )
          ],
        ),
      ),
    );
  }
}
