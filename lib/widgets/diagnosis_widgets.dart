import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../data/seed_data.dart';
import '../models/diagnosis_history.dart';
import '../services/gemini_service.dart';
import 'common_widgets.dart';

// ── AI 이미지 분석 모달 ────────────────────────────────────────────────────
class ImageAnalysisModal extends StatefulWidget {
  const ImageAnalysisModal({super.key});
  @override
  State<ImageAnalysisModal> createState() => _ImageAnalysisModalState();
}

class _ImageAnalysisModalState extends State<ImageAnalysisModal> {
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  HairAnalysisResult? _result;
  String? _error;

  Future<void> _pickImage() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() { _imageBytes = bytes; _result = null; _error = null; });
    } catch (e) {
      setState(() => _error = '사진을 불러오는 데 실패했어요.');
    }
  }

  Future<void> _analyze() async {
    if (_imageBytes == null) return;
    setState(() { _isAnalyzing = true; _error = null; });
    try {
      final result = await GeminiService.analyzeHair(_imageBytes!);
      setState(() { _result = result; _isAnalyzing = false; });
    } catch (e) {
      setState(() { _error = e.toString().replaceAll('Exception: ', ''); _isAnalyzing = false; });
    }
  }

  void _saveResult() {
    final r = _result!;
    final info = curlTypes.firstWhere((t) => t.id == r.overallType, orElse: () => curlTypes[4]);
    DiagnosisHistory.instance.add(DiagnosisRecord(
      date: DateTime.now(),
      curlType: r.overallType,
      title: info.title,
      source: 'image',
      reasoning: r.reasoning,
      top: r.top,
      middle: r.middle,
      bottom: r.bottom,
      isCurrent: true,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('진단 결과가 이력에 저장됐어요!', style: GoogleFonts.notoSansKr()),
        backgroundColor: AppColors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Text('📷', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text('AI 곱슬 유형 분석', style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context), color: AppColors.brownLight),
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('상/중/하 3섹션 안드레 워커 분류 체계로 분석해요',
              style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight)),
          ),
          const SizedBox(height: 12),
          Expanded(child: ListView(controller: ctrl, padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [

            // 사진 선택 영역
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: _imageBytes != null ? null : 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.peachLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.peach.withValues(alpha: 0.3), width: 1.5),
                ),
                child: _imageBytes != null
                  ? Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(_imageBytes!, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Positioned(bottom: 10, right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                          child: Text('사진 변경', style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.white)),
                        ),
                      ),
                    ])
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('📸', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 10),
                      Text('사진을 선택해주세요', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.peachDark)),
                      const SizedBox(height: 4),
                      Text('머리카락 전체가 보이는 사진이 좋아요', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid)),
                    ]),
              ),
            ),
            const SizedBox(height: 14),

            if (_imageBytes != null && _result == null && !_isAnalyzing)
              buildPrimaryButton('🔍  분석 시작', _analyze),

            if (_isAnalyzing)
              Column(children: [
                const SizedBox(height: 8),
                const CircularProgressIndicator(color: AppColors.teal),
                const SizedBox(height: 12),
                Text('AI가 머리카락을 분석하고 있어요...', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid)),
                const SizedBox(height: 8),
              ]),

            if (_error != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
                child: Text('⚠️  $_error', style: GoogleFonts.notoSansKr(fontSize: 13, color: const Color(0xFFC62828))),
              ),

            if (_result != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('분석 결과', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.tealDark)),
                  const SizedBox(height: 12),
                  SectionResultRow(label: '상단 (뿌리)', section: _result!.top),
                  const SizedBox(height: 8),
                  SectionResultRow(label: '중단', section: _result!.middle),
                  const SizedBox(height: 8),
                  SectionResultRow(label: '하단 (끝)', section: _result!.bottom),
                  const Divider(height: 24),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
                      child: Text(_result!.overallType, style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(
                      curlTypes.firstWhere((t) => t.id == _result!.overallType, orElse: () => curlTypes[4]).title,
                      style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.tealDark),
                    )),
                  ]),
                  const SizedBox(height: 8),
                  Text('💡 ${_result!.reasoning}', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.tealDark, height: 1.5)),
                ]),
              ),
              const SizedBox(height: 16),
              buildPrimaryButton('진단 결과 저장', _saveResult),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() { _result = null; }),
                child: Text('다시 분석하기', style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownLight)),
              ),
            ],
          ])),
        ]),
      ),
    );
  }
}

// ── 섹션 결과 행 ───────────────────────────────────────────────────────────
class SectionResultRow extends StatelessWidget {
  final String label;
  final SectionResult section;
  const SectionResultRow({super.key, required this.label, required this.section});

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 70,
      child: Text(label, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.tealDark, fontWeight: FontWeight.w600)),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
      child: Text(section.type, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.teal)),
    ),
    const SizedBox(width: 8),
    Expanded(child: Text(section.reason, style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.4))),
  ]);
}

// ── 유형진단 이력 모달 ────────────────────────────────────────────────────
class TypeHistoryModal extends StatelessWidget {
  const TypeHistoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final records = DiagnosisHistory.instance.records;
    return DraggableScrollableSheet(
      initialChildSize: 0.7, minChildSize: 0.4, maxChildSize: 0.92, expand: false,
      builder: (_, ctrl) => Container(
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
            child: Row(children: [
              Text('📋 유형 진단 이력', style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context), color: AppColors.brownLight),
            ]),
          ),
          const SizedBox(height: 4),
          Expanded(child: records.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('📭', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text('아직 진단 이력이 없어요', style: GoogleFonts.notoSansKr(fontSize: 14, color: AppColors.brownLight)),
                const SizedBox(height: 4),
                Text('설문 또는 이미지 분석을 완료하면\n이력이 여기에 쌓여요', textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownLight, height: 1.5)),
              ]))
            : ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: records.length,
                itemBuilder: (_, i) => DiagnosisHistoryItem(record: records[i]),
              ),
          ),
        ]),
      ),
    );
  }
}

// ── 이력 아이템 카드 ──────────────────────────────────────────────────────
class DiagnosisHistoryItem extends StatelessWidget {
  final DiagnosisRecord record;
  const DiagnosisHistoryItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.curlTypeColor(record.curlType);
    final isImage = record.source == 'image';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: record.isCurrent ? color.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: record.isCurrent ? color.withValues(alpha: 0.35) : Colors.transparent, width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Text(record.curlType, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(record.title, style: GoogleFonts.notoSansKr(fontSize: 13, color: AppColors.brownMid))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isImage ? AppColors.peachLight : AppColors.tealLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(isImage ? '📷 이미지' : '📝 설문',
                style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w700,
                  color: isImage ? AppColors.peachDark : AppColors.tealDark)),
            ),
            if (record.isCurrent) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                child: Text('현재', style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ]),
          const SizedBox(height: 6),
          Text(record.dateLabel, style: GoogleFonts.notoSansKr(fontSize: 11, color: AppColors.brownLight)),
          if (record.reasoning != null) ...[
            const SizedBox(height: 4),
            Text('💡 ${record.reasoning}', style: GoogleFonts.notoSansKr(fontSize: 12, color: AppColors.brownMid, height: 1.4)),
          ],
          if (record.top != null) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: [
              _sectionChip('상단', record.top!.type),
              _sectionChip('중단', record.middle!.type),
              _sectionChip('하단', record.bottom!.type),
            ]),
          ],
        ]),
      ),
    );
  }

  Widget _sectionChip(String label, String type) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(6)),
    child: Text('$label $type', style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tealDark)),
  );
}
