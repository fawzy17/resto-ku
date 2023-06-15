import 'package:flutter/material.dart';
import 'package:restoku/helpers/datasource/resto_database.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key, required this.restoDatabase}) : super (key: key);

  RestoDatabase restoDatabase;
  @override
  State<RegisterView> createState() => _RegisterViewState(restoDatabase:  restoDatabase);
}

class _RegisterViewState extends State<RegisterView> {
  _RegisterViewState({required this.restoDatabase});
  RestoDatabase restoDatabase;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: FutureBuilder(
        // future: accountDataSource.getAllAccount(),
        future: restoDatabase.selectAllAccount(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].email ?? 'Guest'),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
