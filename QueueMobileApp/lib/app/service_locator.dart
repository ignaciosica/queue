import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue/services/room_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator(FirebaseFirestore firestore) {
  getIt.registerLazySingleton<IRoomService>(() => RoomService(firestore));
}
