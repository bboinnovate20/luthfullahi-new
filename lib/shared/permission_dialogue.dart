
import 'package:babaloworo/shared/location_util.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';




Future? showPermissionDialog(BuildContext context, String readStatus, String message, IconData icon) async {




  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Dialog with rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
               Icon(
                icon, // Location icon at the top
                size: 50,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 20),
               RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                  const TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold),
                      text: "As-salaam alaikum,\n"),
                    TextSpan(
                      text: message)]
                ),
               
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(           
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                     backgroundColor: Colors.red,
                     surfaceTintColor: Colors.red,
                    ) ,
                    child: const Text('Exit'),
                    onPressed: ()  {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  Container(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                       backgroundColor: Theme.of(context).colorScheme.primary,
                       surfaceTintColor: Colors.black,
                    ) ,
                    child: const Text('Continue'),
                    onPressed: () async {
                        final util = LocationUtil();
                        final permission = await util.askPermission();
                        if(readStatus == "false") {
                          openAppSettings();
                        }
                       // ignore: use_build_context_synchronously
                       Navigator.of(context).pop(permission);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  }
