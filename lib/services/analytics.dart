import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('gtag')
external JSFunction? get _gtagFn;

/// GA4 이벤트 헬퍼
/// web/index.html의 GA_MEASUREMENT_ID를 실제 측정 ID로 교체 후 사용
class GA {
  static void event(String name, [Map<String, dynamic>? params]) {
    try {
      final fn = _gtagFn;
      if (fn == null) return;
      if (params != null) {
        final obj = JSObject();
        params.forEach((k, v) {
          if (v is String) obj.setProperty(k.toJS, v.toJS);
          else if (v is num) obj.setProperty(k.toJS, v.toJS);
          else obj.setProperty(k.toJS, v.toString().toJS);
        });
        fn.callAsFunction(null, 'event'.toJS, name.toJS, obj);
      } else {
        fn.callAsFunction(null, 'event'.toJS, name.toJS);
      }
    } catch (_) {
      // gtag 미로드 시 무시
    }
  }
}
