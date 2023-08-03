import 'package:flutter/material.dart';
import 'package:listuserwithfirebase/model/user.dart';
import 'package:listuserwithfirebase/presenter/presenter.dart';
import 'package:listuserwithfirebase/view/viewuser.dart';

class ViewAdd extends StatefulWidget {
  const ViewAdd({super.key});

  @override
  State<ViewAdd> createState() => _ViewAddState();
}

class _ViewAddState extends State<ViewAdd> {
  Presenter presenter = Presenter();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Future sendData() async {
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
      try {
        final data = User(
            id: null,
            name: nameController.text,
            address: addressController.text);
        print('value: ${data}');
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
      appBar: AppBar(
        title: Text('Add New User'),
        actions: [
          IconButton(
              onPressed: () async {
                await sendData();
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
