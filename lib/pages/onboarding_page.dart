import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';

class OnboardingPage extends StatefulWidget {
  final void Function(String curlType) onComplete;
  const OnboardingPage({super.key, required this.onComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0; // 0=splash, 1=welcome, 2=curlSelect
  String? _selected;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _step = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: switch (_step) {
          0 => _SplashScreen(key: const ValueKey('splash')),
          1 => _WelcomeScreen(key: const ValueKey('welcome'), onNext: () => setState(() => _step = 2)),
          _ => _CurlSelectScreen(
              key: const ValueKey('select'),
              selected: _selected,
              onSelect: (id) => setState(() => _selected = id),
              onComplete: () { if (_selected != null) widget.onComplete(_selected!); },
            ),
        },
      ),
    );
  }
}

// ─────────── Splash ───────────
class _SplashScreen extends StatefulWidget {
  const _SplashScreen({super.key});
  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.cream, AppColors.peachLight],
        ),
      ),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ScaleTransition(
            scale: _scale,
            child: Image.asset('assets/logo.png', width: 160, height: 160, fit: BoxFit.contain),
          ),
          const SizedBox(height: 12),
          Text('꼬불랑', style: GoogleFonts.notoSansKr(
            fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(height: 4),
          Text('내 곱슬에 맞는 케어를 찾아봐요',
            style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
          const SizedBox(height: 36),
          _DotRow(),
        ]),
      ),
    );
  }
}

class _DotRow extends StatefulWidget {
  @override
  State<_DotRow> createState() => _DotRowState();
}
class _DotRowState extends State<_DotRow> with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;
  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(3, (i) => AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
      lowerBound: 1.0, upperBound: 1.4,
    )..repeat(reverse: true, period: Duration(milliseconds: 500 + i * 150)));
  }
  @override
  void dispose() { for (final c in _ctrls) c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
      AnimatedBuilder(
        animation: _ctrls[i],
        builder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Container(
            width: 8 * _ctrls[i].value, height: 8 * _ctrls[i].value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == 0 ? AppColors.peach : AppColors.border,
            ),
          ),
        ),
      )
    ));
  }
}

// ─────────── Welcome ───────────
class _WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final features = ['💧 내 곱슬 유형에 맞는 제품 추천', '📓 헤어 케어 일지 기록', '🌿 같은 고민 친구들과 소통'];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.cream, AppColors.peachLight, AppColors.tealLight],
          stops: [0, 0.6, 1],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(children: [
            const SizedBox(height: 48),
            Image.asset('assets/logo.png', width: 130, height: 130, fit: BoxFit.contain),
            const SizedBox(height: 20),
            Text('안녕하세요! 👋\n꼬불랑에 오신 걸 환영해요',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.brown, height: 1.4)),
            const SizedBox(height: 16),
            Text('한국 곱슬머리를 위한\n케어 정보와 커뮤니티 공간이에요.\n나만의 루틴을 찾아봐요 🌸',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(fontSize: 15, color: AppColors.brownMid, height: 1.7)),
            const SizedBox(height: 32),
            ...features.map((f) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Text(f, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brown)),
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onNext, child: const Text('시작하기 →')),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }
}

// ─────────── Curl Type Select ───────────
class _CurlSelectScreen extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;
  final VoidCallback onComplete;
  const _CurlSelectScreen({super.key, required this.selected, required this.onSelect, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('내 곱슬 유형은?',
                style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.brown)),
              const SizedBox(height: 6),
              Text('모발 상태에 가장 가까운 유형을 선택해주세요.\n나중에 언제든지 변경할 수 있어요.',
                style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid, height: 1.6)),
            ]),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [2, 3, 4].map((cat) {
              final catTypes = curlTypes.where((t) => t.category == cat).toList();
              final catLabel = {2:'웨이비 (2형)', 3:'컬리 (3형)', 4:'코일리 (4형)'}[cat]!;
              final catColor = AppColors.curlTypeColor('${cat}A');
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(color: catColor, shape: BoxShape.circle),
                    child: Center(child: Text('$cat',
                      style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white))),
                  ),
                  const SizedBox(width: 8),
                  Text(catLabel, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brown)),
                ]),
                const SizedBox(height: 10),
                ...catTypes.map((type) => _CurlTypeCard(
                  type: type,
                  isSelected: selected == type.id,
                  onTap: () => onSelect(type.id),
                )),
              ]);
            }).toList()),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selected != null ? onComplete : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: AppColors.brownLight.withOpacity(0.3),
                disabledForegroundColor: Colors.white,
              ),
              child: Text(selected != null ? '$selected 유형으로 시작하기 ✨' : '유형을 선택해주세요'),
            ),
          ),
        ),
      ]),
    );
  }
}

class _CurlTypeCard extends StatelessWidget {
  final CurlType type;
  final bool isSelected;
  final VoidCallback onTap;
  const _CurlTypeCard({required this.type, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.curlTypeColor(type.id);
    final bg = AppColors.curlTypeBg(type.id);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? bg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
          boxShadow: const [BoxShadow(color: Color(0x123D2B1F), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(type.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(type.id, style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.brown)),
              const SizedBox(width: 6),
              Text(type.title, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid)),
            ]),
            const SizedBox(height: 2),
            Text(type.desc,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight, height: 1.4)),
          ])),
          if (isSelected)
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
        ]),
      ),
    );
  }
}
