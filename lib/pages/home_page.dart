import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  final String curlType;
  final void Function(int) onNavigate;
  const HomePage({super.key, required this.curlType, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final typeInfo = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    final recProducts = products.where((p) => p.types.contains(curlType)).take(5).toList();
    final recentPosts = communityPosts.take(3).toList();
    final typeColor = AppColors.curlTypeColor(curlType);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Image.asset('assets/logo.png', height: 32, fit: BoxFit.contain),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([

            // ── Welcome Banner ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.peach, const Color(0xFFF4C4A0), AppColors.teal],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('내 곱슬 유형', style: GoogleFonts.notoSansKr(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.24), borderRadius: BorderRadius.circular(10)),
                    child: Text(typeInfo.id,
                      style: GoogleFonts.notoSansKr(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
                  ),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(typeInfo.title, style: GoogleFonts.notoSansKr(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                    Text('맞춤 추천 준비됐어요 ✨',
                      style: GoogleFonts.notoSansKr(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                  ]),
                ]),
                const SizedBox(height: 12),
                Wrap(spacing: 6, runSpacing: 6,
                  children: typeInfo.tips.map((tip) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text('💡 $tip',
                      style: GoogleFonts.notoSansKr(color: Colors.white, fontSize: 11)),
                  )).toList()),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Quick Actions ──
            Row(children: [
              _QuickAction(icon: '💧', label: '제품 추천', bg: AppColors.peachLight, color: AppColors.peachDark, onTap: () => onNavigate(1)),
              const SizedBox(width: 10),
              _QuickAction(icon: '📓', label: '일지 쓰기', bg: AppColors.tealLight, color: AppColors.tealDark, onTap: () => onNavigate(2)),
              const SizedBox(width: 10),
              _QuickAction(icon: '🌿', label: '커뮤니티', bg: AppColors.greenLight, color: const Color(0xFF4A9E44), onTap: () => onNavigate(3)),
              const SizedBox(width: 10),
              _QuickAction(icon: '👤', label: '프로필', bg: AppColors.type4Bg, color: AppColors.type4, onTap: () => onNavigate(4)),
            ]),
            const SizedBox(height: 24),

            // ── Recommended Products ──
            SectionHeader('🛍 나에게 맞는 제품', onSeeAll: () => onNavigate(1)),
            const SizedBox(height: 12),
            SizedBox(
              height: 185,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recProducts.isEmpty ? 1 : recProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  if (recProducts.isEmpty) {
                    return Text('등록된 추천 제품이 없어요.',
                      style: GoogleFonts.notoSansKr(color: AppColors.brownLight, fontSize: 13));
                  }
                  return _ProductMiniCard(product: recProducts[i]);
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Community Highlights ──
            SectionHeader('💬 커뮤니티 최신 글', onSeeAll: () => onNavigate(3)),
            const SizedBox(height: 12),
            ...recentPosts.map((post) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MiniPostCard(post: post),
            )),
            const SizedBox(height: 8),

            // ── CTA Banner ──
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.tealLight, Color(0xFFB8E8E3)]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('오늘 루틴 기록했나요?',
                    style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.tealDark)),
                  const SizedBox(height: 2),
                  Text('일지를 쓰면 내 패턴을 발견할 수 있어요',
                    style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.teal)),
                ])),
                ElevatedButton(
                  onPressed: () => onNavigate(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                  child: Text('기록하기 ✏️',
                    style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ]),
            ),
          ])),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String icon, label;
  final Color bg, color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.bg, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    ),
  );
}

class _ProductMiniCard extends StatelessWidget {
  final Product product;
  const _ProductMiniCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 72, width: double.infinity,
          decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(product.img, style: const TextStyle(fontSize: 34))),
        ),
        const SizedBox(height: 8),
        Text(product.brand, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownLight)),
        const SizedBox(height: 2),
        Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brown)),
        const Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          StarRating(product.rating, size: 12),
          Text(product.price,
            style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.peach)),
        ]),
      ]),
    );
  }
}

class _MiniPostCard extends StatelessWidget {
  final CommunityPost post;
  const _MiniPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final typeColor = AppColors.curlTypeColor(post.curlType);
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
            child: Center(child: Text(post.avatar, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 8),
          Expanded(child: Row(children: [
            Text(post.author, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
            const SizedBox(width: 6),
            CurlTypeBadge(post.curlType),
          ])),
          Text(post.time, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        ]),
        const SizedBox(height: 8),
        Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brown, height: 1.5)),
        const SizedBox(height: 8),
        Row(children: [
          Text('❤️ ${post.likes}', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
          const SizedBox(width: 12),
          Text('💬 ${post.comments}', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
        ]),
      ]),
    );
  }
}
