import 'dart:io';

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

    factory Album.json(Map<String, dynamic> json) {
        return Album(
            imageLocation: json["image_location"]
        );
    }

    void save(
        File imageFile, 
        List<File> songsFile, 
        onSuccess(), 
        onFailure(NetworkResponse errorResponse), 
        onError()
    ) {
        Network.postMultimedia("/album/songs", null, songsFile, (responseSongs) {
            if (responseSongs.status == "success") {
                List<File> images = [imageFile];
                Network.postMultimedia("/album/image", null, images, (responseImage) {
                    if (responseImage.status == "success") {  
                        List<Song> songsLocation = List<Song>();
                        for (var songJson in responseSongs.data) {
                            songsLocation.add(Song.json(songJson));
                        }
                        List<Album> imageLocation = List<Album>();
                        for (var albumJson in responseImage.data) {
                            imageLocation.add(Album.json(albumJson));
                        }
                        List artistsId = List();
                        for (Artist artist in artists) {
                            artistsId.add({
                                "artist_id": artist.artistId
                            });
                        }
                        List newSongs = List();
                        int i = 0;
                        for (Song song in songs) {
                            List songArtistsId = List();
                            for (Artist artist in song.artists) {
                                songArtistsId.add({
                                    "artist_id": artist.artistId
                                });
                            }
                            newSongs.add({
                                "genre_id": song.genreId,
                                "title": song.title,
                                "duration": songsLocation.elementAt(i).duration,
                                "song_location": songsLocation.elementAt(i).songLocation,
                                "artists_id": songArtistsId
                            });
                            i++;
                        }
                        var data = {
                            "type": type,
                            "name": name,
                            "launch_year": launchYear,
                            "discography": discography,
                            "image_location": imageLocation.elementAt(0).imageLocation,
                            "artists_id": artistsId,
                            "new_songs": newSongs
                        };
                        Network.post("/album", data, (response) {
                            onSuccess();
                        }, onFailure, () {
                            print("Exception@Album->save()");
                            onError();
                        });
                    }
                }, onFailure, () {
                    print("Exception@Album->save()");
                    onError();
                });
            }
        }, onFailure, () {
            print("Exception@Album->save()");
            onError();
        });
    }

    Future<List<Artist>> fetchArtists() async {
        var data = {
            "{albumId}": albumId
        };
        try {
            NetworkResponse response = await Network.futureGet("/album/{albumId}/artists", data);
            if (response.status == "success") {
                for (var artistJson in response.data) {
                    artists.add(Artist.fromJson(artistJson));
                }
            }
            return artists;
        } catch (exception) {
            print("Exception@Album->fetchArtists()");
            throw exception;
        }
    }

    Future<List<Song>> fetchSongs() async {
        var data = {
            "{albumId}": albumId
        };
        try {
            NetworkResponse response = await Network.futureGet("/album/{albumId}/songs", data);
            if (response.status == "success") {
                songs.clear();
                for (var songJson in response.data) {
                    var song = Song.fromJson(songJson);
                    song.album = this;
                    await song.fetchGenre();
                    await song.fetchArtists();
                    songs.add(song);
                }
            }
            return songs;
        } catch (exception) {
            print("Exception@Album->fetchSongs()");
            throw exception;
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
        try {
            NetworkResponse response = await Network.futureGet("/album/search/{name}", data);
            if (response.status == "success") {
                for (var albumResponse in response.data) {
                    var album = Album.fromJson(albumResponse);
                    await album.fetchArtists();
                    albums.add(album);
                }
            }
            return albums;
        } catch (exception) {
            print("Exception@Album->fetchAlbumByNameCoincidences()");
            throw exception;
        }
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
