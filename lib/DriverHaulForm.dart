import 'dart:io';
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
        _image = File(pickedFile.path);
        _imageUrlController.text = '';
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
                controller: _fareController,
                decoration: InputDecoration(labelText: 'Fare'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fare';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _driverNameController,
                decoration: InputDecoration(labelText: 'Driver Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carNameController,
                decoration: InputDecoration(labelText: 'Car Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle  name';
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
              ListTile(
                title: Text('Profile Image'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_imageUrl == null && _image == null)
                      Text('No image selected'),
                    if (_image != null)
                      Image.file(_image!, height: 100),
                    if (_imageUrl != null)
                      Image.network(_imageUrl!, height: 100),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      onChanged: _setImageFromUrl,
                    ),
                  ],
                ),
                onTap: _selectImage,
              ),
              SizedBox(height: 16),
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