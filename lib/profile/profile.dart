import 'package:babaloworo/admin_notification/admin_notification.dart';
import 'package:babaloworo/auth/auth_util.dart';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/primary_btn.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthenticatedProfile();
  }
}

class AuthenticatedProfile extends ConsumerWidget {
  const AuthenticatedProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserInfoI? user = ref.watch(userAuthentication).getCurrentUser();
    Future<bool> checkAdmin() async {
      if (user != null) {
        return await ref.watch(userAuthentication).checkisAdmin();
      }
      return false;
    }

    return ScaffoldContainerWithGradientImage(
        isWithBackButton: false,
        boxDecoration: const BoxDecoration(
            image: DecorationImage(
                scale: 2.0,
                fit: BoxFit.cover,
                image: AssetImage("assets/images/mosque_transparent.png")),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 218, 139, 242),
                  Color(0xFF62007B)
                ])),
        textColor: Colors.black,
        bgColor: const Color.fromARGB(255, 218, 139, 242),
        title: "Member Profile",
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder(
            future: checkAdmin(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  Positioned(
                    top: 15,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.height - 300,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 30),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Text(
                                  user?.displayName ?? "",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Text(
                                  "MEMBER",
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  "Jazakummullahi Khairan for your utmost support "),
                            ),
                            if (user != null)
                              ListCard(
                                title: "View Identity Card",
                                action: () =>
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: NavigatorNamed.idCardView(
                                            name: user.displayName ?? ""),
                                        withNavBar: false),
                                bgColor: Theme.of(context).colorScheme.primary,
                              ),
                            if (snapshot.data == true)
                              ListCard(
                                title: "Post for Notification",
                                action: () =>
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const NotificationForm(),
                                        withNavBar: false),
                                bgColor: Theme.of(context).colorScheme.primary,
                              ),
                            ListCard(
                              title: "Donate for Support",
                              action: () => {},
                              bgColor: Theme.of(context).colorScheme.primary,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  ref.read(userAuthentication).googleSignOut(),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1.5, color: Colors.black45)),
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Logout",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF4285F4), shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              acronym(user?.displayName.toString() ?? ""),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}

String acronym(String name) {

  return name.isEmpty
      ? ""
      : name.split(" ").length <= 1 ? "" : 
      "${name.split(" ")[0].split("")[0]}${name.split(" ")[1].split("")[0]}";
}

class NotAuthenticated extends StatelessWidget {
  const NotAuthenticated({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      title: "Member Profile",
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icons/no_user.png", width: 84, height: 84),
              Image.asset("assets/images/salam_script.png", width: 223.49),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Text(
                    "No User Login",
                    style: Theme.of(context).textTheme.displaySmall,
                  )),
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text("New or already or member")),
              PrimaryButton(
                  icon: "assets/icons/google.png",
                  title: "Register/Login with Google",
                  action: () => {})
            ]),
      ),
    );
  }
}
