import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musify/core/core.dart';
import 'package:musify/core/models/artist.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/network.dart';
import 'package:musify/core/networkresponse.dart';
import 'package:musify/core/session.dart';

class Album {
    final int albumId;
    final String type;
    final String name;
    final int launchYear;
    final String discography;
    final String imageLocation;
    List<Artist> artists = <Artist>[];
    List<Song> songs = <Song>[];

    Album({
        this.albumId,
        this.type,
        this.name,
        this.launchYear,
        this.discography,
        this.imageLocation
    });

    factory Album.fromJson(Map<String, dynamic> json) {
        return Album(
            albumId: json["album_id"],
            type: json["type"],
            name: json["name"],
            launchYear: json["launch_year"],
            discography: json["discography"],
            imageLocation: json["image_location"]
        );
    }

    Future<List<Artist>> loadArtists() async {
        var data = {
            "{albumId}": albumId
        };
        NetworkResponse response = await Network.futureGet("/album/{albumId}/artists", data);
        if (response.status == "success") {
            artists.clear();
            for (var artistJson in response.data) {
                artists.add(Artist.fromJson(artistJson));
            }
        }
        return artists;
    }

    Future loadSongs() async {
        var data = {
            "{albumId}": albumId
        };
        NetworkResponse response = await Network.futureGet("/album/{albumId}/songs", data);
        if (response.status == "success") {
            songs.clear();
            for (var songJson in response.data) {
                var song = Song.fromJson(songJson);
                song.album = this;
                songs.add(song);
            }
        }
    }

    static Future<List<Album>> fetchAlbumByNameCoincidences(String name) async {
        List<Album> albums = <Album>[];
        if (name.isEmpty) {
            return albums;
        }
        var data = {
            "{name}": name
        };
        NetworkResponse response = await Network.futureGet("/album/search/{name}", data);
        if (response.status == "success") {
            for (var albumResponse in response.data) {
                var album = Album.fromJson(albumResponse);
                await album.loadArtists();
                albums.add(album);
            }
        }
        return albums;
    }

    CachedNetworkImage fetchImage() {
        return CachedNetworkImage(
            imageUrl: Core.SERVER_URL + "/album/" + albumId.toString() + "/image",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            httpHeaders: { "Authorization": Session.accessToken },
        );
    }

    String artistsNames() {
        String artistsNames = "";
        for (Artist artist in artists) {
            if (artistsNames.isNotEmpty) {
                artistsNames += ", ";
            }
            artistsNames += artist.artisticName;
        }
        return artistsNames;
    }
}
