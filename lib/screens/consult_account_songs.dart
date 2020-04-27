import 'package:flutter/material.dart';
import 'package:musify/core/models/accountsong.dart';
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
    List<AccountSong> accountSongs = <AccountSong>[
        AccountSong(title: "Sirens of the Sea"),
        AccountSong(title: "Sirens of the Sea - Club Mix"),
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Biblioteca propia"),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: AccountSongList(accountSongs: accountSongs),
                        ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }
}
