import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _fNameController;
  late TextEditingController _lNameController;
  late TextEditingController _phoneController;

  String? profileImage;
  File? _pickedImageFile;

  bool _isLoading = true;
  bool _isSaving = false;

  // Edit flags
  bool _isEditingFName = false;
  bool _isEditingLName = false;
  bool _isEditingPhone = false;

  @override
  void initState() {
    super.initState();
    _fNameController = TextEditingController();
    _lNameController = TextEditingController();
    _phoneController = TextEditingController();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse(
        "https://mobilebanking-bankend-node-js.onrender.com/users/${widget.username}",
      );
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _fNameController.text = data["fName"] ?? "";
          _lNameController.text = data["lName"] ?? "";
          _phoneController.text = data["phone"] ?? "";
          profileImage = data["profileImage"];
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load user info")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Server error")));
    }
    setState(() => _isLoading = false);
  }

  Future<void> pickProfileImageUrl() async {
    TextEditingController urlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Image URL"),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: "https://example.com/image.jpg",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  profileImage = urlController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveProfile() async {
    setState(() => _isSaving = true);

    final url = Uri.parse("https://mobilebanking-bankend-node-js.onrender.com/profile/update");

    final body = {
      "username": widget.username,
      "fName": _fNameController.text,
      "lName": _lNameController.text,
      "phone": _phoneController.text,
      "profileImage": profileImage ?? "",
    };

    try {
      final res = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update profile")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update error")));
    }

    setState(() {
      _isSaving = false;
      _isEditingFName = false;
      _isEditingLName = false;
      _isEditingPhone = false;
    });
  }

  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditToggle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: TextField(
        readOnly: !isEditing,
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isEditing ? FontWeight.bold : FontWeight.normal,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: isEditing ? Colors.white10 : Colors.white24,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isEditing ? Colors.yellow : Colors.white54,
              width: isEditing ? 3.0 : 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isEditing ? Colors.yellowAccent : Colors.blue,
              width: isEditing ? 3.5 : 2.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.edit,
              color: isEditing ? Colors.yellow : Colors.white,
            ),
            onPressed: onEditToggle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Stack(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white24,
                            backgroundImage: (_pickedImageFile != null)
                                ? FileImage(_pickedImageFile!)
                                : (profileImage != null &&
                                          profileImage!.isNotEmpty
                                      ? NetworkImage(profileImage!)
                                      : null),
                            child:
                                (_pickedImageFile == null &&
                                    (profileImage == null ||
                                        profileImage!.isEmpty))
                                ? Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: GestureDetector(
                            onTap: pickProfileImageUrl,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    _buildEditableRow(
                      label: "First Name",
                      controller: _fNameController,
                      isEditing: _isEditingFName,
                      onEditToggle: () {
                        setState(() => _isEditingFName = !_isEditingFName);
                      },
                    ),
                    SizedBox(height: 20),
                    _buildEditableRow(
                      label: "Last Name",
                      controller: _lNameController,
                      isEditing: _isEditingLName,
                      onEditToggle: () {
                        setState(() => _isEditingLName = !_isEditingLName);
                      },
                    ),
                    SizedBox(height: 20),
                    _buildEditableRow(
                      label: "Phone",
                      controller: _phoneController,
                      isEditing: _isEditingPhone,
                      onEditToggle: () {
                        setState(() => _isEditingPhone = !_isEditingPhone);
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 230,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade700,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _isSaving
                            ? CircularProgressIndicator(color: Colors.black)
                            : Text(
                                "Save All",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
