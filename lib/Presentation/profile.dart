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

  // Method to show modal popup
  void _showModalPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevents back button from closing
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: _buildUpdatePopupContent(),
          ),
        );
      },
    );
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

              // Show modal popup if name or phone number is empty and popup is not already shown
              if ((_currentName == null || _currentName!.isEmpty ||
                  _currentPhoneNumber == null || _currentPhoneNumber!.isEmpty) &&
                  !_showPopup) {
                _showPopup = true;
                // Show modal popup after widget is built
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showModalPopup();
                });
              }
            });
          }
        } else {
          // If no profile data exists, show the popup
          setState(() {
            _isDataLoaded = true;
            _showPopup = true;
            // Show modal popup after widget is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showModalPopup();
            });
          });
        }
      });
    }
  }

  Widget _buildUpdatePopupContent() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.blue.shade50.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.blue.shade200.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Complete Your Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please fill in your details to continue",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  hintText: "Enter your full name",
                  hintStyle: TextStyle(
                    color: Colors.blue.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.blue.shade600,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade500, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade500, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  hintText: "Enter your phone number",
                  hintStyle: TextStyle(
                    color: Colors.blue.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.blue.shade600,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade500, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade500, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              SizedBox(height: 35),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade800],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      Map<String, dynamic> updatedData = {
                        'name': _nameController.text,
                        'phoneNumber': _phoneController.text,
                      };
                      await _authService.updateUserProfile(_currentUser!.uid, updatedData);

                      // Close the modal popup after successful update
                      Navigator.of(context).pop();
                      setState(() {
                        _showPopup = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Update Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50.withOpacity(0.3),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50.withOpacity(0.3),
              Colors.white.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 40,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.blue.shade50.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.blue.shade200.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Title inside the container
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        SizedBox(height: 40),
                        _buildProfileInfoRow(Icons.email_outlined, "Email", _currentUser!.email.toString()),
                        SizedBox(height: 20),
                        _buildProfileInfoRow(Icons.person_outline, "Name", _currentName ?? 'Name not set'),
                        SizedBox(height: 20),
                        _buildProfileInfoRow(Icons.phone_outlined, "Phone", _currentPhoneNumber ?? 'Phone not set'),
                        SizedBox(height: 50),
                        // Edit Profile Button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.blue.shade800],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _showModalPopup,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit_outlined, size: 24),
                                SizedBox(width: 10),
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}