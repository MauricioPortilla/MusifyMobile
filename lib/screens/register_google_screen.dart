import 'package:flutter/material.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/ui.dart';

class RegisterGoogleScreen extends StatelessWidget {
    final String accessToken;

    RegisterGoogleScreen({@required this.accessToken});

    @override
    Widget build(BuildContext context) {
        return _RegisterGooglePage(accessToken: this.accessToken);
    }
}

class _RegisterGooglePage extends StatefulWidget {
    final String accessToken;

    _RegisterGooglePage({@required this.accessToken});

    @override
    _RegisterGooglePageState createState() => _RegisterGooglePageState();
}

class _RegisterGooglePageState extends State<_RegisterGooglePage> {
    TextEditingController _artisticNameTextFieldController = TextEditingController();
    bool imAnArtist = false;

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
                                    onPressed: _finishRegisterWithGoogleButton,
                                    child: Text("Concluir registro con Google"),
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

    void _finishRegisterWithGoogleButton() {
        UI.createLoadingDialog(context);
        Account account = Account();
        account.registerWithGoogle(widget.accessToken, imAnArtist, (account) {
            Navigator.pop(context);
            Navigator.pop(context);
            UI.createSuccessDialog(context, "Cuenta registrada.");
        }, (errorResponse) {
            Navigator.pop(context);
            UI.createErrorDialog(context, errorResponse.message);
        }, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Ocurrió un error al momento de registrar la cuenta.");
        });
    }
}
