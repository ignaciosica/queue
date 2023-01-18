import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/root.dart';
import 'package:workmanager/workmanager.dart';

part 'root_view.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(builder: (_) => const RootPage());

  static Page page() => const MaterialPage<void>(child: RootPage());

  @override
  Widget build(BuildContext context) {
    Workmanager().cancelAll();


    if(BlocProvider.of<RoomCubit>(context).state.roomId != '') {
      Navigator.push( context, MaterialPageRoute(builder: (_) => const RoomPage()));
    }

    return const RootView();
  }
}
