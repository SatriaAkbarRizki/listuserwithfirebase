import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listuserwithfirebase/model/user.dart';
import 'package:listuserwithfirebase/presenter/presenter.dart';
import 'package:listuserwithfirebase/storage/cloudstorage.dart';

class ViewEdit extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String image;

  ViewEdit(
      {required this.id,
      required this.name,
      required this.address,
      required this.image,
      super.key});

  @override
  State<ViewEdit> createState() => _ViewEditState();
}

class _ViewEditState extends State<ViewEdit> {
  CloudStorage cloudStorage = CloudStorage();
  XFile? pathImage;
  File? imageProfile;
  Presenter presenter = Presenter();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    initValue();
    super.initState();
  }

  void initValue() {
    nameController.text = widget.name;
    addressController.text = widget.address;
  }

  void updateData(String image) {
    final name = nameController.text;
    final address = addressController.text;
    presenter.updateData(widget.id, name, address, image);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Succes Edit User')));
  }

  Widget build(BuildContext context) {
    print('image in view edit: ${widget.image}');
    print('length user edit: ${widget.name}');
    return Scaffold(
      appBar: AppBar(
        title: Text('View/Edit User'),
        actions: [
          IconButton(
              onPressed: () async {
                await cloudStorage.uploadImage(imageProfile).then((value) {
                  updateData(value!);
                });
                cloudStorage.deleteImage(widget.image);
                Navigator.pop(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'name',
                  hintText: 'add name',
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                  labelText: 'address',
                  hintText: 'add address',
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Get Phohto'),
                  onPressed: () async {
                    pathImage = await pickImage();
                    print('path image now: ${pathImage!.path}');
                  },
                ),
              ],
            ),
          ),
          Container(
              width: 350,
              height: 300,
              padding: EdgeInsets.all(20),
              child: pathImage?.path == null
                  ? Image(image: NetworkImage(widget.image.toString()))
                  : Image.file(File(pathImage!.path), fit: BoxFit.fill))
        ],
      ),
    );
  }

  // Problem Solving in image

  Future<XFile?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final imageTemp = File(image.path);
      setState(() => this.imageProfile = imageTemp);
      return image;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
  }
}

// Image.file(File(pathImage!.path), fit: BoxFit.fill)