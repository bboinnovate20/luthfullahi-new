import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  final String? name;
  const DeleteAccount({super.key,  this.name = ""});

  @override
  ConsumerState<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends ConsumerState<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    String confirm = "Yes";
    Future? showPermissionDialog(BuildContext context) async {
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
                  const Icon(
                    Icons.delete_forever, // Location icon at the top
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                      TextSpan(
                        style: TextStyle(fontWeight: FontWeight.bold),
                          text: "As-salaam alaikum,\n"),
                        TextSpan(
                          text: "All your personal details will be permanently removed. You will need to re-confirm your account to be sure if the request is really from you. Are you sure you want to continue with this request?")]
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
                        child: Text(confirm),
                        onPressed: () async {
                            setState(() {
                              confirm = "Deleting...";
                            });
                            await ref.read(userAuthentication).deleteAccount();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
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


    return Column(
      children: [
        GestureDetector(
                                  onTap: () async {
                                    await showPermissionDialog(context);
                                  },
                                      // ref.read(userAuthentication).googleSignOut(),
                                  child: Container(
                                    width: double.infinity,
                                    // margin: const EdgeInsets.only(top: 50, bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.red,
                                        border: Border.all(
                                            width: 1.5, color: Colors.black45)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        "Delete your Account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
      ],
    );

    
  }
}


String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}