// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../GlobalVar.dart';
// import '../utils/UserList.dart';
// import 'package:http/http.dart' as http;
// import 'AddUser.dart';
//
// class UserPage extends StatefulWidget {
//   const UserPage({Key? key});
//
//   @override
//   _UserPageState createState() => _UserPageState();
// }
//
// class _UserPageState extends State<UserPage> {
//   bool _isLoading = true;
//   List _user = [];
//
//   Future<void> getListUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var response = await http.get(
//       Uri.parse("${baseUrl()}/users/current"),
//       headers: {
//         "Authorization": prefs.getString("access")!,
//       },
//     );
//
//     if (kDebugMode) {
//       print(response.statusCode);
//       print(response.request!.url);
//       print(response.body);
//     }
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _user = json.decode(response.body)['data']; // Ambil list pengguna
//       });
//     } else {
//       // Tangani error, misalnya menampilkan snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(json.decode(response.body)['message']),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<void> deleteUser(int userId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     try {
//       var response = await http.delete(
//         Uri.parse("${baseUrl()}/users/:id"), // Menghapus pengguna berdasarkan ID
//         headers: {
//           "Authorization": prefs.getString("access")!,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           _user.removeWhere((user) => user['id'] == userId);
//         });
//         print('Pengguna berhasil dihapus');
//       } else {
//         print('Gagal menghapus pengguna');
//       }
//     } catch (error) {
//       print('Terjadi kesalahan: $error');
//     }
//   }
//
//   @override
//   void initState() {
//     getListUser();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         automaticallyImplyLeading: false, // Hides the back button
//         title: Text(
//           'User Management',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black, // Warna teks judul AppBar
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 16.0), // Menggeser tombol ke kiri
//             child: IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddUserPage(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//
//       ),
//       body: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(25),
//           color: Colors.grey[100],
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//
//                 Expanded(
//                   child: _isLoading
//                       ? Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                     itemCount: _user.length,
//                     itemBuilder: (context, index) {
//                       return CardPage(
//                         cardName: _user[index]['nama'],
//                         Id: _user[index]['id'],
//                         Role: _user[index]['username'],
//                         imagePath: 'assets/images/sindu.png',
//                         color: Colors.orange,
//                         onDelete: deleteUser,
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
