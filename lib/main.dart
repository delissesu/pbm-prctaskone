import 'package:flutter/cupertino.dart';
import 'package:prctaskone/screens/login_screens.dart';
import 'package:prctaskone/services/api_service.dart';
import 'package:prctaskone/theme/app_theme.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Prctaskone',
      debugShowCheckedModeBanner: false,
      theme: kAppCupertinoTheme,
      home: const SplashDecider(),
    );
  }
}

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await ApiService.getToken();

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (_) =>
            token != null ? const ProductListScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: Center(child: CupertinoActivityIndicator(radius: 16)),
    );
  }
}
