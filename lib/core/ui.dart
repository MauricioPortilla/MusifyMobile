import 'package:flutter/material.dart';

class UI {
    static void createDialog(
        BuildContext context, String title, Widget content,
        List<Widget> actions
    ) {
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
                return AlertDialog(
                    title: Text(title), 
                    content: content, 
                    actions: actions
                );
            }
        );
    }
    static void createErrorDialog(
        BuildContext context, String errorResponseMessage
    ) {
        createDialog(context, "Error", Text(errorResponseMessage), <Widget>[
            FlatButton(
                child: Text("Cerrar"),
                onPressed: () {
                    Navigator.pop(context);
                }
            )
        ]);
    }

    static void createLoadingDialog(BuildContext context) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext buildContext) {
            return Dialog(
                child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            CircularProgressIndicator(),
                            ],
                        ),
                        ],
                    )
                )
            );
        });
    }
}
