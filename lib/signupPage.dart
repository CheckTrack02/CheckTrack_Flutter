import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/group/GroupPage.dart';
import 'package:checktrack/main.dart';
import 'package:checktrack/db/UserEntity.dart';

class LoginPage extends StatefulWidget {
  LoginPage();
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwController2 = TextEditingController();

  void onLoginPressed() async{
    Map res = await UserAPISystem.fetchUser(idController.text, pwController.text);
    
    if (res["statusCode"] == 200) {
      UserEntity userEntity = await APISystem.initUserEntity(res["userNo"]);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
            MyMain(userNo: res["userNo"])));
            //_MyApp(userNo: res["userNo"])));
    }
    else if (res["statusCode"] == 401) {
      showSnackBar(context, Text('Wrong identifier'));
    }
    else {
      showSnackBar(context, Text('Check your info again'));
    }     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        elevation: 0.0,
        backgroundColor: colorScheme.color4,
        centerTitle: true,
      ),
      body: GestureDetector(     
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( 
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 70)),
            Center(
              child: Image(
                image: AssetImage('assets/images/literature.png'),
                width: 170,
              ),
            ),
            Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: colorScheme.color4,
                  inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: colorScheme.color4, fontSize: 15.0))
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                          controller: idController,
                          decoration: InputDecoration(labelText: 'Enter id'),
                          keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: pwController,
                            decoration: InputDecoration(labelText: 'Enter password'),
                            keyboardType: TextInputType.text,
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          SizedBox(height: 40.0,),
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: ElevatedButton( 
                                onPressed: (){
                                  onLoginPressed();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.color4,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16.0, 
                                    color: Colors.white,
                                    ),
                                ),
                            )
                          )
                      ]),
                    )
                  )
                )
              ),
            ),
          ]
        )
      ),
    ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: colorScheme.color3,
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class NextPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}