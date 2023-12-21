import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CobaDate extends StatefulWidget {
  const CobaDate({Key? key}) : super(key: key);

  @override
  State<CobaDate> createState() => _CobaDateState();
}

class _CobaDateState extends State<CobaDate> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showCalendarDatePicker();
          },
          child: Text('Choose Date Range'),
        ),
      ),
    );
  }

  Future<void> _showCalendarDatePicker() async {
    final pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      value: [_startDate, _endDate],
      borderRadius: BorderRadius.circular(15),
    );

    if (pickedDates != null && pickedDates.isNotEmpty) {
      setState(() {
        _startDate = pickedDates[0];
        _endDate = pickedDates[1];
      });
    }
  }
}
