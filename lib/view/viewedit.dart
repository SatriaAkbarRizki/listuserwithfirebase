import 'package:flutter/material.dart';
import 'package:listuserwithfirebase/model/user.dart';
import 'package:listuserwithfirebase/presenter/presenter.dart';

class ViewEdit extends StatefulWidget {
  final String id;
  final String name;
  final String address;

  ViewEdit(
      {required this.id, required this.name, required this.address, super.key});

  @override
  State<ViewEdit> createState() => _ViewEditState();
}

class _ViewEditState extends State<ViewEdit> {
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

  void updateData() {
    final name = nameController.text;
    final address = addressController.text;
    presenter.updateData(widget.id, name, address);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Succes Edit User')));
  }

  Widget build(BuildContext context) {
    print('length user edit: ${widget.name}');
    return Scaffold(
      appBar: AppBar(
        title: Text('View/Edit User'),
        actions: [
          IconButton(
              onPressed: () {
                updateData();
                Navigator.pop(context);
                setState(() {});
              },
              icon: Icon(Icons.save))
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
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'image',
                  hintText: 'link image',
                  border: OutlineInputBorder()),
            ),
          )
        ],
      ),
    );
  }
}
