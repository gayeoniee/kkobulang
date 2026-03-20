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
  final String confidence; // 'high' | 'medium' | 'low'

  const HairAnalysisResult({
    required this.top,
    required this.middle,
    required this.bottom,
    required this.overallType,
    required this.reasoning,
    this.confidence = 'medium',
  });

  factory HairAnalysisResult.fromJson(Map<String, dynamic> j) {
    return HairAnalysisResult(
      top: SectionResult(type: j['top'] ?? '?', reason: j['top_reason'] ?? ''),
      middle: SectionResult(
          type: j['middle'] ?? '?', reason: j['middle_reason'] ?? ''),
      bottom: SectionResult(
          type: j['bottom'] ?? '?', reason: j['bottom_reason'] ?? ''),
      overallType: j['overall'] ?? '?',
      reasoning: j['reasoning'] ?? '',
      confidence: j['confidence'] ?? 'medium',
    );
  }
}

class GeminiService {
  static final _prompt = '''
당신은 안드레 워커 헤어 타입 분류 전문가입니다. 제공된 머리카락 사진을 분석해주세요.

## 분류 기준 (구분 핵심 포인트)
- **2A**: 거의 직선. 끝부분에 살짝 S자 굴곡. 볼륨 거의 없음.
- **2B**: 두피부터 중간 정도 S자 웨이브. 납작하게 눌리는 경향.
- **2C**: 뿌리부터 굵고 뚜렷한 S자. 습도에 민감, 프리즈 발생.
- **3A**: 큰 원형 링글렛(지름 분필 크기). 빛나는 편. 잘 늘어짐.
- **3B**: 중간 크기 나선형(지름 매직 크기). 스프링 같이 튕김. 볼륨 큼.
- **3C**: 촘촘한 코르크스크류(지름 빨대 크기). 매우 밀집. 프리즈 강함.
- **4A**: 촘촘한 S자 코일. 당기면 늘어남. 윤기 있음.
- **4B**: Z자/꺾임 패턴. 굽어지지 않고 꺾임. 수축률 높음.
- **4C**: 패턴 거의 없음. 극도로 촘촘하고 부드러움. 수축 70%+.

## 분석 방법
1. 사진에서 확인 가능한 컬/웨이브 패턴의 지름과 모양을 관찰하세요.
2. 뿌리부터 중간, 끝부분의 패턴 변화를 체크하세요.
3. 프리즈(부스스함), 볼륨, 윤기 수준을 참고하세요.
4. 사진이 젖은 상태이거나 제품이 발린 상태처럼 보이면 top_reason에 명시하세요.

## 구역 정의
- 상단(top): 두피~귀 높이
- 중단(middle): 귀~어깨 높이
- 하단(bottom): 어깨 아래~끝

반드시 아래 JSON예시의 형식으로만 답변하세요 (다른 텍스트, 마크다운, 코드블록 없이 순수 JSON만):
{
  "top": "2B",
  "top_reason": "두피 부근 컬 패턴을 구체적으로 한 줄 설명",
  "middle": "2C",
  "middle_reason": "중단 컬 패턴을 구체적으로 한 줄 설명",
  "bottom": "3A",
  "bottom_reason": "끝부분 컬 패턴을 구체적으로 한 줄 설명",
  "overall": "2C",
  "reasoning": "전체 판단 근거와 주요 특징 한 줄 요약",
  "confidence": "high"
}

confidence는 "high"(패턴 명확), "medium"(불확실한 부분 있음), "low"(사진 품질 낮거나 판단 어려움) 중 하나.
''';

  static Future<HairAnalysisResult> analyzeHair(Uint8List imageBytes) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
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
