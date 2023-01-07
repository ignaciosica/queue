import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/search_cubit.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CupertinoTextField(
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.search,
        placeholder: 'Search',
        placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
        decoration: null,
        onChanged: BlocProvider.of<SearchCubit>(context).onQueryChange,
      ),
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(42, 30, 81, 100), Color.fromRGBO(81, 58, 159, 100)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
