import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listuserwithfirebase/model/user.dart';
import 'package:listuserwithfirebase/presenter/presenter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listuserwithfirebase/storage/cloudstorage.dart';

class ViewAdd extends StatefulWidget {
  const ViewAdd({super.key});

  @override
  State<ViewAdd> createState() => _ViewAddState();
}

class _ViewAddState extends State<ViewAdd> {
  CloudStorage cloudStorage = CloudStorage();
  Presenter presenter = Presenter();
  XFile? pathImage;
  File? imageProfile;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future sendData(String? image) async {
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
      try {
        final data = User(
            id: null,
            name: nameController.text,
            address: addressController.text,
            image: image != null ? image : null);
        presenter.saveData(data);
        setState(() {});
        nameController.clear();
        addressController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Succes Add User')));
        setState(() {});
      } catch (e) {
        print('Eror: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add New User'),
        actions: [
          IconButton(
              onPressed: () async {
                await cloudStorage.uploadImage(imageProfile).then((value) {
                  sendData(value ?? null);
                });
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
                    // cloudStorage.uploadImage(imageProfile!).then((value) {
                    //   print('links image? : ${value}');
                    // });
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
                ? Text('')
                : Image.file(File(pathImage!.path), fit: BoxFit.fill),
          )
        ],
      ),
    );
  }

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
