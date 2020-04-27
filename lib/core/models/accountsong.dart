class AccountSong {
    final int accountSongId;
    final int accountId;
    final String title;
    final String duration;
    final String songLocation;
    final DateTime uploadDate;

    AccountSong({
        this.accountSongId,
        this.accountId,
        this.title,
        this.duration,
        this.songLocation,
        this.uploadDate
    });
}
