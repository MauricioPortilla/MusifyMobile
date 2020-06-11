import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/screens/register_google_screen.dart';

class RegisterScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _RegisterPage();
    }
}

class _RegisterPage extends StatefulWidget {
    _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
    TextEditingController _emailTextFieldController = TextEditingController();
    TextEditingController _passwordTextFieldController = TextEditingController();
    TextEditingController _nameTextFieldController = TextEditingController();
    TextEditingController _lastNameTextFieldController = TextEditingController();
    TextEditingController _artisticNameTextFieldController = TextEditingController();
    bool imAnArtist = false;
    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
            'email',
            'profile'
        ],
    );

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Registrar cuenta"),
                centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Container(
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
                            TextField(
                                controller: _nameTextFieldController,
                                decoration: InputDecoration(
                                    labelText: "Nombre"
                                ),
                                maxLength: 50,
                                maxLengthEnforced: true
                            ),
                            TextField(
                                controller: _lastNameTextFieldController,
                                decoration: InputDecoration(
                                    labelText: "Apellidos"
                                ),
                                maxLength: 50,
                                maxLengthEnforced: true
                            ),
                            ListTile(
                                title: Text("Soy un artista"),
                                leading: Checkbox(
                                    onChanged: (value) {
                                        setState(() {
                                            imAnArtist = value;
                                        });
                                    },
                                    value: imAnArtist,
                                ),
                            ),
                            TextField(
                                controller: _artisticNameTextFieldController,
                                decoration: InputDecoration(
                                    labelText: "Nombre artístico"
                                ),
                                maxLength: 50,
                                maxLengthEnforced: true,
                                enabled: imAnArtist,
                            ),
                            Container(
                                child: RaisedButton(
                                    onPressed: _registerButton,
                                    child: Text("Registrarse"),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                            ),
                            Container(
                                child: RaisedButton(
                                    onPressed: _googleRegisterButton,
                                    child: Text("Registrarse con Google"),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                            ),
                        ],
                    ),
                ),
            )
        );
    }

    bool _validateFields() {
        return _emailTextFieldController.text.isNotEmpty &&
            _passwordTextFieldController.text.isNotEmpty &&
            _nameTextFieldController.text.isNotEmpty &&
            _lastNameTextFieldController.text.isNotEmpty &&
            imAnArtist ? _artisticNameTextFieldController.text.isNotEmpty : true;
    }

    bool _validateFieldsData() {
        return RegExp(Core.REGEX_EMAIL).hasMatch(_emailTextFieldController.text) &&
            RegExp(Core.REGEX_ONLY_LETTERS).hasMatch(_nameTextFieldController.text) &&
            RegExp(Core.REGEX_ONLY_LETTERS).hasMatch(_lastNameTextFieldController.text);
    }

    void _registerButton() {
        if (!_validateFields()) {
            UI.createErrorDialog(context, "Faltan campos por completar.");
            return;
        } else if (!_validateFieldsData()) {
            UI.createErrorDialog(context, "Debes introducir datos válidos.");
            return;
        }
        UI.createLoadingDialog(context);
        Account account = Account(
            email: _emailTextFieldController.text,
            password: _passwordTextFieldController.text,
            name: _nameTextFieldController.text,
            lastName: _lastNameTextFieldController.text
        );
        account.register(imAnArtist, (account) {
            Navigator.pop(context);
            UI.createDialog(
                context, "Cuenta registrada", Text("Cuenta registrada."), [
                    FlatButton(
                        child: Text("Volver"),
                        onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                        },
                    )
                ]
            );
        }, (errorResponse) {
            Navigator.pop(context);
            UI.createErrorDialog(context, errorResponse.message);
        }, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Error al registrar la cuenta.");
        }, artisticName: _artisticNameTextFieldController.text);
    }

    Future<void> _googleRegisterButton() async {
        try {
            await googleSignIn.signIn().then((result) {
                result.authentication.then((googleKey) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                            builder: (context) => RegisterGoogleScreen(accessToken: googleKey.accessToken)
                        )
                    );
                }).catchError((error) {
                    print("Error on _HomePageState->_googleLoginButton() -> $error");
                    UI.createErrorDialog(context, "Error al establecer una conexión.");
                });
            }).catchError((error) {
                print("Error on _HomePageState->_googleLoginButton() -> $error");
                UI.createErrorDialog(context, "Error al establecer una conexión.");
            });
        } catch (exception) {
            print("Error on _HomePageState->_googleLoginButton() -> $exception");
            UI.createErrorDialog(context, "Error al establecer una conexión.");
        }
    }
}
