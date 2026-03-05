import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class ProductsPage extends StatefulWidget {
  final String curlType;
  const ProductsPage({super.key, required this.curlType});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _category = 'all';
  bool _filterByType = true;
  Product? _selected;

  static const _categories = [
    ('all', '✨ 전체'), ('shampoo', '🧴 샴푸'), ('treatment', '💆 트리트먼트'), ('curlcream', '🌀 컬 크림'),
  ];

  List<Product> get _filtered => products.where((p) {
    final catOk = _category == 'all' || p.category == _category;
    final typeOk = !_filterByType || p.types.contains(widget.curlType);
    return catOk && typeOk;
  }).toList();

  @override
  Widget build(BuildContext context) {
    if (_selected != null) {
      return _ProductDetailPage(
        product: _selected!,
        curlType: widget.curlType,
        onBack: () => setState(() => _selected = null),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('제품 추천'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _filterByType = !_filterByType),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _filterByType ? AppColors.peach : AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _filterByType ? '✓ ${widget.curlType} 맞춤' : '전체 보기',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: _filterByType ? Colors.white : AppColors.brownMid),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        // Category tabs
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final (id, label) = _categories[i];
              final isActive = _category == id;
              return GestureDetector(
                onTap: () => setState(() => _category = id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.peach : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Color(0x123D2B1F), blurRadius: 4, offset: Offset(0, 1))],
                  ),
                  child: Text(label,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.brownMid)),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(children: [
            Text('${_filtered.length}개의 제품',
              style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
            if (_filterByType) ...[
              const SizedBox(width: 6),
              Text('· ${widget.curlType} 유형 맞춤',
                style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.peach, fontWeight: FontWeight.w600)),
            ],
          ]),
        ),
        Expanded(
          child: _filtered.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('🔍', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('해당 조건의 제품이 없어요',
                  style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownMid)),
              ]))
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _ProductCard(
                  product: _filtered[i],
                  onTap: () => setState(() => _selected = _filtered[i]),
                ),
              ),
        ),
      ]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, height: 90,
            decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(product.img, style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(height: 8),
          Text(product.brand, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownLight)),
          const SizedBox(height: 2),
          Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brown, height: 1.3)),
          const SizedBox(height: 5),
          StarRating(product.rating),
          const SizedBox(height: 5),
          Wrap(spacing: 4, runSpacing: 4,
            children: product.tags.take(2).map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
              child: Text('#$t', style: GoogleFonts.notoSansKr(fontSize: 9, color: AppColors.peachDark)),
            )).toList()),
          const Spacer(),
          Text(product.price,
            style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.peach)),
        ]),
      ),
    );
  }
}

class _ProductDetailPage extends StatefulWidget {
  final Product product;
  final String curlType;
  final VoidCallback onBack;
  const _ProductDetailPage({required this.product, required this.curlType, required this.onBack});
  @override
  State<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<_ProductDetailPage> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isMatch = p.types.contains(widget.curlType);
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: widget.onBack),
        actions: [
          IconButton(
            icon: Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _liked ? AppColors.type4 : AppColors.brownLight),
            onPressed: () => setState(() => _liked = !_liked),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.peachLight, AppColors.cream]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text(p.img, style: const TextStyle(fontSize: 80))),
          ),
          const SizedBox(height: 16),
          if (isMatch)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('✅', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text('${widget.curlType} 유형에 추천하는 제품이에요!',
                  style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.tealDark, fontWeight: FontWeight.w600)),
              ]),
            ),
          Text(p.brand, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
          const SizedBox(height: 4),
          Text(p.name, style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(height: 8),
          Row(children: [
            StarRating(p.rating, size: 16),
            const SizedBox(width: 8),
            Text('(${p.reviewCount}개 리뷰)',
              style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
          ]),
          const SizedBox(height: 10),
          Text(p.price, style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.peach)),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          Text('제품 설명', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 8),
          Text(p.desc, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.7)),
          const SizedBox(height: 16),
          Text('태그', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8,
            children: p.tags.map((t) => TagChip(t)).toList()),
          const SizedBox(height: 16),
          Text('맞는 곱슬 유형', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8,
            children: p.types.map((t) {
              final isMe = t == widget.curlType;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.peach : AppColors.surface,
                  borderRadius: BorderRadius.circular(20)),
                child: Text(t, style: GoogleFonts.notoSansKr(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: isMe ? Colors.white : AppColors.brownMid)),
              );
            }).toList()),
          const SizedBox(height: 28),
          buildPrimaryButton('구매 링크 보기 →', () {}),
        ]),
      ),
    );
  }
}
