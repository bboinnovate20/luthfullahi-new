import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:babaloworo/shared/download_surah.dart';
import 'package:babaloworo/shared/quran_reciter.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:just_audio_background/just_audio_background.dart';

class QuranPlaylist {
  ConcatenatingAudioSource playlist =
      ConcatenatingAudioSource(children: [], useLazyPreparation: true);
  List<SurahPlaylist> listOfPlaylist;
  int currentLastPlaylist = 0;
  final perLoadPlaylist = 2;
  AudioPlayer audioPlayer = AudioPlayer();
  int reciterId = 1;
  QuranPlaylist({required this.listOfPlaylist, required this.reciterId}) {
    // init();
    // startPlayer();
  }

  AudioSource uriAudioSource(SurahPlaylist uri) {
    return AudioSource.file(uri.uri,
        // tag: "${uri.surahId}_${uri.surahVerse}"
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: "${uri.surahId}_${uri.surahVerse}",
          // Metadata to display in the notification:
          album: "Quran Babaloworo",
          title: uri.surahInArabic,
        ));
  }

  // changePlaylist(List<SurahPlaylist> newPlaylist) {
  //   listOfPlaylist = addNewPlaylist(newPlaylist);
  // }

  startPlayer({index = 0}) async {
    await audioPlayer.setAudioSource(playlist,
        initialIndex: index, initialPosition: Duration.zero);
  }

  play() async {
    await audioPlayer.play();
  }

  skip(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
  }

  pause() async {
    await audioPlayer.pause();
  }

  repeat() {
    audioPlayer.setLoopMode(LoopMode.one);
  }

  removeRepeat() {
    audioPlayer.setLoopMode(LoopMode.off);
  }
}

class SurahPlaylist {
  final int surahId;
  final int surahVerse;
  final String surahInArabic;
  String uri;

  SurahPlaylist({
    required this.surahId,
    required this.uri,
    required this.surahVerse,
    required this.surahInArabic,
  });
}
