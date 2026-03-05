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

  static String _weatherTip() {
    final m = DateTime.now().month;
    if (m >= 6 && m <= 8) return '☀️ 고온다습한 날씨 · 가벼운 젤로 컬을 잡으세요';
    if (m >= 9 && m <= 11) return '🍂 건조한 가을 바람 · 딥컨디셔닝으로 보습 챙기세요';
    if (m == 12 || m <= 2) return '❄️ 정전기 주의 · 오일 세럼으로 마무리하세요';
    return '🌸 봄철 황사 · 외출 전 안티프리즈 세럼을 챙기세요';
  }

  @override
  Widget build(BuildContext context) {
    final typeInfo = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    final typeColor = AppColors.curlTypeColor(curlType);
    final recProducts = products.where((p) => p.types.contains(curlType)).take(5).toList();
    final recentPosts = communityPosts.take(3).toList();
    final latestDiary = diaryEntries.isNotEmpty ? diaryEntries.first : null;

    return CustomScrollView(slivers: [
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

          // ── Profile Card ──
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Avatar
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: typeColor.withOpacity(0.15),
                    border: Border.all(color: typeColor, width: 2.5),
                  ),
                  child: Center(child: Text(typeInfo.emoji, style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('수진이', style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.brown)),
                    const SizedBox(width: 8),
                    // Grade badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Text('🌿', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 2),
                        Text('새싹', style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.green)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  CurlTypeBadge(curlType, large: true),
                ])),
              ]),
              const SizedBox(height: 12),
              // Weather tip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.tealLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const Text('🌡️', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Expanded(child: Text(_weatherTip(),
                    style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.tealDark, fontWeight: FontWeight.w600))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── 헤어 다이어리 Section ──
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('📓 헤어 다이어리', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
            GestureDetector(
              onTap: () => onNavigate(2),
              child: Text('전체보기', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal)),
            ),
          ]),
          const SizedBox(height: 10),
          if (latestDiary == null)
            _EmptyDiaryCard(onTap: () => onNavigate(2))
          else
            _DiaryPreviewCard(entry: latestDiary, onTap: () => onNavigate(2)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => onNavigate(2),
              icon: const Icon(Icons.edit_rounded, size: 16, color: AppColors.teal),
              label: Text('오늘 루틴 기록하기', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.teal)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.teal, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── 추천 제품 ──
          SectionHeader('🛍 나에게 맞는 제품', onSeeAll: () => onNavigate(1)),
          const SizedBox(height: 12),
          SizedBox(
            height: 185,
            child: recProducts.isEmpty
              ? Center(child: Text('등록된 추천 제품이 없어요.', style: GoogleFonts.notoSansKr(color: AppColors.brownLight, fontSize: 13)))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _ProductMiniCard(product: recProducts[i]),
                ),
          ),
          const SizedBox(height: 24),

          // ── 커뮤니티 ──
          SectionHeader('💬 커뮤니티 최신 글', onSeeAll: () => onNavigate(3)),
          const SizedBox(height: 12),
          ...recentPosts.map((post) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MiniPostCard(post: post),
          )),
        ])),
      ),
    ]);
  }
}

class _EmptyDiaryCard extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyDiaryCard({required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.tealLight, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.teal.withOpacity(0.3), style: BorderStyle.solid),
      ),
      child: Row(children: [
        const Text('📓', style: TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('아직 기록이 없어요', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.tealDark)),
          Text('첫 번째 루틴을 기록해봐요!', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.teal)),
        ]),
      ]),
    ),
  );
}

class _DiaryPreviewCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  const _DiaryPreviewCard({required this.entry, required this.onTap});

  static const _resultEmojis = ['😞', '😕', '😐', '😊', '🥰'];

  @override
  Widget build(BuildContext context) {
    final emoji = _resultEmojis[(entry.result - 1).clamp(0, 4)];
    final dateStr = '${entry.date.month}월 ${entry.date.day}일';
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(dateStr, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
              const SizedBox(width: 8),
              Text('$emoji ${entry.result}/5', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.peach)),
            ]),
            const SizedBox(height: 6),
            Text(entry.memo, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brown, height: 1.4)),
            const SizedBox(height: 6),
            Wrap(spacing: 6, children: entry.routine.take(3).map((r) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Text(r, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownMid)),
            )).toList()),
          ])),
          if (entry.hasPhoto) ...[
            const SizedBox(width: 12),
            Container(
              width: 60, height: 60, decoration: BoxDecoration(
                color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text('📸', style: TextStyle(fontSize: 24))),
            ),
          ],
        ]),
      ),
    );
  }
}

class _ProductMiniCard extends StatelessWidget {
  final Product product;
  const _ProductMiniCard({required this.product});
  @override
  Widget build(BuildContext context) => Container(
    width: 140, padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(height: 72, width: double.infinity,
        decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(product.img, style: const TextStyle(fontSize: 34)))),
      const SizedBox(height: 8),
      Text(product.brand, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownLight)),
      const SizedBox(height: 2),
      Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
        style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brown)),
      const Spacer(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        StarRating(product.rating, size: 12),
        Text(product.price, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.peach)),
      ]),
    ]),
  );
}

class _MiniPostCard extends StatelessWidget {
  final CommunityPost post;
  const _MiniPostCard({required this.post});
  @override
  Widget build(BuildContext context) {
    final postTypes = {'notice':'📢','guide':'📖','salon':'💈','tip':'💡','product':'🛍','help':'🙏'};
    return AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(postTypes[post.postType] ?? '💬', style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Container(width: 34, height: 34,
          decoration: BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
          child: Center(child: Text(post.avatar, style: const TextStyle(fontSize: 18)))),
        const SizedBox(width: 6),
        Expanded(child: Row(children: [
          Text(post.author, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(width: 6),
          if (post.curlType.isNotEmpty) CurlTypeBadge(post.curlType),
        ])),
        Text(post.time, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
      ]),
      const SizedBox(height: 8),
      if (post.title.isNotEmpty)
        Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
      const SizedBox(height: 2),
      Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis,
        style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.4)),
      const SizedBox(height: 6),
      Row(children: [
        Text('❤️ ${post.likes}', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        const SizedBox(width: 10),
        Text('💬 ${post.comments}', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
      ]),
    ]));
  }
}
