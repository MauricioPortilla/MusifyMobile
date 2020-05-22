import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musify/core/session.dart';
import 'package:musify/screens/consult_playlists.dart';

class HomeScreen extends StatelessWidget {
    final Stream<Widget> stream;

    HomeScreen({@required this.stream});

    @override
    Widget build(BuildContext context) {
        return _HomePage(stream: this.stream);
    }
}

class _HomePage extends StatefulWidget {
    final _HomePageState state =  _HomePageState();
    final Stream<Widget> stream;

    _HomePage({@required this.stream});

    _HomePageState createState() => state;
}

class _HomePageState extends State<_HomePage> with AutomaticKeepAliveClientMixin {
    Widget content = ConsultPlaylistsScreen();

    @override
    bool get wantKeepAlive => true;

    @override
    void initState() {
        super.initState();
        Session.homeTabWidgetQueue.addLast(content);
        widget.stream.listen((newContent) {
            _changeContent(newContent);
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: content
        );
    }

    void _changeContent(Widget newContent) {
        setState(() {
            content = newContent;
        });
    }
}
