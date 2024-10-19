import 'package:flutter/material.dart';
import 'package:flutter_todos_app/common/styles/color_palettes.dart';
import 'package:flutter_todos_app/constants/app_sizes.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: Sizes.p20),
            const Text(
              "Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: Sizes.p12),
            _buildProfileImage(),
            const SizedBox(height: Sizes.p12),
            const Text(
              "Shaune",
              style: TextStyle(
                color: ColorPalettes.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text(
              "shane@gmail.com",
              style: TextStyle(
                color: ColorPalettes.blue,
              ),
            ),
            const SizedBox(height: Sizes.p20),
            _buildCircleIconsRow(),
            const SizedBox(height: Sizes.p16),
            _buildSettingsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: _imageFile != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(_imageFile!),
                  )
                : const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://picsum.photos/100'),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Transform.translate(
            offset: const Offset(0, 14),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalettes.green,
                border: Border.all(
                  color: ColorPalettes.white,
                  width: 2.0,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit),
                iconSize: 12.0,
                color: ColorPalettes.white,
                onPressed: _showImagePickerOptions,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleIconsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleIcon(Icons.hourglass_empty, ColorPalettes.red),
        _buildCircleIcon(Icons.fire_hydrant, ColorPalettes.green),
        _buildCircleIcon(Icons.handshake, ColorPalettes.blue),
      ],
    );
  }

  Widget _buildCircleIcon(IconData iconData, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 244, 239, 239),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 18,
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem("First", Icons.power_off_outlined),
          const Divider(),
          _buildSettingsItem("Second", Icons.access_alarm),
          const Divider(),
          _buildSettingsItem("Third", Icons.ac_unit_rounded),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String text, IconData iconData) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
