// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class CardPage extends StatelessWidget {
//   final String cardName;
//   final int Id;
//   final String Role;
//   final String imagePath;
//   final Color color;
//
//   const CardPage({
//     Key? key,
//     required this.cardName,
//     required this.Id,
//     required this.Role,
//     required this.imagePath,
//     required this.color,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: AssetImage(imagePath),
//                   radius: 25,
//                 ),
//                 SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       cardName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// /