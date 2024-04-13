import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final String iconName;
  final Function action;
  final bool isGradient;
  final String subtitle;
  final FontWeight fontWeight;
  final bool? isAction;
  final Color color;
  const ListCard(
      {super.key,
      required this.title,
      required this.action,
      this.color = Colors.black,
      this.isAction = true,
      this.fontWeight = FontWeight.w500,
      this.subtitle = "",
      this.isGradient = false,
      this.bgColor = Colors.white,
      this.iconName = "",
      this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: !isGradient
            ? BoxDecoration(
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),

                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1.5, color: Colors.black45),
              )
            : BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFF500), Color(0xFFFFBF0B)]),
                borderRadius: BorderRadius.circular(8),
              ),
        child: Row(
          children: [
            if (iconName.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  child: Image.asset(
                    "assets/icons/$iconName.png",
                    width: 21,
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraint) => ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Column(
                            textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: fontWeight,
                                  fontSize: 16,
                                  color: color
                                ),
                              ),
                              subtitle.isNotEmpty
                                  ? Text(
                                      subtitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.black54),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                    isAction == true
                        ? Image.asset(
                            "assets/icons/right_arrow.png",
                            width: 6,
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
