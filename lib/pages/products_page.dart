import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import '../services/analytics.dart';

class ProductsPage extends StatefulWidget {
  final String curlType;
  const ProductsPage({super.key, required this.curlType});
  @override State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _category = 'all';
  bool _filterByType = true;
  Product? _selected;

  static const _cats = [('all','✨ 전체'),('shampoo','🧴 샴푸'),('treatment','💆 트리트먼트'),('curlcream','🌀 컬 크림')];

  List<Product> get _filtered => products.where((p) {
    final catOk = _category == 'all' || p.category == _category;
    final typeOk = !_filterByType || p.types.contains(widget.curlType);
    return catOk && typeOk;
  }).toList();

  @override
  Widget build(BuildContext context) {
    if (_selected != null) {
      return _ProductDetailPage(product: _selected!, curlType: widget.curlType, onBack: () => setState(() => _selected = null));
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
                decoration: BoxDecoration(color: _filterByType ? AppColors.peach : AppColors.border, borderRadius: BorderRadius.circular(20)),
                child: Text(_filterByType ? '✓ ${widget.curlType} 맞춤' : '전체 보기',
                  style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: _filterByType ? Colors.white : AppColors.brownMid)),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(height: 44, child: ListView.separated(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _cats.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final (id, label) = _cats[i];
            final active = _category == id;
            return GestureDetector(
              onTap: () => setState(() => _category = id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.peach : Colors.white, borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x123D2B1F), blurRadius: 4, offset: Offset(0,1))]),
                child: Text(label, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.brownMid)),
              ),
            );
          },
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
          child: Row(children: [
            Text('${_filtered.length}개의 제품', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
            if (_filterByType) ...[const SizedBox(width: 6), Text('· ${widget.curlType} 맞춤', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.peach, fontWeight: FontWeight.w600))],
          ]),
        ),
        Expanded(
          child: _filtered.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('🔍', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('해당 조건의 제품이 없어요', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownMid)),
              ]))
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _ProductCard(product: _filtered[i], onTap: () {
              GA.event('product_viewed', {'product_name': _filtered[i].name, 'product_brand': _filtered[i].brand});
              setState(() => _selected = _filtered[i]);
            }),
              ),
        ),
      ]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product; final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, height: 90,
          decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(product.img, style: const TextStyle(fontSize: 40)))),
        const SizedBox(height: 8),
        Text(product.brand, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownLight)),
        const SizedBox(height: 2),
        Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brown, height: 1.3)),
        const SizedBox(height: 4),
        StarRating(product.rating),
        const SizedBox(height: 4),
        Wrap(spacing: 4, runSpacing: 4,
          children: product.tags.take(2).map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
            child: Text('#$t', style: GoogleFonts.notoSansKr(fontSize: 9, color: AppColors.peachDark)))).toList()),
        const Spacer(),
        Text(product.price, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.peach)),
      ]),
    ),
  );
}

// ── Product Detail with Tabs ──────────────────────────────────────────────
class _ProductDetailPage extends StatefulWidget {
  final Product product; final String curlType; final VoidCallback onBack;
  const _ProductDetailPage({required this.product, required this.curlType, required this.onBack});
  @override State<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<_ProductDetailPage> with SingleTickerProviderStateMixin {
  bool _liked = false;
  late TabController _tab;
  @override void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) return;
      final tabName = _tab.index == 0 ? 'ingredients' : 'reviews';
      GA.event('product_tab_switched', {'tab': tabName, 'product_name': widget.product.name});
    });
  }
  @override void dispose() { _tab.dispose(); super.dispose(); }

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
            icon: Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: _liked ? AppColors.type4 : AppColors.brownLight),
            onPressed: () => setState(() => _liked = !_liked)),
        ],
      ),
      body: Column(children: [
        // ── Top info (always visible) ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Image + basic info row
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(16)),
                child: Center(child: Text(p.img, style: const TextStyle(fontSize: 52)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (isMatch)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(8)),
                    child: Text('${widget.curlType} 유형 추천', style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.tealDark))),
                Text(p.brand, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
                const SizedBox(height: 2),
                Text(p.name, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.brown, height: 1.3)),
                const SizedBox(height: 6),
                Row(children: [
                  StarRating(p.rating, size: 14),
                  const SizedBox(width: 4),
                  Text('(${p.reviewCount})', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
                ]),
                const SizedBox(height: 8),
                // Price + buy button
                Row(children: [
                  Text(p.price, style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.peach)),
                  const SizedBox(width: 10),
                  Expanded(child: SizedBox(height: 34,
                    child: ElevatedButton(
                      onPressed: () => GA.event('product_purchase_clicked', {'product_name': p.name}),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('구매 링크', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  )),
                ]),
              ])),
            ]),
            const SizedBox(height: 12),
          ]),
        ),

        // ── Tabs ──
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tab,
            labelColor: AppColors.peach,
            unselectedLabelColor: AppColors.brownLight,
            indicatorColor: AppColors.peach,
            indicatorWeight: 2.5,
            labelStyle: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700),
            unselectedLabelStyle: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w500),
            tabs: const [Tab(text: '상세/성분'), Tab(text: '리뷰')],
          ),
        ),

        Expanded(
          child: TabBarView(controller: _tab, children: [
            _IngredientDetailTab(product: p, curlType: widget.curlType),
            _ReviewTab(product: p),
          ]),
        ),
      ]),
    );
  }
}

// ── 상세/성분 탭: 성분 먼저, 그 다음 상세 ──────────────────────────────────
class _IngredientDetailTab extends StatelessWidget {
  final Product product; final String curlType;
  const _IngredientDetailTab({required this.product, required this.curlType});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // 성분 먼저
      Text('주요 성분', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
      const SizedBox(height: 10),
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _IngredientRow('수분 공급', '히알루론산, 알로에베라', Icons.water_drop_rounded, AppColors.teal),
        const Divider(color: AppColors.surface),
        _IngredientRow('단백질 강화', '케라틴, 실크아미노산', Icons.fitness_center_rounded, AppColors.peach),
        const Divider(color: AppColors.surface),
        _IngredientRow('컬 정의', '글리세린, 판테놀', Icons.auto_awesome_rounded, AppColors.green),
        const Divider(color: AppColors.surface),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('전성분: 정제수, 세틸알코올, 히알루론산나트륨, 케라틴, 실크아미노산, 글리세린, 판테놀, 향료, 방부제...',
            style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight, height: 1.5)),
        ),
      ])),
      const SizedBox(height: 20),

      // 그 다음 상세 정보
      Text('제품 설명', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
      const SizedBox(height: 8),
      Text(product.desc, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.7)),
      const SizedBox(height: 16),
      Text('태그', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: product.tags.map((t) => TagChip(t)).toList()),
      const SizedBox(height: 16),
      Text('맞는 곱슬 유형', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8,
        children: product.types.map((t) {
          final isMe = t == curlType;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: isMe ? AppColors.peach : AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Text(t, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: isMe ? Colors.white : AppColors.brownMid)));
        }).toList()),
    ]),
  );
}

// ── 리뷰 탭 ─────────────────────────────────────────────────────────────────
class _ReviewTab extends StatelessWidget {
  final Product product;
  const _ReviewTab({required this.product});

  static const _sampleReviews = [
    ('수진이', '3B', 4.5, '진짜 대박이에요! 습도가 높아도 컬이 무너지지 않아요. 재구매 예정입니다 ✨'),
    ('곱슬요정', '2C', 4.0, '냄새가 좋고 사용감이 부드러워요. 다만 가격이 좀 세긴 해요.'),
    ('컬리걸', '3C', 5.0, '이 제품 없이 어떻게 살았나 싶어요. 제 구원템 등극!'),
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppCard(child: Column(children: [
        Row(children: [
          Column(children: [
            Text(product.rating.toStringAsFixed(1), style: GoogleFonts.notoSansKr(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.brown)),
            Row(children: List.generate(5, (i) => Icon(i < product.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: AppColors.star))),
            Text('${product.reviewCount}개 리뷰', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
          ]),
          const SizedBox(width: 20),
          Expanded(child: Column(children: List.generate(5, (i) {
            final star = 5 - i;
            final ratio = star == product.rating.round() ? 0.6 : (star == product.rating.round() - 1 ? 0.25 : 0.1);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                Text('$star', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
                const SizedBox(width: 6),
                Expanded(child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: ratio, minHeight: 6, backgroundColor: AppColors.surface, color: AppColors.star),
                )),
              ]),
            );
          }))),
        ]),
      ])),
      const SizedBox(height: 16),
      Text('최신 리뷰', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
      const SizedBox(height: 10),
      ..._sampleReviews.map((r) {
        final (author, type, rating, content) = r;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
                child: Center(child: Text(author[0], style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.peachDark)))),
              const SizedBox(width: 8),
              Text(author, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
              const SizedBox(width: 6),
              CurlTypeBadge(type),
              const Spacer(),
              StarRating(rating, size: 13),
            ]),
            const SizedBox(height: 8),
            Text(content, style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid, height: 1.5)),
          ])),
        );
      }),
    ]),
  );
}

class _IngredientRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _IngredientRow(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: color)),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.brown)),
        Text(value, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
      ]),
    ]),
  );
}
