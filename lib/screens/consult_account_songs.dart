import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/accountsong.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui.dart';
import 'package:musify/core/ui/accountsonglist.dart';

class ConsultAccountSongsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _ConsultAccountSongsPage();
    }
}

class _ConsultAccountSongsPage extends StatefulWidget {
    _ConsultAccountSongsPageState createState() => _ConsultAccountSongsPageState();
}

class _ConsultAccountSongsPageState extends State<_ConsultAccountSongsPage> {
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Biblioteca propia"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                        Session.homePop();
                    },
                ),
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                RaisedButton(
                                    child: Icon(Icons.add),
                                    onPressed: () => _addAccountSongButton(),
                                    color: Colors.green,
                                ),
                            ],
                        ),
                        Container(
                            child: _loadAccountSongs(),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    FutureBuilder<List<AccountSong>> _loadAccountSongs() {
        return FutureFactory<List<AccountSong>>().networkFuture(Session.account.fetchAccountSongs(), (data) {
            return AccountSongList(accountSongs: data);
        });
    }

    void _addAccountSongButton() async {
        List<File> files = await FilePicker.getMultiFile(type: FileType.custom, allowedExtensions: ['mp3', 'wav']);
        if (files == null) {
            return;
        }
        UI.createLoadingDialog(context);
        Session.account.addAccountSongs(files, () {
            Navigator.pop(context);
            setState(() {
            });
        }, (errorResponse) {
            Navigator.pop(context);
            UI.createErrorDialog(context, errorResponse.message);
        }, () {
            Navigator.pop(context);
            UI.createErrorDialog(context, "Ocurrió un error al subir la canción.");
        });
    }
}
