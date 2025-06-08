import 'package:evolza_app/Presentation/widgets/widgets.dart';
import 'package:evolza_app/core/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String? _currentName;
  String? _currentPhoneNumber;
  String? _profilePictureUrl;
  bool _showPopup = false;
  bool _isDataLoaded = false;

  Future<void> _update() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
      };
      await _authService.updateUserProfile(_currentUser!.uid, updatedData);

      // Close the popup after successful update
      if (_showPopup) {
        setState(() {
          _showPopup = false;
        });
      }
    }
  }

  void _showUpdatePopup() {
    setState(() {
      _showPopup = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_currentUser != null) {
      // Listen to profile changes in real-time
      _authService.getUserProfile(_currentUser!.uid).listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            setState(() {
              _currentName = data['name'] ?? '';
              _currentPhoneNumber = data['phoneNumber'] ?? '';
              _isDataLoaded = true;

              // Show popup if name or phone number is empty and popup is not already shown
              if ((_currentName == null || _currentName!.isEmpty ||
                  _currentPhoneNumber == null || _currentPhoneNumber!.isEmpty) &&
                  !_showPopup) {
                _showPopup = true;
              }
            });
          }
        } else {
          // If no profile data exists, show the popup
          setState(() {
            _isDataLoaded = true;
            _showPopup = true;
          });
        }
      });
    }
  }

  Widget _buildUpdatePopup() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Complete Your Profile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text("Name"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Phone number"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _update,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main profile content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Text("Profile", style: headings),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text("Email: ${_currentUser!.email.toString()}", style: detailText),
                        Text(_currentName ?? 'Name not set', style: detailText),
                        Text(_currentPhoneNumber ?? 'Phone not set', style: detailText),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  // Add an edit button to show popup again if needed
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showUpdatePopup,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: Text("Edit Profile"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Popup overlay
          if (_showPopup && _isDataLoaded) _buildUpdatePopup(),
        ],
      ),
    );
  }
}