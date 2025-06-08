import 'package:evolza_app/core/authentication.dart';
import 'package:evolza_app/Presentation/widgets/profile_styles.dart';
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

  void _showModalPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
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
      _authService.getUserProfile(_currentUser!.uid).listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            setState(() {
              _currentName = data['name'] ?? '';
              _currentPhoneNumber = data['phoneNumber'] ?? '';
              _isDataLoaded = true;

              if ((_currentName == null || _currentName!.isEmpty ||
                  _currentPhoneNumber == null || _currentPhoneNumber!.isEmpty) &&
                  !_showPopup) {
                _showPopup = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showModalPopup();
                });
              }
            });
          }
        } else {
          setState(() {
            _isDataLoaded = true;
            _showPopup = true;
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
      decoration: ProfileStyles.popupContainerDecoration,
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
                      decoration: ProfileStyles.popupIconDecoration,
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Complete Your Profile",
                      style: ProfileStyles.popupTitleStyle,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please fill in your details to continue",
                      style: ProfileStyles.popupSubtitleStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Name",
                style: ProfileStyles.popupLabelStyle,
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
                decoration: ProfileStyles.textFieldDecoration(
                  hintText: "Enter your full name",
                  prefixIcon: Icons.person_outline,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Phone Number",
                style: ProfileStyles.popupLabelStyle,
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
                decoration: ProfileStyles.textFieldDecoration(
                  hintText: "Enter your phone number",
                  prefixIcon: Icons.phone_outlined,
                ),
              ),
              SizedBox(height: 35),
              Container(
                width: double.infinity,
                decoration: ProfileStyles.updateButtonDecoration,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      Map<String, dynamic> updatedData = {
                        'name': _nameController.text,
                        'phoneNumber': _phoneController.text,
                      };
                      await _authService.updateUserProfile(_currentUser!.uid, updatedData);
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
              decoration: ProfileStyles.mainContainerDecoration,
              child: Column(
                children: [
                  Text(
                    "Profile",
                    style: ProfileStyles.profileTitleStyle,
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: ProfileStyles.profileIconDecoration,
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
                        Container(
                          width: double.infinity,
                          decoration: ProfileStyles.editButtonDecoration,
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
                                  style: ProfileStyles.editButtonTextStyle,
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
      decoration: ProfileStyles.infoRowDecoration,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: ProfileStyles.infoIconDecoration,
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
                  style: ProfileStyles.infoLabelStyle,
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: ProfileStyles.infoValueStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}