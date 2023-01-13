part of 'participants_page.dart';

class ParticipantsView extends StatelessWidget {
  const ParticipantsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Participants'),
      body: StreamBuilder<DocumentSnapshot>(
        stream: RepositoryProvider.of<FirestoreRepository>(context).getRoom(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final room = Room.fromJson(snapshot.data!.data()!);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot<dynamic>>(
                    future: FirebaseFirestore.instance.doc("users/${room.users[index]}").get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<dynamic>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var json = snapshot.data!.data()!;
                        json['id'] = snapshot.data!.id;
                        final user = FirestoreUser.fromJson(json);

                        return InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () => RepositoryProvider.of<FirestoreRepository>(context).setPlayer(room.users[index]),
                          child: ListTile(
                            leading: user.profileUrl != null
                                ? SizedBox(
                                    width: 40,
                                    child: Center(child: CircleAvatar(backgroundImage: NetworkImage(user.profileUrl!))))
                                : const SizedBox(width: 40, child: Center(child: Icon(Icons.person_rounded))),
                            title: Text(user.name),
                            trailing: room.player == room.users[index]
                                ? Icon(
                                    Icons.speaker_group_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: room.users.length,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
