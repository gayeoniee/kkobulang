import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';
import 'pages/products_page.dart';
import 'pages/diary_page.dart';
import 'pages/community_page.dart';
import 'pages/profile_page.dart';

class KkobulangApp extends StatelessWidget {
  const KkobulangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '꼬불랑',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final width = MediaQuery.of(context).size.width;
        if (width <= 768) return child!;
        return Container(
          color: const Color(0xFFE8DDD4),
          child: Center(
            child: SizedBox(
              width: 390,
              child: ClipRect(child: child!),
            ),
          ),
        );
      },
      home: const _Root(),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  String? _curlType;
  int _tab = 0;
  bool _showTutorial = false;
  int _tutorialStep = 0;

  void _onComplete(String type) {
    setState(() {
      _curlType = type;
      _tab = 0;
      _showTutorial = true;
      _tutorialStep = 0;
    });
  }

  void _nextTutorial() {
    if (_tutorialStep < 4) {
      setState(() {
        _tutorialStep++;
        _tab = _tutorialStep;
      });
    } else {
      setState(() {
        _showTutorial = false;
        _tab = 0;
      });
    }
  }

  void _prevTutorial() {
    if (_tutorialStep > 0) {
      setState(() {
        _tutorialStep--;
        _tab = _tutorialStep;
      });
    }
  }

  void _skipTutorial() => setState(() { _showTutorial = false; _tab = 0; });

  @override
  Widget build(BuildContext context) {
    if (_curlType == null) {
      return OnboardingPage(onComplete: _onComplete);
    }

    final pages = [
      HomePage(curlType: _curlType!, onNavigate: (i) => setState(() => _tab = i)),
      ProductsPage(curlType: _curlType!),
      const DiaryPage(),
      CommunityPage(curlType: _curlType!),
      ProfilePage(
        curlType: _curlType!,
        onChangeCurlType: (t) => setState(() => _curlType = t),
      ),
    ];

    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(index: _tab, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tab,
            onTap: _showTutorial ? null : (i) => setState(() => _tab = i),
            items: [
              BottomNavigationBarItem(
                icon: Icon(_tab == 0 ? Icons.home_rounded : Icons.home_outlined),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(_tab == 1 ? Icons.grid_view_rounded : Icons.grid_view_outlined),
                label: '제품',
              ),
              BottomNavigationBarItem(
                icon: Icon(_tab == 2 ? Icons.book_rounded : Icons.book_outlined),
                label: '다이어리',
              ),
              BottomNavigationBarItem(
                icon: Icon(_tab == 3 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline_rounded),
                label: '커뮤니티',
              ),
              BottomNavigationBarItem(
                icon: Icon(_tab == 4 ? Icons.person_rounded : Icons.person_outline_rounded),
                label: '프로필',
              ),
            ],
          ),
        ),
        if (_showTutorial)
          _TutorialOverlay(
            step: _tutorialStep,
            onNext: _nextTutorial,
            onPrev: _prevTutorial,
            onSkip: _skipTutorial,
          ),
      ],
    );
  }
}

// ── Tutorial Overlay ──────────────────────────────────────────────────────
const _tutorialSteps = [
  (
    tab: 0,
    icon: '🏠',
    title: '홈',
    desc: '내 곱슬 유형 프로필, 날씨 팁, 추천 루틴과 제품을 한눈에 확인할 수 있어요!',
  ),
  (
    tab: 1,
    icon: '🛍',
    title: '제품 탭',
    desc: '내 유형에 맞는 헤어 제품을 탐색하고 성분과 리뷰를 확인해보세요!',
  ),
  (
    tab: 2,
    icon: '📓',
    title: '헤어 다이어리',
    desc: '매일의 헤어 루틴을 기록하고 계절별 변화를 추적할 수 있어요!',
  ),
  (
    tab: 3,
    icon: '💬',
    title: '커뮤니티',
    desc: '다른 곱슬 친구들과 케어 팁, 제품 후기, 미용실 정보를 나눠요!',
  ),
  (
    tab: 4,
    icon: '🌿',
    title: '프로필',
    desc: '내 정보를 관리하고 곱슬 유형을 언제든 다시 확인하거나 변경할 수 있어요!',
  ),
];

class _TutorialOverlay extends StatelessWidget {
  final int step;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onSkip;
  const _TutorialOverlay({required this.step, required this.onNext, required this.onPrev, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final s = _tutorialSteps[step];
    final isLast = step == _tutorialSteps.length - 1;
    final isFirst = step == 0;
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final screenW = mq.size.width;
    final safeBottom = mq.padding.bottom;
    // 실제 네비바 높이 + safe area
    const navBarContentH = kBottomNavigationBarHeight; // 56
    final totalNavH = navBarContentH + safeBottom;
    // 아이콘은 safe area 위 navBar 영역 중앙
    final navItemY = screenH - safeBottom - navBarContentH / 2;
    // 웹에서 390px 제한 시 실제 콘텐츠 폭과 오프셋 계산
    final effectiveW = screenW > 768 ? 390.0 : screenW;
    final offsetX = screenW > 768 ? (screenW - 390) / 2 : 0.0;
    final itemW = effectiveW / 5;
    final navItemX = offsetX + itemW * step + itemW / 2;

    return Stack(
      children: [
        // 어두운 배경
        Positioned.fill(
          child: GestureDetector(
            onTap: () {}, // 터치 차단
            child: CustomPaint(
              painter: _SpotlightPainter(
                navItemX: navItemX,
                navItemY: navItemY,
                radius: 34,
              ),
            ),
          ),
        ),
        // 말풍선 카드 (네비바 위에 위치)
        Positioned(
          left: 16, right: 16,
          bottom: totalNavH + 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 카드
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(s.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Text(s.title,
                      style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
                    const Spacer(),
                    GestureDetector(
                      onTap: onSkip,
                      child: Text('건너뛰기',
                        style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Text(s.desc,
                    style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.55)),
                  const SizedBox(height: 16),
                  Row(children: [
                    // 스텝 인디케이터
                    Row(children: List.generate(_tutorialSteps.length, (i) => Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: i == step ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == step ? AppColors.peach : AppColors.surface,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ))),
                    const Spacer(),
                    if (!isFirst) ...[
                      OutlinedButton(
                        onPressed: onPrev,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.peach),
                          foregroundColor: AppColors.peach,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('← 이전',
                          style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.peach,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(isLast ? '시작하기 🌿' : '다음 →',
                        style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ]),
                ]),
              ),
              // 아래 삼각형 화살표
              CustomPaint(
                size: const Size(24, 10),
                painter: _ArrowPainter(
                  xOffset: (navItemX - 16).clamp(8.0, screenW - 60),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final double navItemX, navItemY, radius;
  const _SpotlightPainter({required this.navItemX, required this.navItemY, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.65);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(Rect.fromCircle(center: Offset(navItemX, navItemY), radius: radius));
    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // 글로우 링
    final glowPaint = Paint()
      ..color = AppColors.peach.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(Offset(navItemX, navItemY), radius + 5, glowPaint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      old.navItemX != navItemX || old.navItemY != navItemY;
}

class _ArrowPainter extends CustomPainter {
  final double xOffset;
  const _ArrowPainter({required this.xOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => false;
}
