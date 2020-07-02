import 'package:flutter/material.dart';
import 'package:musify/core/futurefactory.dart';
import 'package:musify/core/models/genre.dart';
import 'package:musify/core/session.dart';
import 'package:musify/core/ui/genrelist.dart';

import 'consult_radio_station.dart';

class RadioStationsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _RadioStationsPage();
    }
}

class _RadioStationsPage extends StatefulWidget {
    _RadioStationsPageState createState() => _RadioStationsPageState();
}

class _RadioStationsPageState extends State<_RadioStationsPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Estaciones de radio"),
                centerTitle: true,
                automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
                    children: <Widget>[
                      Container(
                        child: _genreList(),
                      ),
                    ],
                ),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            )
        );
    }

    void _onSelectGenre(Genre genre) {
        Session.homePush(ConsultRadioStationScreen(genre: genre));
    }

    FutureBuilder<List<Genre>> _genreList() {
        List<int> genresId = List<int>();
        for (String genreId in Session.genresIdRadioStations){
            genresId.add(int.parse(genreId));
        }
        return FutureFactory<List<Genre>>().networkFuture(Genre.fetchGenresById(genresId), (data) {
            return GenreList(genres: data, onTap: _onSelectGenre);
        }, () {
            return Center(child: Text("Ocurrió un error al cargar las estaciones de radio."));
        });
    }
}
