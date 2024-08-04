import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Searchresult.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _dateController = TextEditingController();
  late TimeOfDay _selectedTime;
  late String _selectedVehicleType;
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _pickuplocation = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _selectedVehicleType = 'Small';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime.format(context);
      });
    }
  }

  void searchData() {
    if (_pickuplocation.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a pickup location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        webPosition: "center",
      );
      return;
    }
    if (_destination.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a destination",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        webPosition: "center",
      );
      return;
    }
    if (_dateController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select a date",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        webPosition: "center",
      );
      return;
    }
    if (_timeController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select a time",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        webPosition: "center",
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Searchresult(
          _pickuplocation.text.trim(),
          _destination.text.trim(),
          _selectedVehicleType.trim(),
          _dateController.text.trim(),
          _timeController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title: Text("LugNload"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 8.0, right: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: _pickuplocation,
                  decoration: InputDecoration(
                    hintText: 'Pickup Location',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _destination,
                  decoration: InputDecoration(
                    hintText: 'Destination',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Date',
                    filled: true,
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await _selectDate(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    hintText: 'Time',
                    filled: true,
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await _selectTime(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Select Vehicle Type"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                  ),
                  hint: Text('Select Vehicle Type'),
                  value: _selectedVehicleType,
                  items: <String>['Small', 'Medium', 'Large'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedVehicleType = newValue!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF08B480),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  onPressed: searchData,
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
