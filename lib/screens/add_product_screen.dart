import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:prctaskone/models/product_model.dart';
import 'package:prctaskone/services/api_service.dart';
import 'package:prctaskone/theme/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _priceCtrl.text.trim().isEmpty ||
        _descCtrl.text.trim().isEmpty) {
      _showAlert('Peringatan', 'Semua field wajib diisi.');
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    final requestData = ProductRequestModel(
      name: _nameCtrl.text.trim(),
      price: int.tryParse(_priceCtrl.text.trim()) ?? 0,
      description: _descCtrl.text.trim(),
    );

    final success = await ApiService.addProduct(requestData);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      HapticFeedback.mediumImpact();
      Navigator.pop(context, true);
    } else {
      _showAlert('Gagal', 'Produk gagal ditambahkan. Coba lagi.');
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
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.groupedBackground,
        border: null,
        middle: const Text('Tambah Produk'),
        trailing: _isLoading
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 44),
                onPressed: _submit,
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Info produk
              _buildSectionLabel('INFO PRODUK'),
              _buildFormGroup([
                _buildFieldRow(
                  icon: CupertinoIcons.tag,
                  child: CupertinoTextField.borderless(
                    controller: _nameCtrl,
                    placeholder: 'Nama Produk',
                    placeholderStyle: const TextStyle(
                      color: AppColors.tertiaryLabel,
                    ),
                    style: AppTextStyles.body,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  showDivider: true,
                ),
                _buildFieldRow(
                  icon: CupertinoIcons.money_dollar_circle,
                  child: CupertinoTextField.borderless(
                    controller: _priceCtrl,
                    placeholder: 'Harga (Rp)',
                    placeholderStyle: const TextStyle(
                      color: AppColors.tertiaryLabel,
                    ),
                    style: AppTextStyles.body,
                    keyboardType: TextInputType.number,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  showDivider: false,
                ),
              ]),

              const SizedBox(height: AppSpacing.lg),

              // Deskripsi
              _buildSectionLabel('DESKRIPSI'),
              _buildFormGroup([
                _buildFieldRow(
                  icon: CupertinoIcons.doc_text,
                  child: CupertinoTextField.borderless(
                    controller: _descCtrl,
                    placeholder: 'Tulis deskripsi produk…',
                    placeholderStyle: const TextStyle(
                      color: AppColors.tertiaryLabel,
                    ),
                    style: AppTextStyles.body,
                    maxLines: 5,
                    minLines: 3,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  showDivider: false,
                ),
              ]),

              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : const Text(
                          'Simpan Produk',
                          style: AppTextStyles.buttonLabel,
                        ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.xs,
      ),
      child: Text(label, style: AppTextStyles.sectionHeader),
    );
  }

  Widget _buildFormGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryGroupedBackground,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildFieldRow({
    required IconData icon,
    required Widget child,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Icon(icon, size: 20, color: AppColors.tertiaryLabel),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: child),
            ],
          ),
        ),
        if (showDivider) AppDivider(leftIndent: AppSpacing.xl + AppSpacing.sm),
      ],
    );
  }
}
