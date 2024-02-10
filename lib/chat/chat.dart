import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      title: "Chat",
      subtitle: "Chat directly with Sheikh",
      isWithBackButton: true,
      bottomNav: SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: const ChatBox()),
      ),
      body: const ChatSpace(),
    );
  }
}

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: TextField(
          cursorColor: Colors.black38,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusColor: Colors.black12,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              ),
              labelText: "Start Chatting"),
        )),
        GestureDetector(
          onTap: () => print("dddd"),
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Image.asset("assets/icons/send.png", width: 20, height: 20),
            ),
          ),
        )
      ],
    );
  }
}

class ChatSpace extends StatelessWidget {
  const ChatSpace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, viewPortConstraint) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: viewPortConstraint.maxHeight),
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ChatCard(
              message: "Salam Alaykum, Alaykum Alaykum Alaykum ",
              width: viewPortConstraint.maxWidth,
              isUser: index == 1 ? true : false,
            );
          },
        ),
        // )
      );
    });
  }
}

class ChatCard extends StatelessWidget {
  final bool isUser;
  final String message;
  final double width;
  const ChatCard(
      {super.key,
      required this.isUser,
      required this.width,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width / 1.2),
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.black12,
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: isUser ? Colors.white : Colors.black)),
            )),
      ),
    );
  }
}
