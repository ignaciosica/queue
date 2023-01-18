import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/repositories/repositories.dart';
import 'package:groupify/root/room/room.dart';

class App extends StatelessWidget {
  const App({Key? key, required AuthRepository authenticationRepository, required FirestoreRepository firestoreRepository})
      : _authenticationRepository = authenticationRepository,
        _firestoreRepository = firestoreRepository,
        super(key: key);

  final AuthRepository _authenticationRepository;
  final FirestoreRepository _firestoreRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: SpotifyRepository(_authenticationRepository)),
        RepositoryProvider.value(value: _firestoreRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => AppBloc(authenticationRepository: _authenticationRepository)),
          BlocProvider(create: (BuildContext context) => RoomCubit('')),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(primary: CupertinoColors.activeGreen),
        useMaterial3: true,
        //fontFamily: GoogleFonts.inter().fontFamily,
        //scaffoldBackgroundColor: CupertinoColors.black,
      ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
