import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';

class MainDonation extends StatelessWidget {
  const MainDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return  ScaffoldContainer(title: "Donation", 
    isWithBackButton: true,
    body: Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Image.asset("assets/images/donation_illustrator.png",
                      width: 80, height: 80),
          Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Image.asset("assets/images/salam_script.png",
                        width: 225.49, height: 55),
                  ),
          const Text("The Donation features is coming soon"),
        ],
      ),
    ));
  }
}