import 'package:babaloworo/shared/quran_audio_config.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioUI {
  AudioPlayer audioPlayer = AudioPlayer();
  late QuranPlaylist audioPlaylist;
  ValueNotifier currentVerse = ValueNotifier<int>(0);
  init(List<SurahPlaylist> playlist, int reciterId) async {
    audioPlaylist =
        QuranPlaylist(listOfPlaylist: playlist, reciterId: reciterId);
    // print(audioPlaylist.listOfPlaylist);
    audioPlayer = audioPlaylist.audioPlayer;
  }

  listenForChanges() {
    audioPlayer.playerStateStream.listen((event) {
      final isPlaying = event.playing;
      final processingState = audioPlayer.processingState;
      if (isPlaying) {
        if (processingState == ProcessingState.completed) {
          currentVerse.value = currentVerse.value + 1;
        }
      }
    });
  }

  // enqueue() {
  //   final List<int> getStatus = getIndexToQueue();

  //   if (getStatus[1] > 0) {
  //     for (var i = getStatus[0]; i <= getStatus[1]; i++) {
  //       audioPlaylist.playlist.add(
  //           audioPlaylist.uriAudioSource(audioPlaylist.listOfPlaylist[i - 1]));
  //     }
  //     audioPlaylist.currentLastPlaylist = getStatus[1];

  //     return audioPlaylist.currentLastPlaylist;
  //   }
  //   return 0;
  // }

  // List<int> getIndexToQueue() {
  //   print(audioPlaylist.currentLastPlaylist);
  //   int remainValue = (audioPlaylist.listOfPlaylist.length) -
  //       audioPlaylist.currentLastPlaylist;
  //   if (remainValue >= audioPlaylist.perLoadPlaylist) {
  //     return [
  //       audioPlaylist.currentLastPlaylist + 1,
  //       ((audioPlaylist.currentLastPlaylist) + (audioPlaylist.perLoadPlaylist))
  //     ];
  //   }
  //   if (remainValue > 0) {
  //     return [audioPlaylist.currentLastPlaylist + 1, remainValue];
  //   }
  //   return [0, 0];
  // }
}
