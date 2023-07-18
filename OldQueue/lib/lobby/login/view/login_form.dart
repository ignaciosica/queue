import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/lobby/login/login.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        } else if (BlocProvider.of<AppBloc>(context).state.status == AppStatus.authenticated) {
          Navigator.of(context).pop();
        }
      },
    );

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SpotifyLoginButton(!state.spotifyAuthenticated),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: state.spotifyAuthenticated
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.background,
                  child: const Icon(Icons.done_rounded),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleLoginButton(!state.googleAuthenticated),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: state.googleAuthenticated
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.background,
                  child: const Icon(Icons.done_rounded),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SpotifyLoginButton extends StatelessWidget {
  const _SpotifyLoginButton(this.active);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('connect_with_spotify_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      label: const Text('Connect with Spotify'),
      icon: const Icon(FontAwesomeIcons.spotify, color: Colors.white),
      onPressed: active ? () => context.read<LoginCubit>().logInWithSpotify() : null,
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton(this.active);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('connect_with_google_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      label: const Text('Connect with Google'),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: active ? () => context.read<LoginCubit>().logInWithGoogle() : null,
    );
  }
}
