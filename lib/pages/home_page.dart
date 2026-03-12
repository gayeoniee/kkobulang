import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import '../services/analytics.dart';

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

  void _showGuideModal(BuildContext context) {
    GA.event('guide_modal_opened');
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _GuideModal(),
    );
  }

  void _showAllRoutines(BuildContext context) {
    GA.event('routines_all_viewed');
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => const _AllRoutinesModal(),
    );
  }

  void _showAllProducts(BuildContext context, List<Product> recProducts) {
    GA.event('products_all_viewed');
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _AllProductsModal(curlType: curlType, recProducts: recProducts),
    );
  }

  void _showImageAnalysis(BuildContext context) {
    GA.event('image_analysis_opened', {'source': 'home'});
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _ImageAnalysisModal(),
    );
  }

  void _showTypeHistory(BuildContext context) {
    GA.event('type_history_opened', {'source': 'home'});
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _TypeHistoryModal(curlType: curlType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeInfo = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    final typeColor = AppColors.curlTypeColor(curlType);
    final recProducts = products.where((p) => p.types.contains(curlType)).take(5).toList();
    final latestDiary = diaryEntries.isNotEmpty ? diaryEntries.first : null;

    return CustomScrollView(slivers: [
      SliverAppBar(
        floating: true,
        title: Image.asset('assets/kkobulang_logo.png', height: 30, fit: BoxFit.contain),
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
                // 이미지 분석 + 이력 버튼
                Row(mainAxisSize: MainAxisSize.min, children: [
                  _SmallIconBtn(icon: Icons.camera_alt_rounded, label: '이미지분석', onTap: () => _showImageAnalysis(context)),
                  const SizedBox(width: 6),
                  _SmallIconBtn(icon: Icons.history_rounded, label: '진단이력', onTap: () => _showTypeHistory(context)),
                ]),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Text('🌡️', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Expanded(child: Text(_weatherTip(),
                    style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.tealDark, fontWeight: FontWeight.w600))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── 꼬불랑 입문가이드 ──
          GestureDetector(
            onTap: () => _showGuideModal(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.teal, AppColors.tealDark]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                const Text('📖', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('꼬불랑 입문가이드', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('곱슬 케어 처음이라면? 여기서 시작해요', style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.white.withOpacity(0.85))),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
              ]),
            ),
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

          // ── 추천 루틴 ──
          SectionHeader('✨ 추천 루틴', onSeeAll: () => _showAllRoutines(context)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sampleRoutines.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _RoutineCard(routine: _sampleRoutines[i]),
            ),
          ),
          const SizedBox(height: 24),

          // ── 추천 제품 ──
          SectionHeader('🛍 나에게 맞는 제품', onSeeAll: () => _showAllProducts(context, recProducts)),
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
        ])),
      ),
    ]);
  }
}

// ── 작은 아이콘 버튼 ─────────────────────────────────────────────────────────
class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: AppColors.teal),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center,
          style: GoogleFonts.notoSansKr(fontSize: 8, color: AppColors.tealDark, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

// ── 꼬불랑 입문가이드 모달 ───────────────────────────────────────────────────
class _GuideModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppBottomSheet(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('📖 꼬불랑 입문가이드', style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
        const SizedBox(height: 6),
        Text('곱슬 케어 첫 걸음을 함께해요', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, height: 200,
          decoration: BoxDecoration(
            color: AppColors.tealLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🌿', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('콘텐츠 준비 중이에요!', style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.tealDark)),
            const SizedBox(height: 6),
            Text('곧 꼼꼼한 입문 가이드로\n찾아올게요 🙌', textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.teal, height: 1.5)),
          ]),
        ),
        const SizedBox(height: 20),
        buildPrimaryButton('닫기', () => Navigator.pop(context)),
      ]),
    ),
  );
}

// ── 이미지 분석 모달 ─────────────────────────────────────────────────────────
class _ImageAnalysisModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppBottomSheet(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('📷 이미지로 유형 분석', style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
        const SizedBox(height: 6),
        Text('머리 사진으로 곱슬 유형을 분석해요', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, height: 180,
          decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🔬', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('준비 중이에요!', style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.peachDark)),
            const SizedBox(height: 6),
            Text('AI 이미지 분석 기능이\n곧 출시될 예정이에요', textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid)),
          ]),
        ),
        const SizedBox(height: 20),
        buildPrimaryButton('닫기', () => Navigator.pop(context)),
      ]),
    ),
  );
}

// ── 유형진단 이력 모달 ──────────────────────────────────────────────────────
class _TypeHistoryModal extends StatelessWidget {
  final String curlType;
  const _TypeHistoryModal({required this.curlType});
  @override
  Widget build(BuildContext context) {
    final typeInfo = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    final typeColor = AppColors.curlTypeColor(curlType);
    return AppBottomSheet(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('📋 유형 진단 이력', style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(height: 16),
          _HistoryItem(date: '2026.03.11', typeId: curlType, title: typeInfo.title, color: typeColor, isCurrent: true),
          _HistoryItem(date: '2025.11.03', typeId: '3A', title: '느슨한 컬', color: AppColors.curlTypeColor('3A'), isCurrent: false),
          _HistoryItem(date: '2025.06.15', typeId: '2C', title: '굵은 웨이브', color: AppColors.curlTypeColor('2C'), isCurrent: false),
          const SizedBox(height: 16),
          buildPrimaryButton('닫기', () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date, typeId, title;
  final Color color;
  final bool isCurrent;
  const _HistoryItem({required this.date, required this.typeId, required this.title, required this.color, required this.isCurrent});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent ? color.withOpacity(0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? color.withOpacity(0.4) : Colors.transparent, width: 1.5),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Text(typeId, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid))),
        if (isCurrent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Text('현재', style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
          )
        else
          Text(date, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
      ]),
    ),
  );
}

// ── 전체 루틴 모달 ──────────────────────────────────────────────────────────
class _AllRoutinesModal extends StatelessWidget {
  const _AllRoutinesModal();
  @override
  Widget build(BuildContext context) => AppBottomSheet(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('✨ 추천 루틴 전체보기', style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.brown)),
        const SizedBox(height: 14),
        SizedBox(
          height: 380,
          child: ListView.separated(
            itemCount: _sampleRoutines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _RoutineListCard(routine: _sampleRoutines[i]),
          ),
        ),
      ]),
    ),
  );
}

class _RoutineListCard extends StatelessWidget {
  final ({String author, String avatar, String curlType, String name, List<String> steps, String tip}) routine;
  const _RoutineListCard({required this.routine});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 6, offset: Offset(0,2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 26, height: 26, decoration: const BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
          child: Center(child: Text(routine.avatar, style: const TextStyle(fontSize: 13)))),
        const SizedBox(width: 6),
        Text(routine.author, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.brown)),
        const SizedBox(width: 6),
        CurlTypeBadge(routine.curlType),
      ]),
      const SizedBox(height: 6),
      Text(routine.name, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.brown)),
      const SizedBox(height: 6),
      Wrap(spacing: 4, runSpacing: 4, children: [
        for (int i = 0; i < routine.steps.length; i++) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(20)),
            child: Text(routine.steps[i], style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.tealDark)),
          ),
          if (i < routine.steps.length - 1)
            const Padding(padding: EdgeInsets.symmetric(vertical: 3), child: Text('→', style: TextStyle(fontSize: 10, color: AppColors.brownLight))),
        ],
      ]),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('💡', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Expanded(child: Text(routine.tip, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownMid, height: 1.4))),
        ]),
      ),
    ]),
  );
}

// ── 전체 제품 모달 ──────────────────────────────────────────────────────────
class _AllProductsModal extends StatelessWidget {
  final String curlType;
  final List<Product> recProducts;
  const _AllProductsModal({required this.curlType, required this.recProducts});
  @override
  Widget build(BuildContext context) => AppBottomSheet(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🛍 $curlType 맞춤 제품 전체보기', style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.brown)),
        const SizedBox(height: 4),
        Text('${recProducts.length}개 제품', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
        const SizedBox(height: 14),
        SizedBox(
          height: 400,
          child: ListView.separated(
            itemCount: recProducts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final p = recProducts[i];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 6, offset: Offset(0,2))]),
                child: Row(children: [
                  Container(width: 56, height: 56,
                    decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(p.img, style: const TextStyle(fontSize: 28)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.brand, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownLight)),
                    Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brown)),
                    const SizedBox(height: 4),
                    Row(children: [
                      StarRating(p.rating, size: 12),
                      const SizedBox(width: 6),
                      Text(p.price, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.peach)),
                    ]),
                  ])),
                ]),
              );
            },
          ),
        ),
      ]),
    ),
  );
}

// ── Diary preview cards ──────────────────────────────────────────────────
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

// ── 추천 루틴 데이터 ──
const _sampleRoutines = [
  (
    author: '수진이',
    avatar: '🌸',
    curlType: '3B',
    name: 'LOC 딥케어 루틴',
    steps: ['샴푸', '딥컨디셔닝', '리브인컨디셔너', '컬크림', '디퓨저건조'],
    tip: '컨디셔너를 5분 이상 두면 훨씬 촉촉해요!',
  ),
  (
    author: '컬리걸서울',
    avatar: '🍥',
    curlType: '3C',
    name: 'CGM 기본 루틴',
    steps: ['저자극샴푸', '컨디셔너', '스쿼시', '젤', '플롭건조'],
    tip: '설페이트프리 샴푸로 바꾸면 컬이 살아나요',
  ),
  (
    author: '진지한웨이비',
    avatar: '🌊',
    curlType: '2C',
    name: '웨이비 간단 루틴',
    steps: ['샴푸', '컨디셔너', '무스', '자연건조'],
    tip: '무거운 제품은 피하고 가볍게 마무리!',
  ),
  (
    author: '새벽곱슬',
    avatar: '⚡',
    curlType: '4B',
    name: '트위스트아웃 루틴',
    steps: ['공샴', '딥컨디셔닝', '리브인', '버터', '트위스트', '새틴나이트캡'],
    tip: '밤에 해두면 아침에 컬이 예쁘게 펴져요',
  ),
];

class _RoutineCard extends StatelessWidget {
  final ({String author, String avatar, String curlType, String name, List<String> steps, String tip}) routine;
  const _RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(color: AppColors.peachLight, shape: BoxShape.circle),
            child: Center(child: Text(routine.avatar, style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 6),
          Text(routine.author, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(width: 6),
          CurlTypeBadge(routine.curlType),
        ]),
        const SizedBox(height: 8),
        Text(routine.name, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.brown)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4, runSpacing: 4,
          children: [
            for (int i = 0; i < routine.steps.length; i++) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(20)),
                child: Text(routine.steps[i],
                  style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.tealDark)),
              ),
              if (i < routine.steps.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text('→', style: TextStyle(fontSize: 10, color: AppColors.brownLight)),
                ),
            ],
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('💡', style: TextStyle(fontSize: 11)),
            const SizedBox(width: 4),
            Expanded(child: Text(routine.tip,
              style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownMid, height: 1.4))),
          ]),
        ),
      ]),
    );
  }
}
