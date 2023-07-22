import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:queue/services/room_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator(FirebaseFirestore firestore, FirebaseAuth auth) {
  getIt.registerLazySingleton<IRoomService>(() => RoomService(firestore, auth));
}
