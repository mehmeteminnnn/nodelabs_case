import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/explore');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Merhabalar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tempus varius a vitae interdum id\n'
                  'tortor elementum tristique eleifend at.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 32),
                // E-Posta TextField
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'E-Posta',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Şifre TextField
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Şifre',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white54,
                      ),
                      suffixIcon: Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Şifremi unuttum',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Giriş Yap Butonu
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        state is AuthLoading
                            ? null
                            : () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Lütfen tüm alanları doldurun.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(
                                LoginRequested(email, password),
                              );
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        state is AuthLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sosyal medya butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton('google'),
                    const SizedBox(width: 16),
                    _buildSocialButton('apple'),
                    const SizedBox(width: 16),
                    _buildSocialButton('facebook'),
                  ],
                ),
                const SizedBox(height: 24),
                // Kayıt Ol metni
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bir hesabın yok mu?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text(
                        'Kayıt Ol!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'google':
        icon = Icons.g_mobiledata;
        color = Colors.white;
        break;
      case 'apple':
        icon = Icons.apple;
        color = Colors.white;
        break;
      case 'facebook':
        icon = Icons.facebook;
        color = Colors.white;
        break;
      default:
        icon = Icons.person;
        color = Colors.white;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Icon(icon, color: color, size: 28)),
    );
  }
}
