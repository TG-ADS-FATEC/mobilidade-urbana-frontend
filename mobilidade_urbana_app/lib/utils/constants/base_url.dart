import 'package:flutter_dotenv/flutter_dotenv.dart';

String get profileApiBaseUrl =>
    '${dotenv.get('API_BASE_URL', fallback: 'http://10.0.2.2:8080')}/api/v1/';