import 'package:flutter_config/flutter_config.dart';

class Core {
    static String _API_VERSION = "v" + FlutterConfig.get("API_VERSION");
    static String SERVER_URL = FlutterConfig.get("SERVER_URL") + "/api/" + _API_VERSION;

    static const int MAX_SONGS_IN_PLAY_HISTORY = 50;

    static const String REGEX_EMAIL = r"^\w+@\w+\.[a-zA-Z]+$";
    static const String REGEX_ONLY_LETTERS = r"^[a-zA-Z ]+$";
    static const String REGEX_ONLY_LETTERS_NUMBERS = r"^[a-zA-Z0-9 ]+$";
}
