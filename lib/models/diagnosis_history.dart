import '../data/seed_data.dart';

class SectionResult {
  final String type;   // e.g. '3A'
  final String reason; // 한 줄 판단 근거

  const SectionResult({required this.type, required this.reason});
}

class DiagnosisRecord {
  final DateTime date;
  final String curlType;   // overall result
  final String title;      // e.g. '느슨한 컬'
  final String source;     // 'survey' | 'image'
  final String? reasoning; // 한 줄 종합 판단 근거
  final SectionResult? top;
  final SectionResult? middle;
  final SectionResult? bottom;
  final bool isCurrent;

  DiagnosisRecord({
    required this.date,
    required this.curlType,
    required this.title,
    required this.source,
    this.reasoning,
    this.top,
    this.middle,
    this.bottom,
    this.isCurrent = false,
  });

  String get dateLabel {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// 앱 세션 내 진단 이력을 공유하는 싱글톤
class DiagnosisHistory {
  static final DiagnosisHistory instance = DiagnosisHistory._();
  DiagnosisHistory._();

  final List<DiagnosisRecord> _records = [];

  List<DiagnosisRecord> get records => List.unmodifiable(_records);

  void add(DiagnosisRecord record) {
    // 기존 isCurrent 해제
    for (var i = 0; i < _records.length; i++) {
      if (_records[i].isCurrent) {
        _records[i] = DiagnosisRecord(
          date: _records[i].date,
          curlType: _records[i].curlType,
          title: _records[i].title,
          source: _records[i].source,
          reasoning: _records[i].reasoning,
          top: _records[i].top,
          middle: _records[i].middle,
          bottom: _records[i].bottom,
          isCurrent: false,
        );
      }
    }
    _records.insert(0, record);
  }

  /// 설문 완료 시 호출
  void addSurveyResult(String curlType) {
    final info = curlTypes.firstWhere((t) => t.id == curlType, orElse: () => curlTypes[4]);
    add(DiagnosisRecord(
      date: DateTime.now(),
      curlType: curlType,
      title: info.title,
      source: 'survey',
      reasoning: '설문 답변 기반 자동 분석',
      isCurrent: true,
    ));
  }
}
