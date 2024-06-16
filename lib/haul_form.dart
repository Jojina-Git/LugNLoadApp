import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'haul_list.dart';

void main() {
  runApp(MaterialApp(
    home: HaulForm(),
  ));
}

class HaulForm extends StatefulWidget {
  @override
  _HaulFormState createState() => _HaulFormState();
}

class _HaulFormState extends State<HaulForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedVehicleType;
  bool _shared = false;
  bool _seat = false;
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemNumberController = TextEditingController();
  final TextEditingController _itemLengthController = TextEditingController();
  final TextEditingController _itemWidthController = TextEditingController();
  final TextEditingController _itemHeightController = TextEditingController();
  final List<String> vehicleTypes = ['Small', 'Medium', 'Large'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  String? _validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select date';
    }
    return null;
  }

  String? _validateTime(TimeOfDay? time) {
    if (time == null) {
      return 'Please select time';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null || _selectedVehicleType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select date, time, and vehicle type.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Convert TimeOfDay to formatted string
      String formattedTime = _selectedTime!.format(context);

      FirebaseFirestore.instance.collection('PostHaul').add({
        'origin': _originController.text,
        'destination': _destinationController.text,
        'date': _selectedDate,
        'time': formattedTime, // Save formatted time string
        'vehicleType': _selectedVehicleType,
        'message': _messageController.text,
        'items': [  // Add items as an array obj
          {
            'name': _itemNameController.text,
            'number': int.parse(_itemNumberController.text),
            'length': double.parse(_itemLengthController.text),
            'width': double.parse(_itemWidthController.text),
            'height': double.parse(_itemHeightController.text),
          }
        ],
        'shared': _shared,
        'seat': _seat,
        'created': FieldValue.serverTimestamp(),
      }).then((_) {
        // Clear form after successful submission
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Form submitted successfully!'),
          ),
        );

        // Navigate to HaulList
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HaulList()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Haul Post'),
        backgroundColor: Color(0xFF08B480),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _originController,
                decoration: InputDecoration(labelText: 'Origin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter origin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter destination';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Date'),
                subtitle: _selectedDate == null
                    ? Text('Select date')
                    : Text('${_selectedDate!.toString().substring(0, 10)}'),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('Time'),
                subtitle: _selectedTime == null
                    ? Text('Select time')
                    : Text(_selectedTime!.format(context)),
                onTap: () => _selectTime(context),
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemNumberController,
                decoration: InputDecoration(labelText: 'Item Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemLengthController,
                decoration: InputDecoration(labelText: 'Item Length'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item length';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemWidthController,
                decoration: InputDecoration(labelText: 'Item Width'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item width';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemHeightController,
                decoration: InputDecoration(labelText: 'Item Height'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item height';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: InputDecoration(labelText: 'Vehicle Type'),
                items: vehicleTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedVehicleType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select vehicle type';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _shared,
                    onChanged: (bool? value) {
                      setState(() {
                        _shared = value ?? false;
                      });
                    },
                  ),
                  Text('Shared'),
                  Checkbox(
                    value: _seat,
                    onChanged: (bool? value) {
                      setState(() {
                        _seat = value ?? false;
                      });
                    },
                  ),
                  Text('Seat'),
                ],
              ),
              Divider(),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF08B480),
                  ),
                  child: Text('Submit'),
                ),
              ),
              SizedBox(height: 26),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HaulList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posted Hauls'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('PostHaul').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final hauls = snapshot.data!.docs;
          return ListView.builder(
            itemCount: hauls.length,
            itemBuilder: (context, index) {
              final haul = hauls[index];
              final origin = haul['origin'];
              final destination = haul['destination'];
              final date = (haul['date'] as Timestamp).toDate();
              final time = haul['time'];
              final vehicleType = haul['vehicleType'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate
                   print("Success");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Origin: $origin',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Destination: $destination',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Date: ${date.toString().substring(0, 10)}'),
                          Text('Time: $time'),
                          Text('Vehicle Type: $vehicleType'),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  // Delete the haul document from Firestore
                                  FirebaseFirestore.instance.collection('PostHaul').doc(haul.id).delete().then(
                                        (value) => print('Document Deleted Successfully'),
                                  ).catchError((error) => print('Failed to delete document: $error'));
                                },
                                child: Icon(Icons.delete),
                                backgroundColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}