import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'driverhaullist.dart';

class DriverHaulForm extends StatefulWidget {
  @override
  _DriverHaulFormState createState() => _DriverHaulFormState();
}

class _DriverHaulFormState extends State<DriverHaulForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedVehicleType;
  bool _shared = false;
  bool _seat = false;
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _fareController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final List<String> vehicleTypes = ['Small', 'Medium', 'Large'];
  File? _image;
  String? _imageUrl;

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

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          _imageUrlController.text = pickedFile.path;
          _imageUrl = pickedFile.path;
        } else {
          _image = File(pickedFile.path);
          _imageUrlController.text = '';
        }
      });
    }
  }

  void _setImageFromUrl(String url) {
    setState(() {
      _imageUrl = url;
      _image = null;
    });
  }

  void _submitForm() async {
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

      try {
        final docRef = await FirebaseFirestore.instance.collection('DriverPostHaul').add({
          'origin': _originController.text,
          'destination': _destinationController.text,
          'date': _selectedDate,
          'time': _selectedTime!.format(context),
          'fare': double.parse(_fareController.text),
          'vehicleType': _selectedVehicleType,
          'driverName': _driverNameController.text,
          'carName': _carNameController.text,
          'shared': _shared,
          'seat': _seat,
          'profileImageUrl': _imageUrl,
          'created': FieldValue.serverTimestamp(),
        });

        if (_image != null) {
          final storageRef = FirebaseStorage.instance.ref().child('profile_images').child(docRef.id);
          await storageRef.putFile(_image!);
          final imageUrl = await storageRef.getDownloadURL();
          setState(() {
            _imageUrl = imageUrl;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Form submitted successfully!'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverHaulList()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Driver Haul Post'),
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
                decoration: InputDecoration(
                  labelText: 'Origin',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the origin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the destination';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Date'),
                subtitle: _selectedDate == null
                    ? Text('Select date')
                    : Text('${_selectedDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('Time'),
                subtitle: _selectedTime == null
                    ? Text('Select time')
                    : Text(_selectedTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fareController,
                decoration: InputDecoration(
                  labelText: 'Fare',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fare';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _driverNameController,
                decoration: InputDecoration(
                  labelText: 'Driver Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the driver name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _carNameController,
                decoration: InputDecoration(
                  labelText: 'Car Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                  border: OutlineInputBorder(),
                ),
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
                    return 'Please select a vehicle type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
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
              ListTile(
                title: Text('Profile Image'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_imageUrl == null && _image == null)
                      Text('No image selected')
                    else if (_imageUrl != null)
                      Image.network(_imageUrl!)
                    else
                      Image.file(_image!),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: _selectImage,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF08B480), // Text color
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
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
        selectedItemColor: Colors.black, // Icon color for selected item
        unselectedItemColor: Colors.black, // Icon color for unselected item
        backgroundColor: Color(0xFF08B480),
      ),
    );
  }
}