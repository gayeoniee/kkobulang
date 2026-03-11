import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';

// ── Survey question model ──────────────────────────────────────────────────
class _Q {
  final String stage, question;
  final List<_Opt> options;
  final bool multi;
  final int? maxSel;
  final String? description;
  const _Q(this.stage, this.question, this.options, {this.multi = false, this.maxSel, this.description});
}
class _Opt {
  final String id, label, emoji;
  final String? sub;
  const _Opt(this.id, this.label, this.emoji, {this.sub});
}

// 8 survey questions (Q6 탄력성 제거됨)
final _questions = [
  _Q('단계 1 · 시각적 분류', '샴푸 후 제품 없이 자연 건조했을 때,\n내 머리카락은 어떤 모습인가요?', [
    _Opt('2A','느슨한 웨이브','〰️', sub:'거의 직선에 가깝고 살짝 굴곡'),
    _Opt('2B','중간 웨이브','🌊', sub:'뚜렷한 S자 웨이브'),
    _Opt('2C','굵은 웨이브','🌀', sub:'굵은 S자, 습도에 민감'),
    _Opt('3A','느슨한 컬','🫧', sub:'큰 링글렛 컬'),
    _Opt('3B','탄탄한 컬','🍥', sub:'중간 나선형 컬'),
    _Opt('3C','타이트 컬','🌿', sub:'코르크스크류 나선형'),
    _Opt('4A','촘촘한 코일','🌸', sub:'촘촘한 S자 코일'),
    _Opt('4B','Z패턴 코일','⚡', sub:'Z자 꺾임 타이트 코일'),
    _Opt('4C','극도의 코일','✨', sub:'패턴 없는 촘촘한 코일'),
  ]),
  _Q('단계 1 · 시각적 분류', '머리카락의 굴곡이 시작되는 지점은\n어디인가요?', [
    _Opt('root','뿌리부터 바로 구불거림','⬆️'),
    _Opt('mid','눈 높이 정도부터 시작됨','👁️'),
    _Opt('end','끝부분만 살짝 휘어짐','⬇️'),
    _Opt('unknown','모르겠음','🤷'),
  ]),
  _Q('단계 1 · 시각적 분류', '마른 상태에서 브러시질을 하면\n어떻게 되나요?', [
    _Opt('neat','차분하게 정돈됨','✅'),
    _Opt('puff','약간 부풀어 오름','💨'),
    _Opt('lion','사자 갈기처럼 엄청나게 부풀어 오름','🦁'),
    _Opt('unknown','모르겠음','🤷'),
  ]),
  _Q('단계 2 · 물리적 특성', '[다공성 진단] 마른 머리에 물을 뿌렸을 때\n어떻게 반응하나요?', [
    _Opt('low','표면에 송골송골 맺혀 한참 뒤에 흡수됨','🔴', sub:'저다공성'),
    _Opt('mid','잠시 맺혔다가 천천히 스며듦','🟡', sub:'중다공성'),
    _Opt('high','뿌리자마자 즉시 스며들어 흔적이 사라짐','🟢', sub:'고다공성'),
    _Opt('unknown','모르겠음','🤷'),
  ],
  description: '공극률이란? 모발 공극률은 머리카락 표면의 덮개(큐티클)가 얼마나 벌어져 있는지에 따라 수분을 빨아들이고 내뱉는 정도를 말해요.'),
  _Q('단계 2 · 물리적 특성', '[굵기 진단] 머리카락 한 가닥을\n손가락 사이에 굴렸을 때 느낌은?', [
    _Opt('fine','거의 느껴지지 않거나 매우 가늚','🪶', sub:'Fine'),
    _Opt('medium','실처럼 적당히 느껴짐','🧵', sub:'Medium'),
    _Opt('coarse','치실처럼 뚜렷하게 느껴짐','🪢', sub:'Coarse'),
    _Opt('unknown','모르겠음','🤷'),
  ]),
  _Q('단계 3 · 과거 이력', '최근 2년 동안 받은 시술을\n모두 선택해 주세요.', [
    _Opt('magic','매직 스트레이트','💈'),
    _Opt('bleach','탈색','⚗️'),
    _Opt('dye','전체 염색','🎨'),
    _Opt('perm','디지털 펌','🔌'),
    _Opt('none','없음','🙅'),
  ], multi: true),
  _Q('단계 4 · 관리 목표', '관리 후 어떤 결과를 가장 원하시나요?\n(최대 2개 선택)', [
    _Opt('frizz','부스스함 제거','✨'),
    _Opt('definition','컬의 선명함 강화','🌀'),
    _Opt('volume','머리숱 많아 보이기','💇'),
    _Opt('tangle','엉킴 해결','🪥'),
    _Opt('shine','윤기 부여','💎'),
    _Opt('unknown','모르겠음','🤷'),
  ], multi: true, maxSel: 2),
  _Q('단계 4 · 관리 목표', '스타일링 제품이 마른 후의 느낌은\n어떤 것을 선호하시나요?', [
    _Opt('soft','바른 듯 안 바른 듯 부드러운 느낌','☁️', sub:'Soft Hold'),
    _Opt('medium','모양이 흐트러지지 않는 적당한 고정력','🌿', sub:'Medium Hold'),
    _Opt('strong','딱딱하더라도 컬이 하루 종일 유지','🔒', sub:'Strong Hold'),
    _Opt('unknown','모르겠음','🤷'),
  ]),
];

// ── Main widget ───────────────────────────────────────────────────────────
class OnboardingPage extends StatefulWidget {
  final void Function(String curlType) onComplete;
  const OnboardingPage({super.key, required this.onComplete});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // 0=splash, 1=welcome, 2=gender, 3-10=survey Q0-Q7, 11=result
  int _step = 0;
  final Map<int, dynamic> _ans = {};
  String? _gender;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _step = 1);
    });
  }

  String get _curlType => (_ans[0] as String?) ?? '3B';

  void _next() {
    if (_step < 10) {
      setState(() => _step++);
    } else {
      setState(() => _step = 11);
    }
  }

  bool _canProceed() {
    if (_step <= 2) return true;
    final qi = _step - 3;
    if (qi < 0 || qi >= _questions.length) return true;
    final ans = _ans[qi];
    if (ans == null) return false;
    if (ans is List) return (ans as List).isNotEmpty;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: switch (_step) {
          0 => const _SplashScreen(key: ValueKey('splash')),
          1 => _WelcomeScreen(key: const ValueKey('welcome'), onNext: () => setState(() => _step = 2)),
          2 => _GenderScreen(key: const ValueKey('gender'), onSelect: (g) { setState(() { _gender = g; _step = 3; }); }),
          11 => _ResultScreen(key: const ValueKey('result'), curlType: _curlType, answers: _ans, onComplete: widget.onComplete),
          _ => _SurveyScreen(
              key: ValueKey(_step),
              question: _questions[_step - 3],
              qIndex: _step - 3,
              totalQ: _questions.length,
              answer: _ans[_step - 3],
              canProceed: _canProceed(),
              gender: _gender,
              onAnswer: (val) => setState(() => _ans[_step - 3] = val),
              onNext: _canProceed() ? _next : null,
              onBack: () => setState(() => _step--),
            ),
        },
      ),
    );
  }
}

// ── Splash ────────────────────────────────────────────────────────────────
class _SplashScreen extends StatefulWidget {
  const _SplashScreen({super.key});
  @override State<_SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<_SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800)); _s = CurvedAnimation(parent: _c, curve: Curves.elasticOut); _c.forward(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.cream, AppColors.peachLight])),
    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      ScaleTransition(
        scale: _s,
        child: Image.asset('assets/kkobulang_logo.png', width: 200),
      ),
      const SizedBox(height: 16),
      Text('내 곱슬에 맞는 케어를 찾아봐요', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid)),
    ])),
  );
}

// ── Welcome ───────────────────────────────────────────────────────────────
class _WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final blocks = [
      ('💧', '유형별\n제품 추천'),
      ('📓', '헤어\n다이어리'),
      ('🌿', '곱슬 친구\n커뮤니티'),
    ];
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [AppColors.cream, AppColors.peachLight, AppColors.tealLight], stops: [0, 0.55, 1])),
      child: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
        child: Column(children: [
          const SizedBox(height: 16),
          Image.asset('assets/kkobulang_logo.png', width: 160),
          const SizedBox(height: 20),
          Text('한국 곱슬머리를 위한\n케어 정보와 커뮤니티 공간이에요',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.65)),
          const SizedBox(height: 28),
          Row(children: blocks.map((b) {
            final (icon, label) = b;
            return Expanded(child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Color(0x183D2B1F), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(icon, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.brownMid, height: 1.4)),
              ]),
            ));
          }).toList()),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.peach,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: AppColors.peach.withOpacity(0.5),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('유형 분석 시작하기', style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ]),
            ),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    );
  }
}

// ── Gender Selection ──────────────────────────────────────────────────────
class _GenderScreen extends StatelessWidget {
  final void Function(String) onSelect;
  const _GenderScreen({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [AppColors.cream, AppColors.peachLight])),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
        child: Column(children: [
          const SizedBox(height: 40),
          Image.asset('assets/kkobulang_logo.png', width: 120),
          const SizedBox(height: 32),
          Text('어떤 분이세요?',
            style: GoogleFonts.notoSansKr(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(height: 8),
          Text('맞춤형 케어 정보를 제공해드릴게요',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid)),
          const SizedBox(height: 48),
          Row(children: [
            _GenderCard('female', '여자', '💁‍♀️', '꼬불랑 언니', onSelect),
            const SizedBox(width: 16),
            _GenderCard('male', '남자', '💁‍♂️', '꼬불랑 형', onSelect),
          ]),
          const Spacer(),
          Text('나중에 프로필에서 변경할 수 있어요',
            style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        ]),
      ),
    ),
  );
}

class _GenderCard extends StatelessWidget {
  final String value, label, emoji, sub;
  final void Function(String) onSelect;
  const _GenderCard(this.value, this.label, this.emoji, this.sub, this.onSelect);

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x183D2B1F), blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text(label, style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
        ]),
      ),
    ),
  );
}

// ── Survey Screen ─────────────────────────────────────────────────────────
class _SurveyScreen extends StatelessWidget {
  final _Q question;
  final int qIndex, totalQ;
  final dynamic answer;
  final bool canProceed;
  final String? gender;
  final void Function(dynamic) onAnswer;
  final VoidCallback? onNext, onBack;
  const _SurveyScreen({super.key, required this.question, required this.qIndex, required this.totalQ, required this.answer, required this.canProceed, this.gender, required this.onAnswer, this.onNext, this.onBack});

  bool _isSelected(String id) {
    if (answer == null) return false;
    if (answer is List) return (answer as List).contains(id);
    return answer == id;
  }

  void _toggle(String id) {
    if (question.multi) {
      final list = List<String>.from(answer ?? []);
      if (list.contains(id)) {
        list.remove(id);
      } else {
        if (question.maxSel != null && list.length >= question.maxSel!) return;
        if (id == 'none' || id == 'unknown') { onAnswer([id]); return; }
        list.remove('none');
        list.remove('unknown');
        list.add(id);
      }
      onAnswer(list);
    } else {
      onAnswer(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (qIndex + 1) / totalQ;
    final isQ1 = qIndex == 0;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(children: [
        SafeArea(bottom: false, child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              GestureDetector(onTap: onBack, child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.brownMid, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress, minHeight: 6,
                  backgroundColor: AppColors.surface,
                  color: AppColors.peach,
                ),
              )),
              const SizedBox(width: 12),
              Text('${qIndex + 1}/$totalQ', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight, fontWeight: FontWeight.w600)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(question.stage, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.peach, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(question.question, style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown, height: 1.4)),
              if (question.multi) ...[
                const SizedBox(height: 4),
                Text(question.maxSel != null ? '최대 ${question.maxSel}개 선택 가능' : '여러 개 선택 가능',
                  style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
              ],
              if (question.description != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(10)),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('💡 ', style: TextStyle(fontSize: 11)),
                    Expanded(child: Text(question.description!,
                      style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.tealDark, height: 1.5))),
                  ]),
                ),
              ],
            ]),
          ),
        ])),
        Expanded(
          child: isQ1
            ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.55),
                itemCount: question.options.length,
                itemBuilder: (_, i) => _Q1Card(opt: question.options[i], selected: _isSelected(question.options[i].id), gender: gender, onTap: () => _toggle(question.options[i].id)),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                itemCount: question.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _OptionTile(opt: question.options[i], selected: _isSelected(question.options[i].id), onTap: () => _toggle(question.options[i].id)),
              ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                disabledBackgroundColor: AppColors.brownLight.withOpacity(0.25),
                disabledForegroundColor: Colors.white,
              ),
              child: Text(qIndex < totalQ - 1 ? '다음으로 →' : '결과 보기 ✨',
                style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Q1Card extends StatelessWidget {
  final _Opt opt;
  final bool selected;
  final String? gender;
  final VoidCallback onTap;
  const _Q1Card({required this.opt, required this.selected, this.gender, required this.onTap});

  String? get _imagePath {
    final prefix = (gender == 'male') ? 'm' : 'f';
    final typeKey = opt.id.toLowerCase(); // e.g. '3b'
    return 'assets/$prefix$typeKey.png';
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.curlTypeColor(opt.id);
    final bg = AppColors.curlTypeBg(opt.id);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? bg : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color : Colors.transparent, width: 2.5),
          boxShadow: [BoxShadow(color: selected ? color.withOpacity(0.2) : const Color(0x123D2B1F), blurRadius: selected ? 10 : 6, offset: const Offset(0, 2))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            _imagePath!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => SizedBox(
              height: 150,
              child: Center(child: Text(opt.emoji, style: const TextStyle(fontSize: 30))),
            ),
          ),
          const SizedBox(height: 4),
          Text(opt.id, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w800, color: selected ? color : AppColors.brown)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(opt.label.replaceFirst('${opt.id} ', ''), textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(fontSize: 8, color: AppColors.brownMid, height: 1.3)),
          ),
          if (selected) Icon(Icons.check_circle_rounded, color: color, size: 13),
          const SizedBox(height: 4),
        ]),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final _Opt opt;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.opt, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.peachLight : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? AppColors.peach : Colors.transparent, width: 2),
        boxShadow: const [BoxShadow(color: Color(0x123D2B1F), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(children: [
        Text(opt.emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(opt.label, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.brown)),
          if (opt.sub != null) Text(opt.sub!, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        ])),
        if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.peach, size: 22),
      ]),
    ),
  );
}

// ── Result Screen ─────────────────────────────────────────────────────────
class _ResultScreen extends StatelessWidget {
  final String curlType;
  final Map<int, dynamic> answers;
  final void Function(String) onComplete;
  const _ResultScreen({super.key, required this.curlType, required this.answers, required this.onComplete});

  String _porosityLabel() {
    return switch (answers[3] as String? ?? 'mid') {
      'low' => '저다공성',
      'high' => '고다공성',
      _ => '중다공성',
    };
  }
  String _thicknessLabel() => switch (answers[4] as String? ?? 'medium') {
    'fine' => '가는 모발',
    'coarse' => '굵은 모발',
    _ => '보통 굵기',
  };
  String _careApproach() {
    final p = answers[3] as String? ?? 'mid';
    if (p == 'low') return '저다공성 모발은 열로 큐티클을 열어야 해요. 따뜻한 물로 헹구고 스팀 트리트먼트를 추천해요.';
    if (p == 'high') return '고다공성 모발엔 단백질+보습 레이어링이 핵심이에요. LCO 방법으로 수분을 잡아주세요.';
    return 'LOC 방법(리브인→오일→크림)으로 수분을 층층이 쌓아보세요. 주 1~2회 딥컨디셔닝도 필수예요.';
  }

  @override
  Widget build(BuildContext context) {
    final info = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    final typeColor = AppColors.curlTypeColor(curlType);
    final typeBg = AppColors.curlTypeBg(curlType);
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(children: [
          // Hero
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 24, 24, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [typeColor.withValues(alpha: 0.85), typeColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(children: [
              Text('이 유형에 가까워요', style: GoogleFonts.notoSansKr(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text(info.emoji, style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 8),
              Text(info.id, style: GoogleFonts.notoSansKr(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
              Text(info.title, style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                child: Text(info.desc, textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(fontSize: 13, color: Colors.white, height: 1.5)),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Profile chips
              Text('내 모발 프로필', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
              const SizedBox(height: 10),
              Row(children: [
                _ProfileChip(_porosityLabel(), Icons.water_drop_rounded, AppColors.teal),
                const SizedBox(width: 8),
                _ProfileChip(_thicknessLabel(), Icons.straighten_rounded, AppColors.peach),
              ]),
              const SizedBox(height: 20),

              // Care approach
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: typeBg, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: typeColor.withValues(alpha: 0.3))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('✨ 맞춤 케어 가이드', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w800, color: typeColor)),
                  const SizedBox(height: 8),
                  Text(_careApproach(), style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid, height: 1.6)),
                ]),
              ),
              const SizedBox(height: 16),

              // Tips
              Text('${info.id} 유형 케어 팁', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
              const SizedBox(height: 10),
              ...info.tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 6, right: 10),
                    decoration: BoxDecoration(color: typeColor, shape: BoxShape.circle)),
                  Expanded(child: Text(tip, style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.5))),
                ]),
              )),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onComplete(curlType),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: typeColor, padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4, shadowColor: typeColor.withValues(alpha: 0.4),
                  ),
                  child: Text('꼬불랑 시작하기 🌿', style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _ProfileChip(this.label, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Column(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 3),
        Text(label, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      ]),
    ),
  );
}
