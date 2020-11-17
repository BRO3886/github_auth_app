import 'package:flutter/material.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    SimpleAuthFlutter.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  simpleAuth.GithubApi githubApi = simpleAuth.GithubApi(
    "github",
    "YOUR CLIENT ID",
    "YOUR CLIENT SECRET",
    "appname://auth", //your callback url from github oauth app
    scopes: [
      "user",
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Auth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Login'),
              onPressed: () => login(githubApi),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Logout'),
              onPressed: () => logout(githubApi),
            ),
          ],
        ),
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = new AlertDialog(
      content: new Text(text),
      actions: <Widget>[
        new FlatButton(
            child: const Text("Ok"),
            onPressed: () {
              //navigate to next page [TODO]
              Navigator.pop(context);
            })
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  void login(simpleAuth.AuthenticatedApi api) async {
    try {
      var success = await api.authenticate();
      print(success.toJson());
      //extract token from json, save it to flutter secure storage
      //save that user is logged in to a hive database
      showMessage("Logged in success: $success");
    } catch (e) {
      showError(e);
    }
  }

  void logout(simpleAuth.AuthenticatedApi api) async {
    await api.logOut();
    showMessage("Logged out");
  }
}
