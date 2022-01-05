import 'package:firebase_12dec/screens/login_screens.dart';
import 'package:firebase_12dec/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool loading = false;
  bool loadingGoogle = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
              hintText: "mail@example.in",
            ),
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
          const SizedBox(height: 30),
          TextField(
            controller: confirmpasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Confirm password",
            ),
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
                      "SING IN",
                      style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("All fields are reqired."),
                        ));
                      } else if (passwordController.text !=
                          confirmpasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords does\'nt match.')));
                      } else {
                        User? result = await AuthService().signinAuth(
                            emailController.text,
                            passwordController.text,
                            context);
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("mail:$result.email")));
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const HomeScreen()),
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
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text("Already have an account ? Log In here.")),
          const SizedBox(height: 10),
          const Divider(),
          loadingGoogle
              ? const CircularProgressIndicator()
              : SignInButton(Buttons.Google, text: "Continue with Google",
                  onPressed: () async {
                  await AuthService().signInWithGoogle(context);
                })
        ]),
      ),
    );
  }
}
