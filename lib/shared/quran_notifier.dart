import 'package:babaloworo/local_resource/quran/quran_bus_logic.dart';
import 'package:babaloworo/shared/audio_notifier.dart';
import 'package:babaloworo/shared/basic_util.dart';
import 'package:babaloworo/shared/download_surah.dart';
import 'package:babaloworo/shared/quran_audio_config.dart';
import 'package:babaloworo/shared/quran_reciter.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class QuranNotifier extends ChangeNotifier {
  final audio = AudioUI();
  bool isPlaying = false;
  int currentPlay = 1;
  int reciterId = 1;
  int surahId = 1;
  int progress = 0;
  bool isReady = false;
  bool isLoading = false;
  bool isCompleted = true;
  int totalSurah = 0;
  List surahVerses = [];
  Map meta = {};
  bool isRepeated = false;

  QuranNotifier();
  initiate() async {
    return await init();

    // jumpTo(0);
    // isLoading = false;
    // notifyListeners();
  }

  changeReciter(int id) {
    reciterId = id;
    reset();
  }

  repeatVerse() {
    if (isPlaying) {
      if (!isRepeated) {
        audio.audioPlaylist.repeat();
      } else {
        audio.audioPlaylist.removeRepeat();
      }
      isRepeated = !isRepeated;
      notifyListeners();
    }
  }

  nextSurah(int surah) {
    surahId = surahId + surah;
    if (surahId > 0 && surahId <= 144) {
      getSpecificSurahVerses(surahId, reciterId);
      jumpTo(-1);
      // init();
      notifyListeners();
    }
  }

  getSpecificSurahVerses(int id, int reciter) async {
    reset();
    surahId = id;

    final QuranUtil surah = QuranUtil();

    final List result = await surah.getSurah(id);

    //fathia case: remove Bismillahi;
    if (id == 1) {
      result[1].removeAt(0);
    }
    surahVerses = result[1];
    totalSurah = surahVerses.length;
    meta = result[0];
    reciterId = reciter;

    notifyListeners();
  }

  reset() {
    if (isPlaying) {
      audio.audioPlayer.stop();
      isPlaying = false;
    }
    currentPlay = 1;
    isReady = false;
    isLoading = false;
    // // audio.audioPlayer.seek(Duration.zero, index: 0);
    // notifyListeners();
  }

  Future init() async {
    final QuranUtil surahR = QuranUtil();
    final List resultSurah = await surahR.getSurah(surahId);

    const httpUri = 'https://www.everyayah.com/data/';

    final findReciter =
        reciters.where((element) => element["id"] == reciterId).first;
    String reciterName = findReciter["name"].toString();
    String size = findReciter["suffix"].toString();

    String uri = "$httpUri$reciterName$size";
    String formatSurah = "${formatNumber(surahId, 3)}";
    final surahInArabic = QuranUtil();
    final result = await surahInArabic.getSurahName(surahId);
    final playList = <SurahPlaylist>[];
    int numTotal = int.parse(resultSurah[0]["totalVerse"]);
    for (var i = 1; i <= numTotal; i++) {
      String formatVerse = "${formatNumber(i, 3)}";
      playList.add(SurahPlaylist(
          surahId: surahId,
          uri: "$uri$formatSurah$formatVerse.mp3",
          surahVerse: i,
          surahInArabic: result["surahTransliteration"]));
    }
    try {
      audio.init(playList, reciterId);
      await addNewPlaylist(audio.audioPlaylist.listOfPlaylist, reciterId);
      isLoading = false;
      listening();
      audio.audioPlayer.play();
      isPlaying = true;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;

      notifyListeners();
      return false;
      // ignore: use_build_context_synchronously
    }
  }

  Future<bool> addNewPlaylist(
      List<SurahPlaylist> listOfPlaylist, int reciterId) async {
    //create folder

    final downloadSurah = DownloadSurah();
    final directoryPath = await downloadSurah.getDirectoryPath();

    final reciter =
        reciters.where((element) => element['id'] == reciterId).first;
    totalSurah = listOfPlaylist.length;
    for (var i = 0; i < listOfPlaylist.length; i++) {
      //check If verse Exist
      String checkVerse = await downloadSurah.savedIntoDirector(
          listOfPlaylist[i].surahId,
          listOfPlaylist[i].surahVerse,
          "${reciter['name']}",
          listOfPlaylist[i].uri,
          directoryPath);
      if (checkVerse == "false") {
        throw ErrorDescription("Something Went wrong");
      }
      listOfPlaylist[i].uri = checkVerse;
      progress = i;
      notifyListeners();
      await audio.audioPlaylist.playlist
          .add(audio.audioPlaylist.uriAudioSource(listOfPlaylist[i]));
      await Future.microtask(() => {});
    }
    audio.audioPlaylist.startPlayer();
    return true;
  }

  playPauseQuran() async {
    if (isReady == false) {
      try {
        isLoading = true;
        notifyListeners();
        final result = await initiate();
        if (result) isPlaying = true;
        return result;
      } catch (e) {
        return;
      }
    }

    if (isPlaying) {
      audio.audioPlayer.pause();
    } else {
      audio.audioPlayer.play();
    }
    isPlaying = !isPlaying;
    notifyListeners();
    return true;
  }

  seekToIndex(int index) async {
    if (isReady) {
      audio.audioPlayer.seek(Duration.zero, index: index - 1);
      currentPlay = index - 1;
      playPauseQuran();
      notifyListeners();
    } else {
      await playPauseQuran();

      audio.audioPlayer.seek(Duration.zero, index: index - 1);

      currentPlay = index - 1;
      notifyListeners();
    }
  }

  updateVerse(int value) {
    currentPlay = value;
  }

  listening() {
    audio.audioPlayer.sequenceStateStream.listen((sequenceState) {
      final currentItem = sequenceState?.currentSource;
      final mediaItem = currentItem?.tag;
      int currentValue = int.parse(mediaItem?.id?.split('_')[1] ?? '1');
      currentPlay = currentValue;
      if (isPlaying) {
        jumpTo(currentValue);
      }
      notifyListeners();
    });

    audio.audioPlayer.playerStateStream.listen((event) {
      final isPlaying = event.playing;

      final processingState = audio.audioPlayer.processingState;
      if (isPlaying) {
        if (processingState == ProcessingState.ready && isReady == false) {
          isReady = true;

          notifyListeners();
        }
        if (processingState == ProcessingState.completed) {
          reset();
        }
      }
    });
  }

  jumpTo(int index) {
    try {
      Scrollable.ensureVisible(GlobalObjectKey(index).currentContext!,
          duration: const Duration(milliseconds: 500));
    } catch (e) {
      return;
    }
  }

  @override
  dispose() {
    super.dispose();
    audio.audioPlayer.dispose();
  }
}
