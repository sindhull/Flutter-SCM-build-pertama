import 'package:apk_sinduuu/screens/DateLog.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  DateTimeRange? myDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023), // Set first date to 2023
      lastDate: DateTime(2024), // You can set the last date according to your requirement
      initialDateRange: myDateRange ?? DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        myDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DatePage(),
                ),
              );
            },
          ),
          title: Text(
            "Catatan Aktivitas",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.yellow,
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Sesuaikan radius lengkung
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: Text('Pilih Rentang Tanggal'),
          ),
          if (myDateRange != null)
            Text("Saved value is: ${myDateRange.toString()}"),
        ],
      ),
    );
  }
}
