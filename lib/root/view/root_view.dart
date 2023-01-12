part of 'root_page.dart';

class RootView extends StatelessWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const RootAppBar(),
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
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Room name',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomPage())),
                      child: const SizedBox(width: 60, child: Center(child: Text('Create')))),
                ],
              ),
              const Divider(thickness: 1.5),
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: 'Room code',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomPage())),
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
