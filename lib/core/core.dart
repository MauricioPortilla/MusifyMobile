import 'package:flutter_config/flutter_config.dart';

class Core {
    static String _API_VERSION = "v" + FlutterConfig.get("API_VERSION");
    static String SERVER_URL = FlutterConfig.get("SERVER_URL") + "/api/" + _API_VERSION;
}
