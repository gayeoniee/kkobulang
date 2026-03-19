import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/diagnosis_widgets.dart';
import '../services/analytics.dart';

class ProfilePage extends StatefulWidget {
  final String curlType;
  final void Function(String) onChangeCurlType;
  const ProfilePage({super.key, required this.curlType, required this.onChangeCurlType});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

String _gradeEmoji(int posts) {
  if (posts >= 50) return '🍑';
  if (posts >= 20) return '🌺';
  if (posts >= 10) return '🌸';
  if (posts >= 3) return '🌿';
  return '🌱';
}

String _gradeLabel(int posts) {
  if (posts >= 50) return '열매';
  if (posts >= 20) return '꽃';
  if (posts >= 10) return '꽃봉오리';
  if (posts >= 3) return '새싹';
  return '씨앗';
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editing = false;
  late TextEditingController _nickCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nickCtrl = TextEditingController(text: '꼬불이');
    _bioCtrl = TextEditingController(text: '3B 컬을 사랑하는 직장인 🌀');
  }

  @override
  void dispose() { _nickCtrl.dispose(); _bioCtrl.dispose(); super.dispose(); }

  void _showImageAnalysis(BuildContext context) {
    GA.event('image_analysis_opened', {'source': 'profile'});
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => const ImageAnalysisModal(),
    );
  }

  void _showTypeHistory(BuildContext context) {
    GA.event('type_history_opened', {'source': 'profile'});
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => const TypeHistoryModal(),
    );
  }

  void _openTypeSelector() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TypeSelectorSheet(
        current: widget.curlType,
        onSelect: (id) {
          widget.onChangeCurlType(id);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeInfo = curlTypes.firstWhere((t) => t.id == widget.curlType, orElse: () => curlTypes[4]);
    final typeColor = AppColors.curlTypeColor(widget.curlType);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('내 프로필'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () => setState(() => _editing = !_editing),
              child: Text(_editing ? '취소' : '수정',
                style: GoogleFonts.notoSansKr(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: _editing ? AppColors.brownLight : AppColors.peach)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(children: [
          // Profile Card
          AppCard(
            child: Column(children: [
              Row(children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: typeColor.withOpacity(0.2),
                    border: Border.all(color: typeColor, width: 3),
                  ),
                  child: Center(child: Text(typeInfo.emoji, style: const TextStyle(fontSize: 36))),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (_editing)
                    TextField(
                      controller: _nickCtrl,
                      style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.brown),
                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                    )
                  else
                    Row(children: [
                    Text(_nickCtrl.text, style: GoogleFonts.notoSansKr(
                        fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.brown)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tealLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${_gradeEmoji(7)} ${_gradeLabel(7)}',
                        style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.teal)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  CurlTypeBadge(widget.curlType, large: true),
                ])),
                // 이미지 분석 + 이력 버튼
                Row(mainAxisSize: MainAxisSize.min, children: [
                  _ProfileIconBtn(
                    icon: Icons.camera_alt_rounded, label: '이미지분석',
                    onTap: () => _showImageAnalysis(context),
                  ),
                  const SizedBox(width: 6),
                  _ProfileIconBtn(
                    icon: Icons.history_rounded, label: '진단이력',
                    onTap: () => _showTypeHistory(context),
                  ),
                ]),
              ]),
              const SizedBox(height: 14),
              if (_editing)
                TextField(
                  controller: _bioCtrl, maxLines: 2,
                  decoration: const InputDecoration(hintText: '자기소개를 입력하세요'),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_bioCtrl.text,
                    style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownMid, height: 1.5)),
                ),
              if (_editing) ...[
                const SizedBox(height: 14),
                buildPrimaryButton('저장하기', () => setState(() => _editing = false)),
              ],
            ]),
          ),
          const SizedBox(height: 14),

          // Curl type card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              border: Border.all(color: typeColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('내 곱슬 유형', style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.brown)),
                GestureDetector(
                  onTap: _openTypeSelector,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: typeColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('변경하기',
                      style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: typeColor)),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Text(typeInfo.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${typeInfo.id} – ${typeInfo.title}',
                    style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown)),
                  const SizedBox(height: 2),
                  Text(typeInfo.desc, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.4)),
                ])),
              ]),
              const SizedBox(height: 10),
              ...typeInfo.tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  const Text('💡 ', style: TextStyle(fontSize: 12)),
                  Expanded(child: Text(tip, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid))),
                ]),
              )),
            ]),
          ),
          const SizedBox(height: 14),

          // Menu
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _MenuItem(icon: '📓', label: '내 다이어리', trailing: '7개', iconBg: AppColors.tealLight, iconColor: AppColors.teal),
              _MenuItem(icon: '💬', label: '내 게시글', trailing: '3개', iconBg: AppColors.peachLight, iconColor: AppColors.peach),
              _MenuItem(icon: '❤️', label: '좋아요한 제품', trailing: '5개', iconBg: AppColors.type4Bg, iconColor: AppColors.type4),
              _MenuItem(icon: '🔔', label: '알림 설정', iconBg: AppColors.type2Bg, iconColor: AppColors.type2, isLast: true),
            ]),
          ),
          const SizedBox(height: 14),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _MenuItem(label: '계정 관리'),
              _MenuItem(label: '개인정보 처리방침'),
              _MenuItem(label: '로그아웃', textColor: AppColors.type4, isLast: true),
            ]),
          ),
        ]),
      ),
    );
  }
}


class _ProfileIconBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileIconBtn({required this.icon, required this.label, required this.onTap});
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

class _MenuItem extends StatelessWidget {
  final String label;
  final String? icon, trailing;
  final Color? iconBg, iconColor, textColor;
  final bool isLast;
  const _MenuItem({required this.label, this.icon, this.trailing, this.iconBg, this.iconColor, this.textColor, this.isLast = false});

  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        if (icon != null) ...[
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg ?? AppColors.surface, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(icon!, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: Text(label,
          style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w500,
            color: textColor ?? AppColors.brown))),
        if (trailing != null)
          Text(trailing!, style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
        if (textColor == null)
          const Icon(Icons.chevron_right_rounded, color: AppColors.brownLight),
      ]),
    ),
    if (!isLast) const Divider(color: AppColors.surface, height: 1, indent: 16, endIndent: 16),
  ]);
}

class _TypeSelectorSheet extends StatefulWidget {
  final String current;
  final void Function(String) onSelect;
  const _TypeSelectorSheet({required this.current, required this.onSelect});
  @override
  State<_TypeSelectorSheet> createState() => _TypeSelectorSheetState();
}

class _TypeSelectorSheetState extends State<_TypeSelectorSheet> {
  late String _selected;
  @override
  void initState() { super.initState(); _selected = widget.current; }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('곱슬 유형 변경', style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brown)),
          const SizedBox(height: 4),
          Text('나에게 가장 맞는 유형을 선택해주세요',
            style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
          const SizedBox(height: 14),
          SizedBox(
            height: 320,
            child: ListView.separated(
              itemCount: curlTypes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final type = curlTypes[i];
                final color = AppColors.curlTypeColor(type.id);
                final isSelected = _selected == type.id;
                return GestureDetector(
                  onTap: () => setState(() => _selected = type.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.12) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
                    ),
                    child: Row(children: [
                      Text(type.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(type.id, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brown)),
                      const SizedBox(width: 6),
                      Text(type.title, style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid)),
                      const Spacer(),
                      if (isSelected) Icon(Icons.check_circle_rounded, color: color, size: 20),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          buildPrimaryButton('$_selected으로 변경하기', () => widget.onSelect(_selected)),
        ]),
      ),
    );
  }
}
