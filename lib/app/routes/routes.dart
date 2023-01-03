import 'package:flutter/widgets.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/lobby/lobby.dart';
import 'package:groupify/root/root.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [RootPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
