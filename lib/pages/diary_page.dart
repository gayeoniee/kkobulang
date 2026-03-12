import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import '../services/analytics.dart';

const _curlStateEmojis = ['😞','😕','😐','😊','🥰'];
const _curlStateLabels = ['최악','별로','보통','좋음','완벽'];
const _routinePresets = ['샴푸','컨디셔너','딥컨디셔닝','리브인컨디셔너','컬크림','젤','무스','오일','디퓨저건조','자연건조','스크런칭'];

String _seasonLabel(int month) {
  if (month >= 3 && month <= 5) return '🌸 봄';
  if (month >= 6 && month <= 8) return '☀️ 여름';
  if (month >= 9 && month <= 11) return '🍂 가을';
  return '❄️ 겨울';
}

String _seasonKey(int month) {
  if (month >= 3 && month <= 5) return 'spring';
  if (month >= 6 && month <= 8) return 'summer';
  if (month >= 9 && month <= 11) return 'autumn';
  return 'winter';
}

const _seasonOrder = ['spring', 'summer', 'autumn', 'winter'];

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});
  @override State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late List<DiaryEntry> _entries;
  @override void initState() { super.initState(); _entries = List.from(diaryEntries); }

  void _openForm() {
    GA.event('diary_form_opened');
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _DiaryForm(
        onSave: (e) {
          GA.event('diary_entry_saved', {'curl_state': e.result});
          setState(() => _entries.insert(0, e));
          Navigator.pop(context);
        },
        lastEntry: _entries.isNotEmpty ? _entries.first : null,
      ),
    );
  }

  Map<String, List<DiaryEntry>> get _bySeason {
    final map = <String, List<DiaryEntry>>{};
    for (final e in _entries) {
      final key = _seasonKey(e.date.month);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final bySeason = _bySeason;
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('헤어 다이어리'),
        actions: [Padding(padding: const EdgeInsets.only(right: 12),
          child: ElevatedButton(onPressed: _openForm,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700)),
            child: const Text('+ 기록하기')))],
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

          if (_entries.isEmpty)
            Center(child: Column(children: [
              const SizedBox(height: 32), const Text('📓', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('아직 기록이 없어요', style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownMid)),
            ]))
          else
            // 계절별 섹션
            for (final seasonKey in _seasonOrder)
              if (bySeason.containsKey(seasonKey)) ...[
                _SeasonHeader(label: _seasonLabel(bySeason[seasonKey]!.first.date.month)),
                const SizedBox(height: 10),
                ...bySeason[seasonKey]!.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DiaryCard(entry: e),
                )),
                const SizedBox(height: 8),
              ],
        ]),
      ),
    );
  }
}

class _SeasonHeader extends StatelessWidget {
  final String label;
  const _SeasonHeader({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(label, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.brown)),
  );
}

class _StatBox extends StatelessWidget {
  final String label, value; final Color bg, color;
  const _StatBox({required this.label, required this.value, required this.bg, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
    child: Column(children: [
      Text(value, style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: GoogleFonts.notoSansKr(fontSize: 11, color: color.withOpacity(0.8))),
    ]),
  ));
}

class _DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  const _DiaryCard({required this.entry});
  @override
  Widget build(BuildContext context) {
    final score = entry.result.clamp(1, 5) - 1;
    final emoji = _curlStateEmojis[score];
    final label = _curlStateLabels[score];
    final dateStr = '${entry.date.year}-${entry.date.month.toString().padLeft(2,'0')}-${entry.date.day.toString().padLeft(2,'0')}';
    return AppCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(dateStr, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
          const SizedBox(width: 8),
          Text('$emoji $label', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.peach)),
        ]),
        const SizedBox(height: 6),
        if (entry.memo.isNotEmpty)
          Text(entry.memo, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brown, height: 1.4)),
        const SizedBox(height: 8),
        Wrap(spacing: 5, runSpacing: 5,
          children: entry.routine.map((r) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Text(r, style: GoogleFonts.notoSansKr(fontSize: 10, color: AppColors.brownMid)),
          )).toList()),
      ])),
      if (entry.hasPhoto) ...[
        const SizedBox(width: 10),
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(10)),
          child: const Center(child: Text('📸', style: TextStyle(fontSize: 22))),
        ),
      ],
    ]));
  }
}

// ── Diary Form ───────────────────────────────────────────────────────────
class _DiaryForm extends StatefulWidget {
  final void Function(DiaryEntry) onSave;
  final DiaryEntry? lastEntry;
  const _DiaryForm({required this.onSave, this.lastEntry});
  @override State<_DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<_DiaryForm> {
  int _curlState = 3;
  List<String> _routine = [];
  final List<String> _products = [];
  final TextEditingController _productCtrl = TextEditingController();
  final TextEditingController _memoCtrl = TextEditingController();
  bool _hasPhoto = false;
  String? _searchProduct;

  @override void dispose() { _productCtrl.dispose(); _memoCtrl.dispose(); super.dispose(); }

  void _addProduct(String name) {
    if (name.trim().isEmpty) return;
    setState(() { _products.add(name.trim()); _productCtrl.clear(); _searchProduct = null; });
  }

  void _loadLastRoutine() {
    if (widget.lastEntry == null) return;
    GA.event('diary_auto_load_routine');
    setState(() => _routine = List.from(widget.lastEntry!.routine));
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((p) => _searchProduct != null && _searchProduct!.isNotEmpty
      ? p.name.contains(_searchProduct!) || p.brand.contains(_searchProduct!)
      : false).toList();

    return AppBottomSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('오늘의 헤어 기록 ✍️', style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.brown)),
          const SizedBox(height: 18),

          // Photo
          GestureDetector(
            onTap: () => setState(() => _hasPhoto = !_hasPhoto),
            child: Container(
              width: double.infinity, height: 80,
              decoration: BoxDecoration(
                color: _hasPhoto ? AppColors.peachLight : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _hasPhoto ? AppColors.peach : AppColors.border, style: BorderStyle.solid, width: 1.5)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(_hasPhoto ? Icons.check_circle_rounded : Icons.add_photo_alternate_rounded,
                  color: _hasPhoto ? AppColors.peach : AppColors.brownLight, size: 28),
                const SizedBox(height: 4),
                Text(_hasPhoto ? '사진 추가됨 ✓' : '사진 추가 (선택)',
                  style: GoogleFonts.notoSansKr(fontSize: 12, color: _hasPhoto ? AppColors.peach : AppColors.brownLight, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          const SizedBox(height: 16),

          // Curl state
          Text('오늘의 컬 상태', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 8),
          Row(children: List.generate(5, (i) => Expanded(child: GestureDetector(
            onTap: () => setState(() => _curlState = i + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _curlState == i + 1 ? AppColors.peachLight : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _curlState == i + 1 ? AppColors.peach : Colors.transparent, width: 2)),
              child: Column(children: [
                Text(_curlStateEmojis[i], style: const TextStyle(fontSize: 22)),
                Text(_curlStateLabels[i], style: GoogleFonts.notoSansKr(fontSize: 9, color: _curlState == i + 1 ? AppColors.peachDark : AppColors.brownLight, fontWeight: FontWeight.w600)),
              ]),
            ),
          )))),
          const SizedBox(height: 16),

          // Routine
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('루틴', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
            if (widget.lastEntry != null)
              GestureDetector(
                onTap: _loadLastRoutine,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.autorenew_rounded, size: 13, color: AppColors.teal),
                  const SizedBox(width: 3),
                  Text('최근 루틴 자동불러오기',
                    style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.teal)),
                ]),
              ),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8,
            children: _routinePresets.map((r) {
              final isAdded = _routine.contains(r);
              return GestureDetector(
                onTap: () => setState(() => isAdded ? _routine.remove(r) : _routine.add(r)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAdded ? AppColors.teal : AppColors.surface,
                    borderRadius: BorderRadius.circular(20)),
                  child: Text(r, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: isAdded ? Colors.white : AppColors.brownMid)),
                ),
              );
            }).toList()),
          if (_routine.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.swap_vert_rounded, size: 14, color: AppColors.teal),
                const SizedBox(width: 6),
                Expanded(child: Text('선택 순서: ${_routine.join(' → ')}',
                  style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.tealDark, fontWeight: FontWeight.w600))),
              ]),
            ),
          ],
          const SizedBox(height: 16),

          // Products
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('제품', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
            if (widget.lastEntry != null)
              GestureDetector(
                onTap: () {
                  GA.event('diary_auto_load_product');
                  setState(() {
                    if (_products.isEmpty) _products.addAll(['컬크림', '리브인컨디셔너']);
                  });
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.autorenew_rounded, size: 13, color: AppColors.peach),
                  const SizedBox(width: 3),
                  Text('최근 제품 자동불러오기',
                    style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.peach)),
                ]),
              ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(
              controller: _productCtrl,
              onChanged: (v) => setState(() => _searchProduct = v),
              decoration: const InputDecoration(hintText: '제품 검색 또는 직접 입력...', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: Icon(Icons.search, size: 18, color: AppColors.brownLight)),
              style: GoogleFonts.notoSansKr(fontSize: 13),
            )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _addProduct(_productCtrl.text),
              child: Container(width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 20)),
            ),
          ]),
          if (filteredProducts.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 6)]),
              child: Column(children: filteredProducts.take(4).map((p) => GestureDetector(
                onTap: () => _addProduct(p.name),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(children: [
                    Text(p.img, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p.name, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brown))),
                    Text(p.brand, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
                  ]),
                ),
              )).toList()),
            ),
          if (_products.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6,
              children: _products.map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.peachLight, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(p, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.peachDark)),
                  const SizedBox(width: 4),
                  GestureDetector(onTap: () => setState(() => _products.remove(p)),
                    child: const Icon(Icons.close_rounded, size: 14, color: AppColors.peachDark)),
                ]),
              )).toList()),
          ],
          const SizedBox(height: 16),

          // Memo
          Text('메모 (선택)', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 8),
          TextField(
            controller: _memoCtrl, maxLines: 3,
            decoration: const InputDecoration(hintText: '오늘의 느낌을 자유롭게 적어봐요 🌿'),
          ),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.peach), foregroundColor: AppColors.peachDark, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(vertical: 14)),
              child: Text('취소', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700)),
            )),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: ElevatedButton(
              onPressed: () => widget.onSave(DiaryEntry(
                id: DateTime.now().millisecondsSinceEpoch,
                date: DateTime.now(), routine: _routine.isEmpty ? ['기록 없음'] : _routine,
                result: _curlState, memo: _memoCtrl.text.trim(),
                tags: [], hasPhoto: _hasPhoto,
              )),
              child: Text('저장하기 ✨', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700, color: Colors.white)),
            )),
          ]),
        ])),
      ),
    );
  }
}
