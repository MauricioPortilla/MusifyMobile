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
            home: HomeScreen(title: 'Musify'),
        );
    }
}

class HomeScreen extends StatefulWidget {
    HomeScreen({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
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
            Session.account = account;
            Session.player = Player();
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => MainMenuScreen()
            ));
        }, (errorResponse) {
            UI.createErrorDialog(context, errorResponse.message);
        });
    }

    Future<void> _googleLoginButton() async {
        try {
            await googleSignIn.signIn().then((result) {
                result.authentication.then((googleKey) {
                    Account.loginWithGoogle(googleKey.accessToken, (account) {
                        Session.account = account;
                        Session.player = Player();
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MainMenuScreen()
                        ));
                    }, (errorResponse) {
                        UI.createErrorDialog(context, errorResponse.message);
                    });
                }).catchError((error) {
                    print("Error on main->_googleLoginButton() -> $error");
                });
            }).catchError((error) {
                print("Error on main->_googleLoginButton() -> $error");
            });
        } catch (exception) {
            print(exception);
        }
    }
}
