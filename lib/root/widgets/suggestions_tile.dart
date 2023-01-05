// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:groupify/common/common.dart';
//
// import '../root.dart';
//
// class SuggestionsTile extends StatelessWidget {
//   SuggestionsTile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseTile(
//       margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Suggestions',
//                 style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const Spacer(),
//               CircleAvatar(
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 child: const Icon(CupertinoIcons.sparkles),
//               ),
//               //const SizedBox(width: 8),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ListView.separated(
//             itemCount: tracks.length,
//             shrinkWrap: true,
//             physics: const BouncingScrollPhysics(),
//             itemBuilder: (BuildContext context, int index) {
//               return SuggestionRow(
//                 track: tracks[index],
//                 actions: [],
//                 position: index + 1,
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
//           ),
//         ],
//       ),
//     );
//   }
// }
