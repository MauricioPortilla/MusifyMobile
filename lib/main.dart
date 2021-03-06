import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/player.dart';
import 'package:musify/main_menu.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musify/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    runApp(Musify());
    Session.preferences = await SharedPreferences.getInstance();
    if (Session.preferences.getStringList("downloadedPlaylists") == null) {
        Session.preferences.setStringList("downloadedPlaylists", []);
    }
}

class Musify extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Musify',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: MusifyScreen(title: 'Musify'),
        );
    }
}

class MusifyScreen extends StatefulWidget {
    MusifyScreen({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MusifyState createState() => _MusifyState();
}

class _MusifyState extends State<MusifyScreen> {
    TextEditingController _emailTextFieldController = TextEditingController();
    TextEditingController _passwordTextFieldController = TextEditingController();
    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
            'email'
        ],
    );

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                centerTitle: true
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                        children: <Widget>[
                            TextField(
                                controller: _emailTextFieldController,
                                decoration: InputDecoration(labelText: "Correo electrónico"),
                                maxLength: 100,
                                maxLengthEnforced: true,
                                keyboardType: TextInputType.emailAddress
                            ),
                            TextField(
                                controller: _passwordTextFieldController,
                                decoration: InputDecoration(labelText: "Contraseña"),
                                obscureText: true
                            ),
                            Container(
                                child: RaisedButton(
                                    onPressed: _loginButton,
                                    child: Text("Iniciar sesión"),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10)
                            ),
                            Container(
                                child: RaisedButton(
                                    onPressed: _googleLoginButton,
                                    child: Text("Iniciar sesión con Google"),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10)
                            ),
                            Container(
                                child: RaisedButton(
                                    onPressed: _registerButton,
                                    child: Text("Registrarse"),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 20)
                            )
                        ]
                    )
                )
            )
        );
    }

    bool _validateFields() {
        return _emailTextFieldController.text.isNotEmpty && _passwordTextFieldController.text.isNotEmpty;
    }

    bool _validateFieldsData() {
        return RegExp(Core.REGEX_EMAIL).hasMatch(_emailTextFieldController.text);
    }

    void _loginButton() {
        if (!_validateFields()) {
            UI.createErrorDialog(context, "Faltan campos por completar.");
            return;
        } else if (!_validateFieldsData()) {
            UI.createErrorDialog(context, "Debes introducir datos válidos.");
            return;
        }
        UI.createLoadingDialog(context);
        Account.login(_emailTextFieldController.text, _passwordTextFieldController.text, (account) {
            Navigator.pop(context);
            _onSuccessfulLogin(account);
        }, (errorResponse) {
            Navigator.pop(context);
            UI.createErrorDialog(context, errorResponse.message);
        }, () {
            UI.createErrorDialog(context, "Ocurrió un error al momento de iniciar sesión.");
        });
    }

    Future<void> _googleLoginButton() async {
        try {
            UI.createLoadingDialog(context);
            await googleSignIn.signIn().then((result) {
                result.authentication.then((googleKey) {
                    Account.loginWithGoogle(googleKey.accessToken, (account) {
                        Navigator.pop(context);
                        _onSuccessfulLogin(account);
                    }, (errorResponse) {
                        Navigator.pop(context);
                        UI.createErrorDialog(context, errorResponse.message);
                    }, () {
                        Navigator.pop(context);
                        UI.createErrorDialog(context, "Ocurrió un error al momento de iniciar sesión.");
                    });
                }).catchError((error) {
                    Navigator.pop(context);
                    print("Error on _HomePageState->_googleLoginButton() -> $error");
                    UI.createErrorDialog(context, "Ocurrió un error al momento de iniciar sesión.");
                });
            }).catchError((error) {
                Navigator.pop(context);
                print("Error on _HomePageState->_googleLoginButton() -> $error");
                UI.createErrorDialog(context, "Ocurrió un error al momento de iniciar sesión.");
            });
        } catch (exception) {
            Navigator.pop(context);
            print("Error on _HomePageState->_googleLoginButton() -> $exception");
            UI.createErrorDialog(context, "Ocurrió un error al momento de iniciar sesión.");
        }
    }

    Future<void> _onSuccessfulLogin(Account account) async {
        await Session.account.fetchArtist();
        await Session.account.fetchSubscription();
        Session.mainMenu = MainMenuScreen();
        Session.player = Player();
        if (Session.preferences.getStringList("songsIdPlayHistory" + account.accountId.toString()) != null){
            Session.songsIdPlayHistory = Session.preferences.getStringList("songsIdPlayHistory" + account.accountId.toString());
        }
        Session.historyIndex = Session.songsIdPlayHistory.length - 1; 
        if (Session.preferences.getStringList("songsIdPlayQueue" + account.accountId.toString()) != null){
            Session.songsIdPlayQueue = Session.preferences.getStringList("songsIdPlayQueue" + account.accountId.toString());
        }
        if (Session.preferences.getStringList("genresIdRadioStations" + account.accountId.toString()) != null){
            Session.genresIdRadioStations = Session.preferences.getStringList("genresIdRadioStations" + account.accountId.toString());
        }
        if (Session.preferences.getString("songStreamingQuality" + account.accountId.toString()) != null){
            Session.songStreamingQuality = Session.preferences.getString("songStreamingQuality" + account.accountId.toString());
        }
        _passwordTextFieldController.text = "";
        Navigator.push(context, MaterialPageRoute(builder: (context) => Session.mainMenu));
    }

    void _registerButton() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
    }
}
