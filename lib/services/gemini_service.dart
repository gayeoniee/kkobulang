import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/secrets.dart';
import '../models/diagnosis_history.dart';

class HairAnalysisResult {
  final SectionResult top;
  final SectionResult middle;
  final SectionResult bottom;
  final String overallType;
  final String reasoning;

  const HairAnalysisResult({
    required this.top,
    required this.middle,
    required this.bottom,
    required this.overallType,
    required this.reasoning,
  });

  factory HairAnalysisResult.fromJson(Map<String, dynamic> j) {
    return HairAnalysisResult(
      top: SectionResult(type: j['top'] ?? '?', reason: j['top_reason'] ?? ''),
      middle: SectionResult(type: j['middle'] ?? '?', reason: j['middle_reason'] ?? ''),
      bottom: SectionResult(type: j['bottom'] ?? '?', reason: j['bottom_reason'] ?? ''),
      overallType: j['overall'] ?? '?',
      reasoning: j['reasoning'] ?? '',
    );
  }
}

class GeminiService {
  static final _prompt = '''
당신은 헤어 전문가입니다. 제공된 머리카락 사진을 안드레 워커 분류 체계로 분석해주세요.

머리카락을 다음 3개 섹션으로 나누어 각각의 곱슬 유형을 판단해주세요:
- 상단(top): 뿌리~두피 부근
- 중단(middle): 머리 중간 부분
- 하단(bottom): 끝 부분

안드레 워커 분류 체계:
- 타입 1 (직모): 1A, 1B, 1C
- 타입 2 (웨이브): 2A(느슨한 S), 2B(중간 S), 2C(굵고 뚜렷한 S)
- 타입 3 (컬리): 3A(느슨한 나선), 3B(중간 나선), 3C(촘촘한 나선)
- 타입 4 (코일리): 4A(S패턴 코일), 4B(Z패턴), 4C(매우 촘촘한 코일)

반드시 아래 JSON 형식으로만 답변하세요 (다른 텍스트, 마크다운 없이):
{
  "top": "3A",
  "top_reason": "뿌리 부근 컬 패턴 한 줄 설명",
  "middle": "3B",
  "middle_reason": "중단 컬 패턴 한 줄 설명",
  "bottom": "3B",
  "bottom_reason": "끝부분 컬 패턴 한 줄 설명",
  "overall": "3B",
  "reasoning": "전체 종합 판단 근거 한 줄"
}
''';

  static Future<HairAnalysisResult> analyzeHair(Uint8List imageBytes) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
    );

    final response = await model.generateContent([
      Content.multi([
        TextPart(_prompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ]);

    final text = response.text ?? '';
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}') + 1;
    if (start < 0 || end <= start) {
      throw Exception('분석 결과를 파싱할 수 없어요.');
    }
    final jsonStr = text.substring(start, end);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return HairAnalysisResult.fromJson(data);
  }
}
