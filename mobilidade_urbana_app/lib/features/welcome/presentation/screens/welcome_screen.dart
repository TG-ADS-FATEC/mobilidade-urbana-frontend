import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/services/auth_service.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _handleStart() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // Verifica se já existe um JWT válido
    final existingJwt = await DeviceTokenService.getJwt();

    if (existingJwt == null) {
      // Primeira abertura: registra o dispositivo e obtém o JWT
      final result = await AuthService.authenticate();
      if (!mounted) return;

      if (result is DataFailed) {
        setState(() {
          _loading = false;
          _error = 'Não foi possível conectar ao servidor.\nVerifique sua conexão e tente novamente.';
        });
        return;
      }
    }

    if (!mounted) return;
    setState(() => _loading = false);
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/bus.svg',
                          fit: BoxFit.scaleDown,
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Viajar ficou mais simples',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Encontre rotas claras, com menos baldeações e mais conforto',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.directions_bus),
                        label: Text(
                          _loading ? 'Conectando...' : 'Começar minha jornada',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              dark ? TColors.darkBackground : Colors.black87,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _loading ? null : _handleStart,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: TColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Ao continuar, você concorda com nossos ',
                          ),
                          TextSpan(
                            text: 'Termos de Uso',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
