import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/page_header.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  const EditProfilePage({super.key, required this.username});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Existing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // New controllers and state variables
  final TextEditingController countryController = TextEditingController();
  String? _selectedGender = 'Male';
  int _selectedBanner = 0;
  int _selectedFrame = 0;
  File? _bannerImageFile;

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  Future<void> _pickBannerImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _bannerImageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.username.split('@')[0];
    bioController.text = "A passionate traveler exploring the wonders of Japan!"; // Default bio
    countryController.text = "Japan"; // Default country
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PageHeader(title: "Edit Profile"),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              _buildBannerSection(),
              const SizedBox(height: 20),
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'profile_picture',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.deepPurpleAccent, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/Cerydra.jpg'),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1A237E), width: 2),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Form Fields
              _buildTextField(controller: nameController, label: "Display Name"),
              const SizedBox(height: 20),
              _buildDropdownField(),
              const SizedBox(height: 20),
              _buildTextField(controller: countryController, label: "Country of Origin"),
              const SizedBox(height: 20),
              _buildTextField(controller: bioController, label: "Bio", maxLines: 4),
              const SizedBox(height: 30),

              // Banner & Frame Selectors
              _buildSelector(
                title: "Profile Banner",
                selectedIndex: _selectedBanner,
                itemCount: 5,
                onSelect: (index) => setState(() => _selectedBanner = index),
              ),
              const SizedBox(height: 20),
              _buildSelector(
                title: "Avatar Frame",
                selectedIndex: _selectedFrame,
                itemCount: 5,
                onSelect: (index) => setState(() => _selectedFrame = index),
                isCircle: true,
              ),

              const SizedBox(height: 40),
              _buildSaveChangesButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return GestureDetector(
      onTap: _pickBannerImage,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: _bannerImageFile != null
              ? DecorationImage(
                  image: FileImage(_bannerImageFile!),
                  fit: BoxFit.cover,
                )
              : const DecorationImage(
                  image: AssetImage('assets/banner.png'),
                  fit: BoxFit.cover,
                ),
        ),
        child: const Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.white70,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, int? maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: _genders.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: "Gender",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: const Color(0xFF4A148C),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSelector({
    required String title,
    required int selectedIndex,
    required int itemCount,
    required Function(int) onSelect,
    bool isCircle = false,
  }) {
    final colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.purple];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onSelect(index),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: colors[index % colors.length].withOpacity(0.5),
                    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isCircle ? null : BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedIndex == index ? Colors.deepPurpleAccent : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: selectedIndex == index
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveChangesButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF651FFF),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        },
        child: const Text(
          "Save Changes",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}