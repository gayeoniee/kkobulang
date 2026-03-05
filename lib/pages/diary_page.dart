import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late List<DiaryEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List.from(diaryEntries);
  }

  final _badges = [
    ('🌱', '첫 기록', true), ('🔥', '3일 연속', true),
    ('💫', '7일 연속', false), ('🏆', '30일 달성', false),
  ];

  void _openForm() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DiaryForm(
        onSave: (entry) {
          setState(() => _entries.insert(0, entry));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('헤어 다이어리'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _openForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              child: const Text('+ 기록하기'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Stats
          Row(children: [
            _StatBox(label: '총 기록', value: '${_entries.length}일', bg: AppColors.peachLight, color: AppColors.peachDark),
            const SizedBox(width: 10),
            const _StatBox(label: '이번 달', value: '2회', bg: AppColors.tealLight, color: AppColors.tealDark),
            const SizedBox(width: 10),
            const _StatBox(label: '연속 기록', value: '3일', bg: AppColors.greenLight, color: Color(0xFF4A9E44)),
          ]),
          const SizedBox(height: 20),

          // Badges
          Text('🏅 획득한 뱃지', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 10),
          Row(children: _badges.map((b) {
            final (icon, label, earned) = b;
            return Expanded(child: Opacity(
              opacity: earned ? 1.0 : 0.4,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: earned ? Colors.white : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: earned ? const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 6, offset: Offset(0,2))] : null,
                ),
                child: Column(children: [
                  Text(icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(label, textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownMid)),
                ]),
              ),
            ));
          }).toList()),
          const SizedBox(height: 20),

          const Divider(color: AppColors.border),
          const SizedBox(height: 16),

          Text('최근 기록', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 12),

          if (_entries.isEmpty)
            Center(child: Column(children: [
              const SizedBox(height: 40),
              const Text('📓', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('아직 기록이 없어요', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownMid)),
              const SizedBox(height: 6),
              Text('오늘의 헤어 루틴을 기록해봐요!',
                style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
            ]))
          else
            ..._entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DiaryCard(entry: e),
            )),
        ]),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color bg, color;
  const _StatBox({required this.label, required this.value, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Text(value, style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.notoSansKr(fontSize: 11, color: color.withOpacity(0.8))),
      ]),
    ),
  );
}

class _DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  const _DiaryCard({required this.entry});

  static const _resultColors = [Color(0xFFE87070), Color(0xFFF4A27B), Color(0xFFF5D76E), Color(0xFF6BBF5F), Color(0xFF5BBCB0)];
  static const _resultEmojis = ['😞', '😕', '😐', '😊', '🥰'];

  @override
  Widget build(BuildContext context) {
    final score = entry.result.clamp(1, 5) - 1;
    final color = _resultColors[score];
    final emoji = _resultEmojis[score];
    final dateStr = '${entry.date.year}-${entry.date.month.toString().padLeft(2,'0')}-${entry.date.day.toString().padLeft(2,'0')}';

    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(entry.mood, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(dateStr, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text('$emoji ${entry.result}/5',
                  style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
              ),
            ]),
            const SizedBox(height: 4),
            Text(entry.memo, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brown, height: 1.4)),
          ])),
        ]),
        const SizedBox(height: 10),
        const Divider(color: AppColors.surface, height: 1),
        const SizedBox(height: 8),
        Text('사용한 제품', style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6,
          children: entry.routine.map((r) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Text(r, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownMid)),
          )).toList()),
      ]),
    );
  }
}

class _DiaryForm extends StatefulWidget {
  final void Function(DiaryEntry) onSave;
  const _DiaryForm({required this.onSave});
  @override
  State<_DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<_DiaryForm> {
  final _memoCtrl = TextEditingController();
  String _mood = '😊';
  int _result = 3;

  @override
  void dispose() { _memoCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final moods = ['😞', '😕', '😐', '😊', '🥰'];
    return AppBottomSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('오늘의 헤어 기록 ✍️',
            style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 16),

          Text('오늘 기분', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brown)),
          const SizedBox(height: 8),
          Row(children: moods.map((m) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _mood = m),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _mood == m ? AppColors.peachLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _mood == m ? AppColors.peach : Colors.transparent, width: 2),
                ),
                child: Center(child: Text(m, style: const TextStyle(fontSize: 24))),
              ),
            ),
          )).toList()),
          const SizedBox(height: 16),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('오늘 컬 상태', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brown)),
            Text('$_result / 5', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.peach)),
          ]),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.peach,
              inactiveTrackColor: AppColors.peachLight,
              thumbColor: AppColors.peachDark,
              overlayColor: AppColors.peach.withOpacity(0.2),
            ),
            child: Slider(
              min: 1, max: 5, divisions: 4,
              value: _result.toDouble(),
              onChanged: (v) => setState(() => _result = v.round()),
            ),
          ),
          const SizedBox(height: 8),

          Text('메모', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brown)),
          const SizedBox(height: 8),
          TextField(
            controller: _memoCtrl, maxLines: 3,
            decoration: const InputDecoration(hintText: '오늘의 루틴과 느낌을 자유롭게 적어봐요 🌿'),
          ),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.peach),
                foregroundColor: AppColors.peachDark,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('취소', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700)),
            )),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: ElevatedButton(
              onPressed: _memoCtrl.text.trim().isNotEmpty ? () => widget.onSave(DiaryEntry(
                id: DateTime.now().millisecondsSinceEpoch,
                date: DateTime.now(), mood: _mood,
                routine: ['오늘의 루틴'],
                result: _result, memo: _memoCtrl.text.trim(), tags: [],
              )) : null,
              child: Text('저장하기 ✨', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700, color: Colors.white)),
            )),
          ]),
        ]),
      ),
    );
  }
}
