import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/http_exception.dart';
import 'package:makia_ai/providers/auth.dart';
import 'package:makia_ai/providers/camera_list.dart';

/*
    Renders the Delete-Account-Pop-Up Widget
 */
class DeleteAccountPopUp extends StatefulWidget {
  @override
  State<DeleteAccountPopUp> createState() => _DeleteAccountPopUpState();
}

class _DeleteAccountPopUpState extends State<DeleteAccountPopUp> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 45,
            color: Colors.deepOrangeAccent,
          ),
          const SizedBox(width: 20),
          Text(
            'Confirm Deletion',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 21.5,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Are you sure you want to delete your Account?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18.5,
              ),
            ),
            Text(
              'This action can\'t be reverted',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: defaultPadding * 1.75),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.only(
                  top: defaultPadding,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: defaultPadding * 2,
                    height: defaultPadding * 2,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else
              TextButton(
                child: const Text('Yes, delete my Account'),
                onPressed: _deleteAccount,
              ),
          ],
        ),
      ),
    );
  }

  _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).deleteAccount(context);
      await Provider.of<CameraList>(context, listen: false).clearCameraList();

      Navigator.of(context).pop();

      // goes to the Home-Route and clears the Widget-Tree
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );

      Provider.of<CameraList>(context, listen: false).clearCameraList();
      Provider.of<Auth>(context, listen: false).logout();
    } on HttpException catch (error) {
      var errorMessage = 'Deleting your Account failed';

      if (error.toString().contains('INVALID_ID_TOKEN')) {
        errorMessage = 'The user\'s credentials are no longer valid.';
      } else if (error.toString().contains('USER_NOT_FOUND')) {
        errorMessage = 'There is no user record corresponding to this identifier.';
      }

      _showErrorDialog(errorMessage, context);
    } catch (error) {
      const errorMessage = 'Could not delete your Account. Please try again later.';

      _showErrorDialog(errorMessage, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error occured!'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }
}
