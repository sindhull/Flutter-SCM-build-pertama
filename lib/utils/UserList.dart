import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CardPage extends StatelessWidget {
  final int id;
  final String timestamp;
  final int userid;
  final String nama;
  final int jammerid;
  final String areaname;
  final String rcstate;
  final String gpsstate;
  // final int temp;



  const CardPage({
    Key? key,
    required this.id,
    required this.timestamp,
    required this.userid,
    required this.jammerid,
    required this.areaname,
    required this.rcstate,
    required this.gpsstate,
    // required this.temp,
    required this.nama,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
