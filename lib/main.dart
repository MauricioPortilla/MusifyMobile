import 'package:flutter/material.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/player.dart';
import 'package:musify/main_menu.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(Musify());

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
                centerTitle: true,
            ),
            body: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                    children: <Widget>[
                        TextField(
                            controller: _emailTextFieldController,
                            decoration: InputDecoration(
                                labelText: "Correo electrónico"
                            ),
                            maxLength: 100,
                            maxLengthEnforced: true,
                            keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                            controller: _passwordTextFieldController,
                            decoration: InputDecoration(
                                labelText: "Contraseña"
                            ),
                            obscureText: true,
                        ),
                        Container(
                            child: RaisedButton(
                                onPressed: _loginButton,
                                child: Text("Iniciar sesión"),
                                color: Colors.lightBlue,
                                textColor: Colors.white,
                            ),
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                        ),
                        Container(
                            child: RaisedButton(
                                onPressed: _googleLoginButton,
                                child: Text("Iniciar sesión con Google"),
                                color: Colors.lightBlue,
                                textColor: Colors.white,
                            ),
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                        ),
                    ],
                ),
            )
        );
    }

    bool _validateFields() {
        return _emailTextFieldController.text.isNotEmpty &&
            _passwordTextFieldController.text.isNotEmpty;
    }

    void _loginButton() {
        if (!_validateFields()) {
            UI.createErrorDialog(context, "Faltan campos por completar.");
            return;
        }
        Account.login(_emailTextFieldController.text, _passwordTextFieldController.text, (account) {
            _onSuccessfulLogin(account);
        }, (errorResponse) {
            UI.createErrorDialog(context, errorResponse.message);
        });
    }

    Future<void> _googleLoginButton() async {
        try {
            await googleSignIn.signIn().then((result) {
                result.authentication.then((googleKey) {
                    Account.loginWithGoogle(googleKey.accessToken, (account) {
                        _onSuccessfulLogin(account);
                    }, (errorResponse) {
                        UI.createErrorDialog(context, errorResponse.message);
                    });
                }).catchError((error) {
                    print("Error on _HomePageState->_googleLoginButton() -> $error");
                });
            }).catchError((error) {
                print("Error on _HomePageState->_googleLoginButton() -> $error");
            });
        } catch (exception) {
            print(exception);
        }
    }

    void _onSuccessfulLogin(Account account) {
        Session.account = account;
        Session.mainMenu = MainMenuScreen();
        Session.player = Player();
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Session.mainMenu
        ));
    }
}
