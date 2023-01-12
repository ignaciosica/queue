import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/root.dart';

part 'root_view.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(builder: (_) => const RootPage());

  static Page page() => const MaterialPage<void>(child: RootPage());

  @override
  Widget build(BuildContext context) {
    return const RootView();
  }
}
