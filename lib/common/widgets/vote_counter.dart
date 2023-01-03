import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';

class VoteCounter extends StatelessWidget {
  const VoteCounter({Key? key, required this.track}) : super(key: key);

  final FirestoreTrack track;

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    final voted = track.votes.contains(authRepo.currentUser.id);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: CircleAvatar(
        backgroundColor: !voted ? Colors.transparent : Theme.of(context).colorScheme.primary,
        child: Text(
          track.votes.length.toString(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: !voted ? Theme.of(context).colorScheme.primary : CupertinoColors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
