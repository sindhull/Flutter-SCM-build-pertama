// import 'package:apk_sinduuu/screens/MyProfile.dart';
// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:apk_sinduuu/screens/signin_screen.dart';
// import 'package:apk_sinduuu/theme/theme.dart';
// import 'package:apk_sinduuu/widgets/custom_scaffold.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formEditProfileKey = GlobalKey<FormState>();
//   bool agreePersonalData = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//               // Jika validasi sukses, navigasi ke halaman MyProfile
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MyProfile(), // Ganti dengan halaman yang diinginkan
//                 ),
//               );
//             }
//
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
//           child: Form(
//             key: _formEditProfileKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Edit Profile',
//                   style: TextStyle(
//                     fontSize: 30.0,
//                     fontWeight: FontWeight.w900,
//                     color: lightColorScheme.primary,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 40.0,
//                 ),
//                 // Full Name
//                 TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Full Name';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: const Text('Full Name'),
//                     hintText: 'Enter Full Name',
//                     hintStyle: const TextStyle(
//                       color: Colors.black26,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 25.0,
//                 ),
//                 // Username
//                 TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Username';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: const Text('Username'),
//                     hintText: 'Enter Username',
//                     hintStyle: const TextStyle(
//                       color: Colors.black26,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 25.0,
//                 ),
//                 // Mobile Phone
//                 TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Mobile Phone';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: const Text('Mobile Phone'),
//                     hintText: 'Enter Mobile Phone',
//                     hintStyle: const TextStyle(
//                       color: Colors.black26,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 25.0,
//                 ),
//                 // Location
//                 TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Location';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: const Text('Location'),
//                     hintText: 'Enter Location',
//                     hintStyle: const TextStyle(
//                       color: Colors.black26,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 50.0,
//                 ),
//                 // Save Changes button
//                 ElevatedButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Password Changed'),
//                       ),
//                     );
//
//                     // Navigasi ke halaman lain di sini setelah validasi berhasil
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MyProfile(), // Ganti dengan halaman tujuan yang diinginkan
//                       ),
//                     );
//                   },
//                   style: ButtonStyle(
//                     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                       EdgeInsets.symmetric(
//                         vertical: MediaQuery.of(context).size.height * 0.025, // Ubah sesuai kebutuhan
//                         horizontal: MediaQuery.of(context).size.width * 0.1, // Ubah sesuai kebutuhan
//                       ),
//                     ),
//                     minimumSize: MaterialStateProperty.all<Size>(
//                       Size(MediaQuery.of(context).size.width * 0.7, 50), // Ubah sesuai kebutuhan
//                     ),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   child: const Text('Save Changes'),
//                 ),
//
//                 const SizedBox(
//                   height: 30.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
