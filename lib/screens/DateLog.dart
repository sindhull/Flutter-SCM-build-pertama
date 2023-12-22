import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'user_screen.dart';

class DatePage extends StatefulWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      initialDateRange: _selectedDateRange ?? initialDateRange,
    );

    if (pickedDateRange != null && pickedDateRange != _selectedDateRange) {
      setState(() {
        _selectedDateRange = pickedDateRange;
      });

      // Arahkan ke halaman UserPage setelah rentang tanggal dipilih
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => UserPage(selectedDateRange: _selectedDateRange), // Kirim rentang tanggal yang dipilih ke UserPage
        ),
      );
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
                  builder: (BuildContext context) => MainPage(index: 2,),
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
          backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Sesuaikan radius lengkung
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today), // Menggunakan ikon kalender
              onPressed: () => _selectDateRange(context), // Memanggil fungsi untuk memilih rentang tanggal
            ),
            if (_selectedDateRange != null)
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Selected Date Range: ${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
