// import 'package:flutter/material.dart';
// import 'package:groupify/common/common.dart';
//
// class SuggestionRow extends StatefulWidget {
//   const SuggestionRow({Key? key, required this.track, required this.actions, required this.position}) : super(key: key);
//   final FirestoreTrack track;
//   final List<Widget> actions;
//   final int position;
//   @override
//   State<SuggestionRow> createState() => _SuggestionRowState();
// }
//
// class _SuggestionRowState extends State<SuggestionRow> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(9),
//       onTap: () {
//         setState(() {
//           widget.track.voted = !widget.track.voted;
//           widget.track.votes += !widget.track.voted ? 1 : -1;
//         });
//       },
//       child: Ink(
//         height: 50,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(9),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(9),
//               child: Image.network(widget.track.album.images[0].url),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.track.name),
//                   Text(widget.track.artists.map((e) => e.name).join(', '), style: Theme.of(context).textTheme.bodySmall),
//                 ],
//               ),
//             ),
//             Row(children: widget.actions),
//             const Icon(Icons.add_circle_rounded, size: 24),
//             const SizedBox(width: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }
