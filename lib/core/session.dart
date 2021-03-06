import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/ui/player.dart';
import 'package:musify/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
    static Account account;
    static String accessToken;
    static Player player;
    static String songStreamingQuality = "automaticquality";
    static SharedPreferences preferences;
    static MainMenuScreen mainMenu;
    static ListQueue homeTabWidgetQueue = ListQueue();
    static List<String> songsIdPlayHistory = List<String>();
    static List<String> songsIdPlayQueue = List<String>();
    static List<String> genresIdRadioStations = List<String>();
    static List<int> songsIdSongList = List<int>();
    static int historyIndex;

    static void homePush(Widget content) {
        homeTabWidgetQueue.addLast(content);
        mainMenu.page.controller.add(homeTabWidgetQueue.last);
        mainMenu.page.state.tabController.animateTo(0);
    }

    static void homePop() {
        homeTabWidgetQueue.removeLast();
        mainMenu.page.controller.add(homeTabWidgetQueue.last);
    }
}
