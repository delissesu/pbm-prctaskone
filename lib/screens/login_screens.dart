import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:prctaskone/theme/app_theme.dart';
import '../services/api_service.dart';
import 'product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final nim = _nimController.text.trim();
    final password = _passwordController.text.trim();

    if (nim.isEmpty || password.isEmpty) {
      _showAlert('Kesalahan', 'NIM atau Password tidak boleh kosong.');
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final result = await ApiService.login(nim, password);
      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const ProductListScreen()),
        );
      } else {
        _showAlert('Login Gagal', result['message'] ?? 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (!mounted) return;
      _showAlert('Error', 'Terjadi kesalahan jaringan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.groupedBackground,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),

                  const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.xxs),
                  child: Text('Masuk', style: AppTextStyles.largeTitle),
                ),
                const SizedBox(height: AppSpacing.xxs),
                const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.xxs),
                  child: Text(
                    'Gunakan NIM sebagai username dan password.',
                    style: AppTextStyles.footnote,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Fields
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGroupedBackground,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Column(
                    children: [
                      CupertinoTextField.borderless(
                        controller: _nimController,
                        keyboardType: TextInputType.number,
                        placeholder: 'Username',
                        placeholderStyle: const TextStyle(
                          color: AppColors.tertiaryLabel,
                          fontSize: 17,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 14,
                        ),
                        style: AppTextStyles.body,
                        clearButtonMode: OverlayVisibilityMode.editing,
                      ),
                      const AppDivider(leftIndent: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoTextField.borderless(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.number,
                              placeholder: 'Password',
                              placeholderStyle: const TextStyle(
                                color: AppColors.tertiaryLabel,
                                fontSize: 17,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 14,
                              ),
                              style: AppTextStyles.body,
                            ),
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            minimumSize: const Size(36, 36),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            child: Icon(
                              _obscurePassword
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              size: 20,
                              color: AppColors.tertiaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                        : const Text('Masuk', style: AppTextStyles.buttonLabel),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
