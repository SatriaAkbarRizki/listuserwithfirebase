import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:listuserwithfirebase/model/user.dart';
import 'package:listuserwithfirebase/presenter/presenter.dart';
import 'package:listuserwithfirebase/view/viewadd.dart';
import 'package:listuserwithfirebase/view/viewedit.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({super.key});

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  bool selectbox = false;
  Presenter presenter = Presenter();
  List<User> userList = <User>[];

  @override
  void initState() {
    dataUser();
    super.initState();
  }

  void dataUser() async {
    presenter.parsingData().then((value) {
      userList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    userList.forEach((element) {
      print(element.name);
    });
    print(userList.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('List User'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAdd(),
                    ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          ;
        },
        child: FutureBuilder<List<User>>(
          future: presenter.parsingData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return Column(
                  children: [listUser(userList)],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget listUser(List<User> user) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: userList.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (context, index) => Slidable(
          endActionPane: ActionPane(motion: ScrollMotion(), children: [
            SlidableAction(
              backgroundColor: Colors.red,
              onPressed: (context) {
                presenter.deleteData(user[index].id!);
                setState(() {});
              },
              icon: Icons.delete,
            )
          ]),
          child: ListTile(
            leading: CircleAvatar(),
            title: Text(user![index].name),
            subtitle: Text(user[index].address),
            onLongPress: () {},
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewEdit(
                      id: user[index].id!,
                      name: user[index].name,
                      address: user[index].address,
                    ),
                  ));
            },
          )),
    );
  }
}
