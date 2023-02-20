
import '../const_data/const_data.dart';
import 'http_manager.dart';

class Http extends HttpManager {

  Http({String? baseUrl, Map<String, dynamic>? headers})
      : super(baseUrl!, headers!);

  static Http getHttpWithToken({token}) {
    return Http(baseUrl: baseUrl, headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token',
    });
  }
}
