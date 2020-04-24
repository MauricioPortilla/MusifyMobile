import 'package:flutter/material.dart';

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

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Container(
                child: Column(
                    children: _rows(),
                ),
            )
        );
    }

    List<Widget> _rows() {
        List<Widget> rows = <Widget>[];
        for (var i = 0; i < 10; i++) {
            rows.add(
                Container(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () { },
                        child: Container(
                            child: Text(
                                "Esta es una fila",
                                textAlign: TextAlign.left,
                            ),
                            padding: EdgeInsets.all(10),
                        )
                    )
                )
            );
        }
        return rows;
    }
}
