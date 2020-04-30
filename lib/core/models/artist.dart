import 'package:musify/core/models/album.dart';

class Artist {
    final int artistId;
    final int accountId;
    final String artisticName;
    List<Album> albums = <Album>[];

    Artist({
        this.artistId, 
        this.accountId, 
        this.artisticName,
        this.albums
    });

    factory Artist.fromJson(Map<String, dynamic> json) {
        return Artist(
            artistId: json["artist_id"],
            accountId: json["account_id"],
            artisticName: json["artistic_name"]
        );
    }
}
