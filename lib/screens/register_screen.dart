import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
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
                  const SizedBox(height: 80),
                  const Text(
                    'Hoşgeldiniz',
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
                  // Ad Soyad
                  _buildInputField(
                    Icons.person_outline,
                    'Ad Soyad',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  // E-Posta
                  _buildInputField(
                    Icons.email_outlined,
                    'E-Posta',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  // Şifre
                  _buildInputField(
                    Icons.lock_outline,
                    'Şifre',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // Şifre Tekrar
                  _buildInputField(
                    Icons.lock_outline,
                    'Şifre Tekrar',
                    controller: _passwordAgainController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // Kullanıcı sözleşmesi metni
                  const Text.rich(
                    TextSpan(
                      text: 'Kullanıcı sözleşmesini ',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'okudum ve kabul ediyorum.',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' Bu sözleşmeyi okuyarak devam ediniz lütfen.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Şimdi Kaydol Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          state is AuthLoading
                              ? null
                              : () {
                                final name = _nameController.text.trim();
                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();
                                final passwordAgain =
                                    _passwordAgainController.text.trim();
                                if (name.isEmpty ||
                                    email.isEmpty ||
                                    password.isEmpty ||
                                    passwordAgain.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Lütfen tüm alanları doldurun.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (password != passwordAgain) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Şifreler uyuşmuyor.'),
                                    ),
                                  );
                                  return;
                                }
                                context.read<AuthBloc>().add(
                                  RegisterRequested(name, email, password),
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
                                'Şimdi Kaydol',
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
                  // Zaten hesabın var mı? Giriş Yap!
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Zaten bir hesabın var mı?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Giriş Yap!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hint, {
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white54),
          suffixIcon:
              obscureText
                  ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.white54,
                  )
                  : null,
          border: InputBorder.none,
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
