import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/widgets/loading_dialog.dart';

/*
    Renders the Server-Verification-Pop-Up Widget
 */
class ServerVerificationPopUp extends StatefulWidget {
  @override
  State<ServerVerificationPopUp> createState() => _ServerVerificationPopUpState();
}

class _ServerVerificationPopUpState extends State<ServerVerificationPopUp> {
  Map<String, String> _serverAuthData = {
    'username': '',
    'password': '',
  };
  bool _passwordVisible;

  final _flushBar = Flushbar(
    backgroundColor: Colors.redAccent,
    title: 'Error',
    message: 'Something with the Server-Request went wrong!',
    duration: Duration(seconds: 6),
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(defaultPadding),
    padding: const EdgeInsets.all(10.5),
  );

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Server Verification:'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter your Username',
              ),
              onChanged: (value) => _serverAuthData['username'] = value,
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter your Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on the _passwordVisible state, choose the icon
                    _passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Theme.of(context).hintColor,
                  ),
                  onPressed: () {
                    // Update the state, i.e.: toogle the state of the _passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              onChanged: (value) => _serverAuthData['password'] = value,
              obscureText: !_passwordVisible, // This will obscure the text dynamically
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Continue'),
          onPressed: _serverLogIn,
        ),
        const SizedBox(width: defaultPadding / 3),
      ],
    );
  }

  Future<void> _serverLogIn() async {
    if (_serverAuthData['username'] != null && _serverAuthData['password'] != null) {
      BuildContext dialogContext;

      try {
        // Based on the dialogContext, show the CircularProgressIndicator and pop it afterwards
        showDialog(
          context: context,
          barrierDismissible: false, // prevents outside touch
          builder: (BuildContext context) {
            dialogContext = context;
            return LoadingDialog();
          },
        );

        await Provider.of<CameraList>(context, listen: false).setUsernameAndPassword(
          _serverAuthData['username'].trim(),
          _serverAuthData['password'].trim(),
        );
        await Provider.of<CameraList>(context, listen: false).fetchAndSet().then((_) {
          Navigator.pop(dialogContext); // pops the dialogContext
          Navigator.of(context).pop();
        });
      } catch (error) {
        Navigator.pop(dialogContext); // pops the dialogContext

        _flushBar.show(context);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "ERROR: All fileds have to be filled!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.redAccent,
          );
        },
      );
      throw ("Username or Password is null!");
    }
  }
}
