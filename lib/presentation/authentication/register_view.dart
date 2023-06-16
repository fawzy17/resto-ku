import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restoku/helpers/datasource/account_datasource.dart';
import 'package:restoku/helpers/models/account_model.dart';
import 'package:restoku/presentation/authentication/login_view.dart';

// ignore: must_be_immutable
class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  AccountDatabase accountDatabase = AccountDatabase();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void register(
      List<AccountModel> registeredAccount, String email, int id) async {
    bool isRegistered = false;
    for (var account in registeredAccount) {
      if (account.email == email) {
        isRegistered = true;
        break;
      }
    }
    if (!isRegistered &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        EmailValidator.validate(emailController.text)) {
      await accountDatabase.insertAccount({
        'id': id,
        'name': nameController.text,
        'email': email,
        'password': passwordController.text,
        'role': 'user',
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: FutureBuilder(
        future: accountDatabase.database(),
        // future: restoDatabase.selectAllAccount(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name'),
                  TextField(
                    controller: nameController,
                  ),
                  Text('Email'),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                    ),
                  ),
                  Text('Password'),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        int id;
                        snapshot.data!.isNotEmpty
                            ? id = snapshot.data!.last.id! + 1
                            : id = 0;
                        register(snapshot.data!, emailController.text, id);
                        setState(() {
                          
                        });
                      },
                      child: Text('Register')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have account? '),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginView(),
                                ));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.blue),
                          )),
                    ],
                  ),
                  Text('account table'),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(snapshot.data![index].id.toString()),
                            Text(snapshot.data![index].name ?? 'Guest'),
                            Text(snapshot.data![index].email ?? 'Guest'),
                            Text(snapshot.data![index].password ?? 'Guest'),
                            Text(snapshot.data![index].role ?? 'Guest'),
                            ElevatedButton(
                                onPressed: () async {
                                  await accountDatabase
                                      .deleteAccount(snapshot.data![index].id);
                                  setState(() {});
                                },
                                child: Text('delete')),
                            ElevatedButton(
                                onPressed: () async {
                                  await accountDatabase.updateAccount(
                                      AccountModel(
                                          id: snapshot.data![index].id,
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          role: 'user'));
                                  setState(() {});
                                },
                                child: Text('update')),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
