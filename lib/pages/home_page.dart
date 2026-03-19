import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../models/diagnosis_history.dart';
import '../widgets/common_widgets.dart';
import '../widgets/diagnosis_widgets.dart';
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
      builder: (_) => const ImageAnalysisModal(),
    );
  }

  void _showTypeHistory(BuildContext context) {
    GA.event('type_history_opened', {'source': 'home'});
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => const TypeHistoryModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeInfo = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    final typeColor = AppColors.curlTypeColor(curlType);
    final recProducts = products.where((p) => p.types.contains(curlType)).take(5).toList();
    final latestDiary = diaryEntries.isNotEmpty ? diaryEntries.first : null;

    return CustomScrollView(slivers: [
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
                    Text('꼬불이', style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.brown)),
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
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Text('📖 꼬불랑 입문가이드', style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
              const SizedBox(height: 4),
              Text('곱슬 케어 첫 걸음을 함께해요', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(controller: controller, padding: const EdgeInsets.fromLTRB(16, 0, 16, 32), children: [
              _GuideSection(
                emoji: '📊', title: '한국인의 곱슬머리 현황',
                color: AppColors.peachLight,
                child: _guideText(
                  '한국인 2명 중 1명(53%)은 곱슬머리예요!\n\n'
                  '유전적 곱슬: 25%\n후천적 곱슬(노화·손상 등): 28%\n\n'
                  '타고나지 않아도 곱슬이 되는 경우가 많답니다. 내 머리가 왜 곱슬인지 알면 관리도 달라져요!',
                ),
              ),
              _GuideSection(
                emoji: '🌀', title: '곱슬머리 유형 분류 (4가지 타입)',
                color: const Color(0xFFE8F5E9),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _typeRow('타입 1', '직모 (Straight)', '컬이 전혀 없이 일자로 쭉 뻗은 생머리예요.'),
                  _typeRow('타입 2', '웨이브 (Wavy)', 'S자 완만한 곡선 형태예요. 2A(느슨함)→2C(뚜렷함)로 갈수록 컬이 강해져요.'),
                  _typeRow('타입 3', '컬리 (Curly)', '나선형 코르크 모양이에요. 3A→3C(연필 굵기)로 갈수록 촘촘해져요.'),
                  _typeRow('타입 4', '코일리 (Coily)', '지그재그·촘촘한 용수철 모양이에요. 한국인에게는 드문 유형이에요.'),
                ]),
              ),
              _GuideSection(
                emoji: '💚', title: 'CGM(Curly Girl Method)이란?',
                color: AppColors.tealLight,
                child: _guideText(
                  'CGM은 곱슬머리를 억지로 펴지 않고, 수분을 듬뿍 주어 본연의 예쁜 컬을 살리는 관리법이에요.\n\n'
                  '곱슬은 고쳐야 할 대상이 아니라, 소중히 가꿔야 할 나의 개성이에요! 🌿',
                ),
              ),
              _GuideSection(
                emoji: '🚫✅', title: 'CGM 기본 규칙',
                color: const Color(0xFFFFF3E0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _ruleRow('🚫', '열 기구', '고데기와 뜨거운 바람은 컬을 파괴해요'),
                  _ruleRow('🚫', '마른 빗질', '컬이 풀리고 사자머리처럼 부스스해져요'),
                  _ruleRow('🚫', '일반 수건', '표면이 거칠어 컬을 망쳐요 → 티셔츠·극세사 타월 권장'),
                  const Divider(height: 20),
                  _ruleRow('✅', '순한 세정', '코워시나 로우푸 샴푸를 사용해요'),
                  _ruleRow('✅', '젖은 상태 관리', '모든 관리는 머리가 젖었을 때 해야 컬이 잘 잡혀요'),
                  _ruleRow('✅', '수분 꽉 잡기', '리브인 컨디셔너와 젤로 수분을 가둬줘요'),
                ]),
              ),
              _GuideSection(
                emoji: '5️⃣', title: '실전! CGM 5단계 루틴',
                color: const Color(0xFFF3E5F5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _stepRow('1', '세정', '설페이트 프리 샴푸나 코워시로 두피를 1분간 꼼꼼히 마사지하며 씻어요.'),
                  _stepRow('2', '영양·보습', '컨디셔너를 듬뿍 바르고 손가락으로 엉킨 머리를 풀어준 뒤 스퀴시(움켜쥐기)를 반복해요.'),
                  _stepRow('3', '스타일링', '머리가 뚝뚝 젖은 상태에서 젤이나 컬 크림을 아래→위로 움켜쥐듯 발라요.'),
                  _stepRow('4', '건조', '플로핑(면 티셔츠로 감싸기) 후 찬바람으로 말려요. 마른 머리에 빗질은 절대 금지!'),
                  _stepRow('5', '마무리', '다 마른 후 굳은 젤 막을 손으로 살살 주물러 깨주면 부드러운 컬 완성!'),
                ]),
              ),
              _GuideSection(
                emoji: '🧴', title: '성분 가이드: 내 머리에 맞게 고르기',
                color: const Color(0xFFE3F2FD),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _ingredientRow('🫧 설페이트 계열\n(SLS, SLES)', '세정력이 강력해요. 기름기는 잘 빠지지만 곱슬머리를 건조하게 만들 수 있어요.'),
                  _ingredientRow('🌿 설페이트-프리', '순하고 완만해요. 수분을 잘 지켜주지만 지성 두피엔 덜 씻긴 느낌이 들 수 있어요.'),
                  _ingredientRow('⚡ 휘발성 알코올\n(에탄올 등)', '빨리 마르게 도와주지만 모발 수분을 함께 앗아갈 수 있어요.'),
                  _ingredientRow('💧 보습형 알코올\n(세틸, 세테아릴)', '우리가 아는 알코올과 달라요! 모발을 부드럽게 코팅하고 수분을 가둬요.'),
                  _ingredientRow('✨ 실리콘 (디메치콘)', '즉각적인 윤기를 줘요. 계속 쌓이면(빌드업) 수분·영양이 들어가는 길을 막을 수 있어요.'),
                  _ingredientRow('💦 수분 성분\n(글리세린, 히알루론산)', '주변 수분을 끌어당겨 촉촉하게 해요. 습도가 높은 날엔 머리가 더 부풀 수도 있어요.'),
                  _ingredientRow('🧬 단백질 성분\n(케라틴, 콜라겐)', '모발 빈틈을 채워 탄탄하게 만들어요. 손상 모발에 효과적이지만 과하면 뻣뻣해져요.'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '💡 건조한 머리라면 → 보습형 알코올 + 설페이트-프리\n손상이 심하다면 → 단백질 성분 제품을 눈여겨보세요!',
                      style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.tealDark, height: 1.55),
                    ),
                  ),
                ]),
              ),
              _GuideSection(
                emoji: '📚', title: '곱슬 전문 용어집',
                color: const Color(0xFFFCE4EC),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _glossaryRow('코워시 (Co-wash)', '샴푸 대신 컨디셔너만으로 머리를 감는 세정법이에요.'),
                  _glossaryRow('로우푸 (Low-poo)', '거품을 내는 강한 성분(설페이트)이 없는 순한 샴푸를 쓰는 방법이에요.'),
                  _glossaryRow('리셋 워시 (Reset Wash)', 'CGM 시작 전, 쌓인 실리콘을 제거하기 위해 마지막으로 강한 샴푸를 쓰는 단계예요.'),
                  _glossaryRow('리브인 (Leave-in)', '감은 후 씻어내지 않고 두어 수분을 유지하는 컨디셔너예요.'),
                  _glossaryRow('LOC / LCO 메서드', '리브인(L) → 오일(O) → 크림(C) 순서로 겹겹이 수분을 가두는 방법이에요. LCO는 순서를 달리 해 더 촉촉하게 마무리해요.'),
                  _glossaryRow('플로핑 (Plopping)', '수건 대신 면 티셔츠로 머리를 감싸 컬 모양을 잡으며 말리는 방법이에요.'),
                  _glossaryRow('스퀴시 투 컨디쉬\n(Squish to Condish)', '컨디셔너를 바른 후 손으로 컬을 꽉꽉 움켜쥐어 수분을 밀어 넣는 기술이에요.'),
                  _glossaryRow('공극률 (Porosity)', '모발이 수분을 흡수하고 내보내는 능력이에요.\n• 높음(손상): 구멍이 많아 수분이 금방 빠져요 → 단백질 팩 추천\n• 낮음(건강): 구멍이 적어 수분이 잘 안 들어요 → 가벼운 수분 제품 추천'),
                  _glossaryRow('빌드업 (Build-up)', '실리콘·왁스 등이 모발에 쌓이는 현상이에요. 리셋 워시로 제거해요.'),
                  _glossaryRow('딥 컨디셔닝 (DC)', '일반 컨디셔너보다 농도가 높은 팩을 사용해 집중 보습·영양을 공급하는 것이에요.'),
                  _glossaryRow('프리즈 (Frizz)', '습기나 건조로 인해 머리카락이 부스스하게 일어나는 현상이에요.'),
                  _glossaryRow('젤 캐스트 (Gel Cast)', '젤이 건조되면서 머리카락을 딱딱하게 감싸는 막이에요. 다 마른 후 손으로 깨주면 컬이 살아나요.'),
                  _glossaryRow('스크런칭 (Scrunching)', '제품을 바를 때나 말릴 때 머리를 아래에서 위로 움켜쥐어 컬을 잡는 동작이에요.'),
                  _glossaryRow('디퓨저 (Diffuser)', '드라이어에 부착하는 넓은 바람 분산 장치예요. 컬을 살리면서 빠르게 말릴 수 있어요.'),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _guideText(String text) => Text(text, style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid, height: 1.65));

  Widget _typeRow(String code, String name, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(6)),
        child: Text(code, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
        const SizedBox(height: 2),
        Text(desc, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.5)),
      ])),
    ]),
  );

  Widget _ruleRow(String icon, String title, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(icon, style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 8),
      Expanded(child: RichText(text: TextSpan(children: [
        TextSpan(text: '$title  ', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
        TextSpan(text: desc, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid)),
      ]))),
    ]),
  );

  Widget _stepRow(String num, String title, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 24, height: 24,
        decoration: const BoxDecoration(color: AppColors.peach, shape: BoxShape.circle),
        child: Center(child: Text(num, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white))),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
        const SizedBox(height: 2),
        Text(desc, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.5)),
      ])),
    ]),
  );

  Widget _ingredientRow(String name, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(name, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
      const SizedBox(height: 2),
      Text(desc, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.5)),
    ]),
  );

  Widget _glossaryRow(String term, String def) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 6, height: 6, margin: const EdgeInsets.only(top: 6, right: 8),
        decoration: const BoxDecoration(color: AppColors.peach, shape: BoxShape.circle),
      ),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(term, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
        const SizedBox(height: 2),
        Text(def, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.55)),
      ])),
    ]),
  );
}

class _GuideSection extends StatelessWidget {
  final String emoji, title;
  final Color color;
  final Widget child;
  const _GuideSection({required this.emoji, required this.title, required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
    ),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      iconColor: AppColors.brown,
      collapsedIconColor: AppColors.brownLight,
      title: Text('$emoji  $title', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brown)),
      children: [child],
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
    author: '꼬불이',
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
