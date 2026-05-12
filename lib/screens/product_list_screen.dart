import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:prctaskone/models/product_model.dart';
import 'package:prctaskone/screens/login_screens.dart';
import 'package:prctaskone/services/api_service.dart';
import 'package:prctaskone/theme/app_theme.dart';
import 'package:prctaskone/widgets/product_card_widget.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> _products = [];
  List<ProductModel> _filtered = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _products
          : _products
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(query) ||
                      p.description.toLowerCase().contains(query),
                )
                .toList();
    });
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final newProducts = await ApiService.getProducts();
    if (mounted) {
      setState(() {
        _products = newProducts;
        _filtered = newProducts;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int id) async {
    HapticFeedback.mediumImpact();
    final success = await ApiService.deleteProduct(id);
    if (!mounted) return;
    if (success) {
      _loadProducts();
    } else {
      _showAlert('Gagal', 'Produk gagal dihapus. Coba lagi.');
    }
  }

  void _confirmDelete(int id, String name) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Hapus Produk'),
        message: Text(
          'Yakin ingin menghapus "$name"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              _deleteProduct(id);
            },
            child: const Text('Hapus'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  // dialog submit
  void _showSubmitDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final githubCtrl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Submit Tugas'),
        content: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(nameCtrl, 'Nama Produk'),
              const SizedBox(height: AppSpacing.xs),
              _buildDialogField(priceCtrl, 'Harga', isNumber: true),
              const SizedBox(height: AppSpacing.xs),
              _buildDialogField(descCtrl, 'Deskripsi'),
              const SizedBox(height: AppSpacing.xs),
              _buildDialogField(githubCtrl, 'GitHub URL'),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Submit'),
            onPressed: () async {
              final requestModel = SubmitTugasModel(
                name: nameCtrl.text,
                price: int.tryParse(priceCtrl.text) ?? 0,
                description: descCtrl.text,
                githubUrl: githubCtrl.text,
              );
              Navigator.pop(ctx);
              final success = await ApiService.submitTugas(requestModel);
              if (!mounted) return;
              if (success) {
                _loadProducts();
                _showAlert('Berhasil', 'Tugas berhasil disubmit!');
              } else {
                _showAlert('Gagal', 'Gagal submit. Periksa data kamu.');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(
    TextEditingController controller,
    String placeholder, {
    bool isNumber = false,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    );
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

  void _goToAddProduct() async {
    final result = await Navigator.push<bool>(
      context,
      CupertinoPageRoute(builder: (_) => const AddProductScreen()),
    );
    // Reload regardless — handles both true and cases where result is null
    // (e.g. user pops via back-swipe after a successful add).
    if (result == true && mounted) {
      await _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.groupedBackground,
      child: CustomScrollView(
        slivers: [
          // navbar
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Daftar Produk'),
            backgroundColor: AppColors.groupedBackground,
            border: null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Submit tugas
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: _showSubmitDialog,
                  child: const Icon(
                    CupertinoIcons.arrow_up_doc,
                    size: 22,
                    color: AppColors.primary,
                  ),
                ),
                // Add product
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: _goToAddProduct,
                  child: const Icon(
                    CupertinoIcons.add_circled_solid,
                    size: 26,
                    color: AppColors.primary,
                  ),
                ),
                // Logout
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: () async {
                    await ApiService.deleteToken();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.square_arrow_right,
                    size: 22,
                    color: AppColors.destructive,
                  ),
                ),
              ],
            ),
          ),
          // Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Cari produk…',
                backgroundColor: AppColors.secondaryGroupedBackground,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

          // Content
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator(radius: 14)),
            )
          else if (_filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.cube_box,
                      size: 56,
                      color: AppColors.tertiaryLabel,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _products.isEmpty
                          ? 'Belum ada produk.\nTambahkan produk pertamamu!'
                          : 'Tidak ada produk yang cocok.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subhead.copyWith(
                        color: AppColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            CupertinoSliverRefreshControl(onRefresh: _loadProducts),

          if (!_isLoading && _filtered.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCardWidget(
                    product: _filtered[index],
                    onDelete: () => _confirmDelete(
                      _filtered[index].id,
                      _filtered[index].name,
                    ),
                    isFirst: index == 0,
                    isLast: index == _filtered.length - 1,
                  ),
                  childCount: _filtered.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }
}
