import 'package:flutter/material.dart';
import 'package:prctaskone/models/product_model.dart';
import 'package:prctaskone/screens/login_screens.dart';
import 'package:prctaskone/services/api_service.dart';
import 'package:prctaskone/widgets/product_card_widget.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    _products = await ApiService.getProducts();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _deleteProduct(int id) async {
    final success = await ApiService.deleteProduct(id);
    if (success) {
      _loadProducts();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus')));
    }
  }

  Future<void> _showSubmitDialog() async {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final githubCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          'Submit Tugas',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              _buildDialogTextField(controller: nameCtrl, label: 'Nama Produk'),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: priceCtrl,
                label: 'Harga',
                isNumber: true,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(controller: descCtrl, label: 'Deskripsi'),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: githubCtrl,
                label: 'GitHub URL',
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text(
              'Batal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7EC8C8),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final requestModel = SubmitTugasModel(
                name: nameCtrl.text,
                price: int.tryParse(priceCtrl.text) ?? 0,
                description: descCtrl.text,
                githubUrl: githubCtrl.text,
              );

              final success = await ApiService.submitTugas(requestModel);

              if (!mounted) return;
              Navigator.pop(ctx);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Tugas berhasil disubmit!'
                        : 'Gagal submit. Cek data.',
                  ),
                  backgroundColor: success ? Colors.green : Colors.redAccent,
                ),
              );
            },
            child: const Text(
              'Submit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7EC8C8), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7EC8C8),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Katalog Produk',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            tooltip: 'Submit Tugas',
            onPressed: _showSubmitDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ApiService.deleteToken();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7EC8C8)),
            )
          : _products.isEmpty
          ? const Center(
              child: Text(
                'Belum ada produk.\nTambahkan produk pertamamu!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF7EC8C8),
              onRefresh: _loadProducts,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 80),
                itemCount: _products.length,
                itemBuilder: (ctx, i) => ProductCardWidget(
                  product: _products[i],
                  onDelete: () => _deleteProduct(_products[i].id),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7EC8C8),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
          _loadProducts();
        },
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
