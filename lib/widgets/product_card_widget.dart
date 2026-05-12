import 'package:flutter/cupertino.dart';
import 'package:prctaskone/models/product_model.dart';
import 'package:prctaskone/theme/app_theme.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;
  final bool isFirst;
  final bool isLast;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onDelete,
    this.isFirst = false,
    this.isLast = false,
  });

  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(AppRadius.card);
    final borderRadius = BorderRadius.only(
      topLeft: isFirst ? radius : Radius.zero,
      topRight: isFirst ? radius : Radius.zero,
      bottomLeft: isLast ? radius : Radius.zero,
      bottomRight: isLast ? radius : Radius.zero,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryGroupedBackground,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.cube_box_fill,
                    size: 26,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                          color: AppColors.label,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatPrice(product.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: AppTextStyles.footnote,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                
                // delete
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: onDelete,
                  child: const Icon(
                    CupertinoIcons.delete,
                    size: 20,
                    color: AppColors.destructive,
                  ),
                ),
              ],
            ),
          ),

          if (!isLast)
            AppDivider(leftIndent: 84),
        ],
      ),
    );
  }
}
