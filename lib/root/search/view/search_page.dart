import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/room/room.dart';
import 'package:groupify/root/search/search.dart';

part 'search_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, required this.roomCubit}) : super(key: key);

  final RoomCubit roomCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SearchCubit()),
        BlocProvider<RoomCubit>(create: (BuildContext context) => roomCubit),
      ],
      child: const SearchView(),
    );
  }
}
