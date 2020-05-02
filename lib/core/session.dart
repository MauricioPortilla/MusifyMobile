import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:musify/core/models/account.dart';
import 'package:musify/core/ui/player.dart';
import 'package:musify/main_menu.dart';

class Session {
    static Account account;
    static String accessToken;
    static Player player;
    static MainMenuScreen mainMenu;
    static ListQueue homeTabWidgetQueue = ListQueue();

    static void homePush(Widget content) {
        homeTabWidgetQueue.addLast(content);
        mainMenu.page.state.controller.add(homeTabWidgetQueue.last);
    }

    static void homePop() {
        homeTabWidgetQueue.removeLast();
        mainMenu.page.state.controller.add(homeTabWidgetQueue.last);
    }
}
