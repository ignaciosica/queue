part of 'root_page.dart';

class RootView extends StatefulWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  late final TextEditingController _roomNameController;
  bool createEnabled = false;
  late final TextEditingController _roomCodeController;
  bool joinEnabled = false;

  String roomId = '';

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController();
    _roomNameController.addListener(() {
      setState(() {
        createEnabled = _roomNameController.text.isNotEmpty;
      });
    });

    _roomCodeController = TextEditingController();
    _roomCodeController.addListener(() async {
      await FirebaseFirestore.instance
          .collection('rooms')
          .where('room_id', isEqualTo: _roomCodeController.text)
          .get()
          .then((value) {
        setState(() {
          joinEnabled = value.docs.isNotEmpty;
          if (value.docs.isNotEmpty) {
            roomId = value.docs.first.id;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const BaseAppBar(title: 'Queue'),
      body: Center(
        child: BaseTile(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8, width: double.infinity),
              Text('Rooms', style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _roomNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Room name',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: createEnabled
                          ? () async {
                              final createdRoomId = await RepositoryProvider.of<FirestoreRepository>(context)
                                  .createRoom(_roomNameController.text);
                              BlocProvider.of<RoomCubit>(context).setRoomId(createdRoomId);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => const RoomPage()));
                            }
                          : null,
                      child: const SizedBox(width: 60, child: Center(child: Text('Create')))),
                ],
              ),
              const Divider(thickness: 1.5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _roomCodeController,
                      decoration: const InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: 'Room code',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: joinEnabled
                          ? () async {
                              await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
                                'users':
                                    FieldValue.arrayUnion([RepositoryProvider.of<AuthRepository>(context).currentUser!.id])
                              });

                              BlocProvider.of<RoomCubit>(context).setRoomId(roomId);

                              Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomPage()));
                            }
                          : null,
                      child: const SizedBox(width: 60, child: Center(child: Text('Join')))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
