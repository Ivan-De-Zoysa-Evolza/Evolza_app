import 'package:evolza_app/core/authentication.dart';
import 'package:evolza_app/Presentation/widgets/profile_styles.dart';
import 'package:evolza_app/Presentation/widgets/profile_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final ImagePicker _picker = ImagePicker();

  String? _currentName;
  String? _currentPhoneNumber;
  String? _profilePictureUrl;
  File? _selectedImage;
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

  void _showProfilePictureOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfileDialog(
          title: "Profile Picture",
          subtitle: "Choose an option",
          icon: Icons.camera_alt,
          children: [
            ProfileDialogButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImageFromGallery();
              },
              icon: Icons.photo_library,
              text: "Add Profile Picture",
              decoration: ProfileStyles.updateButtonDecoration,
            ),
            SizedBox(height: 15),
            if (_profilePictureUrl != null || _selectedImage != null)
              ProfileDialogButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _removeProfilePicture();
                },
                icon: Icons.delete_outline,
                text: "Remove Profile Picture",
                decoration: ProfileStyles.removeButtonDecoration,
              ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: ProfileStyles.profileDialogCancelTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Here you would typically upload the image to Firebase Storage
      // and update the user's profile with the image URL
      // For now, we'll just store it locally
      await _updateProfilePicture(image.path);
    }
  }

  Future<void> _updateProfilePicture(String imagePath) async {
    try {
      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${_currentUser!.uid}.jpg');

      await ref.putFile(File(imagePath));
      final downloadUrl = await ref.getDownloadURL();

      // Update user profile with the download URL
      Map<String, dynamic> updatedData = {
        'profilePictureUrl': downloadUrl,
      };
      await _authService.updateUserProfile(_currentUser!.uid, updatedData);

      setState(() {
        _profilePictureUrl = downloadUrl;
      });
    } catch (e) {
      // Handle error
      print('Error uploading profile picture: $e');
      // You might want to show a snackbar or dialog to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload profile picture. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeProfilePicture() async {
    try {
      // Delete from Firebase Storage if it exists
      if (_profilePictureUrl != null && _profilePictureUrl!.startsWith('http')) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${_currentUser!.uid}.jpg');

        await ref.delete();
      }

      // Update user profile to remove the picture URL
      Map<String, dynamic> updatedData = {
        'profilePictureUrl': null,
      };
      await _authService.updateUserProfile(_currentUser!.uid, updatedData);

      setState(() {
        _profilePictureUrl = null;
        _selectedImage = null;
      });
    } catch (e) {
      print('Error removing profile picture: $e');
      // Still update the profile even if deletion from storage fails
      Map<String, dynamic> updatedData = {
        'profilePictureUrl': null,
      };
      await _authService.updateUserProfile(_currentUser!.uid, updatedData);

      setState(() {
        _profilePictureUrl = null;
        _selectedImage = null;
      });
    }
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
              _profilePictureUrl = data['profilePictureUrl'];
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

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _showProfilePictureOptions,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: ProfileStyles.profileIconDecoration,
        child: _buildProfilePictureContent(),
      ),
    );
  }

  Widget _buildProfilePictureContent() {
    if (_selectedImage != null) {
      return ClipOval(
        child: Image.file(
          _selectedImage!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    } else if (_profilePictureUrl != null && _profilePictureUrl!.isNotEmpty) {
      // If it's a network URL (Firebase Storage URL)
      if (_profilePictureUrl!.startsWith('http')) {
        return ClipOval(
          child: Image.network(
            _profilePictureUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              );
            },
          ),
        );
      } else {
        // If it's a local file path
        return ClipOval(
          child: Image.file(
            File(_profilePictureUrl!),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              );
            },
          ),
        );
      }
    } else {
      return Icon(
        Icons.person,
        color: Colors.white,
        size: 50,
      );
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
                        _buildProfilePicture(),
                        SizedBox(height: 40),
                        _buildProfileInfo(),
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

  Widget _buildProfileInfo() {
    return Column(
      children: [
        ProfileInfoRow(
          icon: Icons.person,
          label: "Name",
          value: _currentName ?? "Not set",
        ),
        SizedBox(height: 12),
        ProfileInfoRow(
          icon: Icons.phone,
          label: "Phone Number",
          value: _currentPhoneNumber ?? "Not set",
        ),
      ],
    );
  }
}