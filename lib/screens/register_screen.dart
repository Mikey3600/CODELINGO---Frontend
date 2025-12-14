import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  void registerUser() async {
    setState(() => loading = true);

    final res = await ApiService.register(
      username.text.trim(),
      email.text.trim(),
      password.text.trim(),
    );

    setState(() => loading = false);

    if (res["message"] == "EXISTS") {
      showError("User already exists");
    } else if (res["message"] == "REGISTERED") {
      showError("Registration Successful!");
      Navigator.pop(context);
    } else {
      showError("Something went wrong");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                const Text('</>',
                    style: TextStyle(
                        fontSize: 72,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 8)),

                const SizedBox(height: 8),
                const Text("JOIN THE CULT",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                      letterSpacing: 4,
                    )),

                const SizedBox(height: 50),

                _buildInput("USERNAME", controller: username),
                const SizedBox(height: 24),

                _buildInput("EMAIL", controller: email),
                const SizedBox(height: 24),

                _buildInput("PASSWORD", controller: password, obscure: true),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: loading ? null : registerUser,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("REGISTER",
                            style: TextStyle(
                                color: Colors.white, letterSpacing: 2)),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("BACK TO LOGIN",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                          decoration: TextDecoration.underline)),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  height: 180,
                  width: 180,
                  child: Lottie.asset("assets/death_dance.json",
                      repeat: true, fit: BoxFit.contain),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInput(String hint,
    {bool obscure = false, required TextEditingController controller}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, letterSpacing: 2),
      enabledBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
      focusedBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    ),
  );
}
