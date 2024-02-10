import 'dart:convert';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/basic_util.dart';
import 'package:babaloworo/shared/quote_share.dart';
import 'package:babaloworo/shared/quran_notifier.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:babaloworo/shared/shared_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// import 'package:provider/provider.dart';

class QuranReading extends ConsumerStatefulWidget {
  final int id;
  final int verse;
  final int reciter;
  const QuranReading(
      {super.key, this.id = 1, this.verse = -1, this.reciter = 1});

  @override
  ConsumerState<QuranReading> createState() => _QuranReadingState();
}

class _QuranReadingState extends ConsumerState<QuranReading> {
  bool isDarkMode = false;
  bool isTranslated = true;
  List surahVerses = [];
  Map<String, String> meta = {};

  firstTimeBookmark() async {
    final data = SecuredStorage();
    final result = await data.readData(key: "bookmarks");
    if (result == null) {
      List<Map<String, String>> bookmark = [{}];
      await data.writeData("bookmarks", jsonEncode(bookmark));
    }
  }

  audioJumpTo(int id) {
    Scrollable.ensureVisible(GlobalObjectKey(id).currentContext!);
  }

  jumpTo() {
    try {
      if (widget.verse >= 0) {
        Future.delayed(
            const Duration(milliseconds: 500),
            () => Scrollable.ensureVisible(
                GlobalObjectKey(int.parse(widget.verse.toString()))
                    .currentContext!));
      }
    } catch (e) {
      return;
    }
  }

  checkStatus() {
    bool currentStatus = ref.read(quranNotifierProvider).isPlaying;
    if (currentStatus == false) {
      ref
          .read(quranNotifierProvider)
          .getSpecificSurahVerses(widget.id, widget.reciter);
    }
  }

  @override
  void initState() {
    super.initState();
    firstTimeBookmark();
    jumpTo();
    checkStatus();
  }

// QuranNotifier(
//           reciter: widget.reciter, surah: widget.id, verse: widget.verse)
  @override
  Widget build(BuildContext context) {
    List content = ref.watch(quranNotifierProvider).surahVerses;
    if (content.isEmpty) {
      return ScaffoldContainer(title: "", body: Container());
    }

    return ScaffoldContainer(
      color: isDarkMode ? Colors.black : Colors.white,
      title: ref.watch(quranNotifierProvider).meta['transliteration'],
      subtitle:
          "Verse 1 - ${ref.watch(quranNotifierProvider).meta['totalVerse']}",
      isWithBackButton: true,
      bottomNav: SafeArea(
        child: QuranBottomNav(
          translate: (translate) {
            setState(() {
              isTranslated = translate;
            });
          },
        ),
      ),
      height: 60,
      customDecoration: (!isDarkMode)
          ? (const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/quran_background_1.jpg"))))
          : null,
      body: SingleChildScrollView(
        child: QuranReadingAll(
            currentVerse: ref.watch(quranNotifierProvider).currentPlay,
            widget: widget,
            isDarkMode: isDarkMode,
            surahVerses: ref.watch(quranNotifierProvider).surahVerses,
            isTranslated: isTranslated),
      ),
      rightWidget: Row(
        children: [
          SizedBox(
            width: 130,
            height: 5,
            child: DropDownList(
              scrollTo: (value) {
                try {
                  Scrollable.ensureVisible(
                      GlobalObjectKey(int.parse(value.toString()))
                          .currentContext!);
                } catch (e) {
                  return;
                }
              },
              numbers: int.parse(ref
                  .watch(quranNotifierProvider)
                  .meta['totalVerse']
                  .toString()),
            ),
          ),

          // DropDownList(),
          Switch.adaptive(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
            activeColor: Colors.black54,
          )
        ],
      ),
    );
  }
}

class QuranReadingAll extends StatefulWidget {
  QuranReadingAll({
    super.key,
    required this.widget,
    required this.isDarkMode,
    required this.surahVerses,
    required this.isTranslated,
    required this.currentVerse,
  });

  final QuranReading widget;
  final bool isDarkMode;
  final List surahVerses;
  final bool isTranslated;
  int currentVerse;

  @override
  State<QuranReadingAll> createState() => _QuranReadingAllState();
}

class _QuranReadingAllState extends State<QuranReadingAll> {
  @override
  Widget build(BuildContext context) {
    // listening();

    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Taubah - No bismillahi
        widget.widget.id == 9
            ? Container()
            : Align(
                key: const GlobalObjectKey(-1),
                alignment: Alignment.center,
                child: Bismillahi(isDarkMode: widget.isDarkMode)),
        ...widget.surahVerses
            .map((verse) => EachQuranCard(
                  key: GlobalObjectKey(verse.verse),
                  currentVerse:
                      widget.currentVerse == int.parse(verse.verse.toString())
                          ? true
                          : false,
                  verse: verse.verse,
                  surah: widget.widget.id,
                  darkMode: widget.isDarkMode,
                  translation: "${verse.translation}",
                  transliteration: "${verse.transliteration}",
                  arabic: "${verse.arabic} ${arabicNumberConvert(verse.verse)}",
                  isTranslated: widget.isTranslated,
                ))
            .toList(),
        const SizedBox(height: 65)
      ],
    );
  }
}

class QuranBottomNav extends ConsumerStatefulWidget {
  final Function translate;
  const QuranBottomNav({super.key, required this.translate});

  @override
  ConsumerState<QuranBottomNav> createState() => _QuranBottomNavState();
}

class _QuranBottomNavState extends ConsumerState<QuranBottomNav> {
  bool isTranslated = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      height: 60,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TranslateVerse(
            isTranslated: isTranslated,
            translated: () {
              widget.translate(!isTranslated);
              setState(() {
                isTranslated = !isTranslated;
              });
            },
          ),
          PlayFeatures(
            nextVerse: (int value) {
              ref.read(quranNotifierProvider).nextSurah(value);
            },
            isPlaying: ref.watch(quranNotifierProvider).isPlaying,
          ),
          const RepeatVerse()
        ],
      ),
    );
  }
}

class PlayFeatures extends ConsumerWidget {
  final bool isPlaying;
  final Function nextVerse;
  const PlayFeatures(
      {super.key, required this.isPlaying, required this.nextVerse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ref.watch(quranNotifierProvider).surahId <= 1
              ? const Icon(Icons.skip_previous_rounded,
                  size: 30, color: Colors.black54)
              : GestureDetector(
                  onTap: () => nextVerse(-1),
                  child: const Icon(Icons.skip_previous_rounded, size: 30)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ref.watch(quranNotifierProvider).isLoading == true
                ? CircularProgressIndicator(
                    // backgroundColor: Colors.black,
                    // semanticsLabel: "0.5",
                    value: ((ref.watch(quranNotifierProvider).progress /
                                ref.watch(quranNotifierProvider).totalSurah) *
                            100) /
                        100,

                    color: Colors.black,
                  )
                : PlayPauseVerse(
                    size: 30,
                    isPlaying: isPlaying,
                    action: () async {
                      final isError = await ref
                          .watch(quranNotifierProvider)
                          .playPauseQuran();
                      if (isError == false) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Network Error!")));
                      }
                    }),
          ),
          ref.watch(quranNotifierProvider).surahId >= 114
              ? const Icon(Icons.skip_previous_rounded,
                  size: 30, color: Colors.black54)
              : GestureDetector(
                  onTap: () => nextVerse(1),
                  child: const Icon(Icons.skip_next_rounded, size: 30))
        ],
      ),
    );
  }
}

class TranslateVerse extends StatefulWidget {
  final Function translated;
  final bool isTranslated;
  const TranslateVerse(
      {super.key, required this.translated, required this.isTranslated});

  @override
  State<TranslateVerse> createState() => _TranslateVerseState();
}

class _TranslateVerseState extends State<TranslateVerse> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.translated(),
      child: widget.isTranslated
          ? Image.asset(
              "assets/icons/translate_solid.png",
              width: 25,
              // height: 20,
            )
          : Image.asset(
              "assets/icons/translate_none.png",
              width: 25,
              // height: 20,
            ),
    );
  }
}

class RepeatVerse extends ConsumerStatefulWidget {
  const RepeatVerse({super.key});

  @override
  ConsumerState<RepeatVerse> createState() => _RepeatVerseState();
}

class _RepeatVerseState extends ConsumerState<RepeatVerse> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {ref.read(quranNotifierProvider).repeatVerse()},
        child: ref.watch(quranNotifierProvider).isRepeated
            ? const Icon(Icons.repeat_on)
            : const Icon(Icons.repeat_outlined));
  }
}

class Bismillahi extends StatelessWidget {
  final bool isDarkMode;
  const Bismillahi({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 20),
      child: isDarkMode
          ? Image.asset(
              "assets/images/bismillahi_white.png",
              width: 155,
              height: 31,
            )
          : Image.asset(
              "assets/images/bismillahi.png",
              width: 155,
              height: 31,
            ),
    );
  }
}

class EachQuranCard extends StatefulWidget {
  final bool darkMode;
  final String translation;
  final String arabic;
  final String transliteration;
  final bool isTranslated;
  final int surah;
  final int verse;
  final bool currentVerse;
  const EachQuranCard(
      {super.key,
      required this.surah,
      required this.currentVerse,
      required this.verse,
      this.transliteration = "",
      required this.arabic,
      this.translation = "",
      this.darkMode = false,
      this.isTranslated = true});

  @override
  State<EachQuranCard> createState() => _EachQuranCardState();
}

class _EachQuranCardState extends State<EachQuranCard> {
  bool isLikedBool = false;

  checkBookmark(surah, verse) async {
    final data = SecuredStorage();
    bool isBookmarked = false;
    try {
      final result = await data.readData(key: "bookmarks");
      if (result != null) {
        final List decode = jsonDecode(result);
        final find = decode.where((element) =>
            element['surah'] == surah && element['verse'] == verse);
        isBookmarked = find.isNotEmpty;

        setState(() {
          isLikedBool = isBookmarked;
        });
      }
    } catch (e) {
      return false;
    }
  }

  addOrRemoveBookmark(surah, verse, isLiked) async {
    final storage = SecuredStorage();
    List data = [];
    final result = await storage.readData(key: "bookmarks");
    data = jsonDecode(result);
    if (!isLiked) {
      final newBookmark = {"surah": surah, "verse": verse};
      data.add(newBookmark);
      await storage.writeData("bookmarks", jsonEncode(data));
      setState(() {
        isLikedBool = true;
      });

      return;
    }

    data.removeWhere(
        (element) => element['surah'] == surah && element['verse'] == verse);
    await storage.writeData("bookmarks", jsonEncode(data));

    setState(() {
      isLikedBool = false;
    });
  }

  Color darkModeTextColor(isDark, {otherColor = Colors.black}) {
    if (isDark) return Colors.white;
    return otherColor;
  }

  Color darkModeBookmarkedColor(isDark,
      {otherColor = const Color(0xFFFBF2FF)}) {
    if (isDark) return Colors.transparent;
    return otherColor;
  }

  @override
  void initState() {
    super.initState();
    checkBookmark(widget.surah, widget.verse);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: QuoteShare(
                title: "Quran Verse",
                arabic: widget.arabic,
                english: widget.translation,
                reference: "${widget.surah} v ${widget.verse}"),
            withNavBar: false)
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: widget.isTranslated ? 4 : 0),
        color: isLikedBool
            ? darkModeBookmarkedColor(widget.darkMode)
            : Colors.transparent,
        child: Padding(
          padding: widget.isTranslated
              ? const EdgeInsets.symmetric(vertical: 6.0, horizontal: 3)
              : EdgeInsets.symmetric(horizontal: widget.darkMode ? 0 : 4),
          child: !widget.isTranslated
              ? ArabicText(
                  fontSize: 35,
                  color: darkModeTextColor(widget.darkMode),
                  arabic: widget.arabic)
              : Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 35,

                            // margin: const EdgeInsets.only(top: 20),
                            child: SideWidget(
                                verse: widget.verse,
                                isCurrentVerse: widget.currentVerse,
                                message: <String, String>{
                                  'verse': "Q${widget.surah}v${widget.verse}",
                                  'arabic': widget.arabic,
                                  'english': widget.translation,
                                  'transliteration': widget.transliteration
                                },
                                darkMode: widget.darkMode,
                                isLiked: isLikedBool,
                                favourite: () {
                                  addOrRemoveBookmark(
                                      widget.surah, widget.verse, isLikedBool);
                                })),
                        Expanded(
                          child: ArabicText(
                              fontSize: 34,
                              color: darkModeTextColor(widget.darkMode),
                              arabic: widget.arabic),
                        ),
                      ],
                    ),

                    // transliteration

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          textAlign: TextAlign.left,
                          widget.transliteration,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: darkModeTextColor(widget.darkMode),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    // english

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          textAlign: TextAlign.left,
                          widget.translation,
                          style: TextStyle(
                              color: darkModeTextColor(widget.darkMode,
                                  otherColor: const Color(0xFF670280))),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class SideWidget extends ConsumerStatefulWidget {
  final Function favourite;
  final bool isLiked;
  final bool darkMode;
  final Map<String, String> message;
  final bool isCurrentVerse;
  final int verse;
  const SideWidget(
      {super.key,
      required this.message,
      required this.verse,
      required this.favourite,
      required this.isCurrentVerse,
      required this.isLiked,
      this.darkMode = false});

  @override
  ConsumerState<SideWidget> createState() => _SideWidgetState();
}

class _SideWidgetState extends ConsumerState<SideWidget> {
  bool isLiked = false;
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => isShow = !isShow),
          child: widget.darkMode
              ? Image.asset(
                  "assets/icons/arrow_down_white.png",
                  width: 14.15,
                  height: 17.2,
                )
              : Image.asset(
                  "assets/icons/arrow_down.png",
                  width: 14.15,
                  height: 17.2,
                ),
        ),
        //hidden features
        isShow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        widget.favourite();
                      },
                      child: FavouriteIcon(
                          isLiked: widget.isLiked,
                          activeColor:
                              widget.darkMode ? Colors.white : Colors.red,
                          inactiveColor:
                              widget.darkMode ? Colors.white : Colors.black)),
                  ShareVerse(
                    full: true,
                    message: widget.message,
                    color: widget.darkMode ? Colors.white : Colors.black,
                  ),
                  PlayPauseVerse(
                      isPlaying: ref.watch(quranNotifierProvider).isPlaying
                          ? widget.isCurrentVerse
                          : false,
                      action: () {
                        if (widget.isCurrentVerse) {
                          ref.watch(quranNotifierProvider).playPauseQuran();
                        } else {
                          ref
                              .watch(quranNotifierProvider)
                              .seekToIndex(widget.verse);
                        }
                      },
                      color: widget.darkMode ? Colors.white : Colors.black)
                ],
              )
            : Container()
      ],
    );
  }
}

class FavouriteIcon extends StatefulWidget {
  final bool isLiked;
  final Color activeColor;
  final Color inactiveColor;
  const FavouriteIcon(
      {super.key,
      required this.isLiked,
      this.activeColor = Colors.red,
      this.inactiveColor = Colors.black});

  @override
  State<FavouriteIcon> createState() => _FavouriteIconState();
}

class _FavouriteIconState extends State<FavouriteIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 4),
        child: widget.isLiked
            ? Icon(
                color: widget.activeColor,
                Icons.favorite,
                size: 35,
              )
            : Icon(
                color: widget.inactiveColor,
                Icons.favorite_border_outlined,
                size: 35,
              ),
      ),
    );
  }
}

class ShareVerse extends StatelessWidget {
  final Color color;
  final Map<String, String> message;
  final String quote;
  final bool full;
  const ShareVerse(
      {super.key,
      this.color = Colors.black,
      this.full = false,
      required this.message,
      this.quote = "Quran"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              full
                  ? PersistentNavBarNavigator.pushNewScreen(context,
                      screen: QuoteShare(
                          title: "Quran Verse",
                          arabic: message['arabic'] ?? "",
                          english: message['english'] ?? "",
                          reference: message['verse'] ?? ""),
                      withNavBar: false)
                  : shareContent(
                      type: quote,
                      arabic: message['arabic'] ?? "",
                      english: message['english'] ?? " ",
                      transliteration: message['transliteration'] ?? "")
            },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Icon(Icons.share, color: color, size: 20),
        ));
  }
}

class PlayPauseVerse extends StatelessWidget {
  final double size;
  final Color color;
  final bool isPlaying;
  final Function action;
  const PlayPauseVerse(
      {super.key,
      this.size = 28,
      this.color = Colors.black,
      required this.action,
      required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {action()},
        child: isPlaying
            ? Icon(Icons.pause_outlined, size: size, color: color)
            : Icon(Icons.play_arrow_rounded, size: size, color: color));
  }
}

class DropDownList extends StatelessWidget {
  final int numbers;
  final Function scrollTo;
  const DropDownList(
      {super.key, required this.numbers, required this.scrollTo});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 100,
      hintText: "Jump to",
      expandedInsets: const EdgeInsets.all(0),
      // expandedInsets: const EdgeInsets.only(left: 2),
      trailingIcon: Image.asset(
        "assets/icons/arrow_down.png",
        width: 9.2,
        height: 6.15,
      ),
      selectedTrailingIcon: Image.asset(
        "assets/icons/arrow_up.png",
        width: 9.2,
        height: 6.15,
      ),
      menuStyle: const MenuStyle(
          maximumSize: MaterialStatePropertyAll(Size(100, 150)),
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          backgroundColor: MaterialStatePropertyAll(Colors.white)),

      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.zero,
          filled: false,
          outlineBorder: BorderSide.none,
          border: InputBorder.none),
      dropdownMenuEntries: List.generate(
        numbers,
        (index) => DropdownMenuEntry(value: index + 1, label: "${index + 1}"),
      ),
      onSelected: (value) {
        scrollTo(value);
      },
    );
  }
}

class DarkModeToggle extends StatefulWidget {
  const DarkModeToggle({super.key});

  @override
  State<DarkModeToggle> createState() => _DarkModeToggleState();
}

class _DarkModeToggleState extends State<DarkModeToggle> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
