import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/shared/Components.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChatProvider with ChangeNotifier {
  var picker = ImagePicker();
  File? pickedImage;
  File? pickedVideo;
  bool isLoading = false;
  var messageControl = TextEditingController();
  String enteredMessage = '';
  String pathAudio = '';
  FlutterSoundRecorder? audioRecorder;
  FlutterSoundPlayer? audioPlay;
  bool isPlay = false;
  bool isRecord = false;
  bool isRecorderInitialised = false;
  String recordFilePath = '';
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = Duration.zero;
  int? index;
  VideoPlayerController videoPlayerController =
      VideoPlayerController.network('');
  bool isVideoPlay = true;
  bool isPortrait = true;
  bool showControl = true;

  void pickImage(String receiver, String docId) async {
    dynamic imageName = '';
    dynamic url = '';
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      pickedImage = File(pickedImageFile.path);
      notifyListeners();
    }
    if (pickedImage != null) {
      isLoading = true;
      notifyListeners();
      imageName = Uri.file(pickedImage!.path).pathSegments.last;
      final ref =
          FirebaseStorage.instance.ref().child('chat image').child(imageName);
      await ref.putFile(pickedImage!);
      url = await ref.getDownloadURL();
      var user = FirebaseAuth.instance.currentUser?.uid.toString();
      var currentUser =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(docId)
          .collection('chats')
          .add({
        'text': '',
        'time': Timestamp.now(),
        'sender': user,
        'senderName': currentUser['userName'],
        'senderImage': currentUser['image'],
        'senderCountry': currentUser['country'],
        'receiver': receiver,
        'image': url,
        'audio': '',
        'video': '',
        'timeOfDay':
            '${DateTime.now().hour > 12 ? (DateTime.now().hour - 12) : DateTime.now().hour}:${DateTime.now().minute} ${periodTime()}',
      });
      pickedImage = null;
      isLoading = false;
      notifyListeners();
    }
  }

  void pickVideo(String receiver, String docId) async {
    try {
      var pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );
      if (pickedFile != null) {
        pickedVideo = File(pickedFile.path);
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(File(pickedFile.path));
        await videoPlayerController.initialize();
        if (videoPlayerController.value.duration.inSeconds > 30) {
          pickedFile = null;
          showToast(
              text: 'لا يتم ارسال فيديو يتخطى الثلاثون ثانيه',
              state: ToastStates.WARNING);
          notifyListeners();
        } else {
          var user = FirebaseAuth.instance.currentUser?.uid.toString();
          showToast(
              text: 'انتظر حتى يتم رفع الفيديو', state: ToastStates.WARNING);
          FirebaseStorage.instance
              .ref()
              .child('chat videos')
              .child(Uri.file(pickedVideo!.path).pathSegments.last)
              .putFile(pickedVideo!)
              .then((value) {
            value.ref.getDownloadURL().then((videoUrl) async {
              var currentUser = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user)
                  .get();
              await FirebaseFirestore.instance
                  .collection('chatRoom')
                  .doc(docId)
                  .collection('chats')
                  .add({
                'text': '',
                'time': Timestamp.now(),
                'sender': user,
                'senderName': currentUser['userName'],
                'senderImage': currentUser['image'],
                'senderCountry': currentUser['country'],
                'receiver': receiver,
                'image': '',
                'audio': '',
                'video': videoUrl,
                'timeOfDay':
                    '${DateTime.now().hour > 12 ? (DateTime.now().hour - 12) : DateTime.now().hour}:${DateTime.now().minute} ${periodTime()}',
              });

              pickedVideo = null;
            });
          });
        }
      }
    } catch (e) {
      showToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  String? periodTime() {
    if (TimeOfDay.now().period == DayPeriod.am) {
      return 'AM';
    }
    if (TimeOfDay.now().period == DayPeriod.pm) {
      return 'PM';
    }
    return null;
  }

  void setMessage(String message) {
    enteredMessage = message;
    notifyListeners();
  }

  void sendMessage(BuildContext context, String receiver, String docId,
      [String? message]) async {
    FocusScope.of(context).unfocus();
    isLoading = true;
    notifyListeners();
    var user = FirebaseAuth.instance.currentUser?.uid.toString();
    var currentUser =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(docId)
        .collection('chats')
        .add({
      'text': message ?? enteredMessage,
      'time': Timestamp.now(),
      'sender': user,
      'senderName': currentUser['userName'],
      'senderImage': currentUser['image'],
      'senderCountry': currentUser['country'],
      'receiver': receiver,
      'image': '',
      'audio': '',
      'video': '',
      'timeOfDay':
          '${DateTime.now().hour}:${DateTime.now().minute} ${periodTime()}',
    });
    isLoading = false;
    messageControl.clear();
    enteredMessage = '';
    notifyListeners();
  }

  Future initRecord() async {
    audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission');
    }
    await audioRecorder!.openAudioSession();
    isRecorderInitialised = true;
    notifyListeners();
  }

  Future killRecord() async {
    if (!isRecorderInitialised) return;
    audioRecorder!.closeAudioSession();
    audioRecorder = null;
    isRecord = false;
    isRecorderInitialised = false;
    notifyListeners();
  }

  Future record() async {
    if (!isRecorderInitialised) return;
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String filePath =
        '${storageDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    await audioRecorder!.startRecorder(
      toFile: filePath,
    );
    pathAudio = filePath;
    notifyListeners();
  }

  Future stopRecord(String senderId, String receiverId, String docId) async {
    if (!isRecorderInitialised) return;
    await audioRecorder!.stopRecorder();
    isRecord = false;
    await uploadAudio(senderId, receiverId, docId);
    notifyListeners();
  }

  Future toggleRecording(
      String senderId, String receiverId, String docId) async {
    if (isRecord) {
      await record();
      notifyListeners();
    } else {
      await stopRecord(senderId, receiverId, docId);
      notifyListeners();
    }
  }

  void sendAudio(
      String url, String senderId, String receiverId, String docId) async {
    var user = FirebaseAuth.instance.currentUser?.uid.toString();
    var currentUser =
        await FirebaseFirestore.instance.collection('users').doc(user).get();

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(docId)
        .collection('chats')
        .add({
      'text': '',
      'time': Timestamp.now(),
      'sender': senderId,
      'senderName': currentUser['userName'],
      'senderImage': currentUser['image'],
      'senderCountry': currentUser['country'],
      'receiver': receiverId,
      'image': '',
      'audio': url,
      'video': '',
      'timeOfDay':
          '${DateTime.now().hour > 12 ? (DateTime.now().hour - 12) : DateTime.now().hour}:${DateTime.now().minute} ${periodTime()}'
    });
  }

  Future togglePlaying(url) async {
    var link = Uri.parse('$url');
    if (audioPlay!.isStopped) {
      await play(link);
      notifyListeners();
    } else {
      await stopPlay();
      notifyListeners();
    }
  }

  Future initPlayer() async {
    audioPlay = FlutterSoundPlayer();
    await audioPlay!.openAudioSession();
    notifyListeners();
  }

  Future disposePlayer() async {
    audioPlay!.closeAudioSession();
    audioPlay = null;
    isPlay = false;
    notifyListeners();
  }

  Future play(url) async {
    isPlay = true;
    final bytes = await readBytes(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');
    await file.writeAsBytes(bytes);
    await audioPlay!.startPlayer(fromURI: file.path, codec: Codec.mp3);
    if (recordFilePath != '' && File(recordFilePath).existsSync()) {
      recordFilePath = file.path;
      await audioPlay!.startPlayer(fromURI: recordFilePath, codec: Codec.mp3);
    }
    notifyListeners();
  }

  Future stopPlay() async {
    isPlay = false;
    await audioPlay!.stopPlayer();
    notifyListeners();
  }

  uploadAudio(String senderId, String receiverId, String docId) async {
    FirebaseStorage.instance
        .ref()
        .child('audio message')
        .child('${DateTime.now().millisecondsSinceEpoch.toString()}.aac')
        .putFile(File(pathAudio))
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        sendAudio(url, senderId, receiverId, docId);
      });
    });
  }

  Future<void> getAudio(url) async {
    if (isPlay) {
      await audioPlayer.pause();
      isPlay = false;
      notifyListeners();
    } else {
      audioPlayer.setUrl(url, isLocal: true);
      await audioPlayer.play(url, isLocal: true);
      isPlay = true;
      notifyListeners();
    }
    audioPlayer.onDurationChanged.listen((Duration d) {
      duration = d;
      notifyListeners();
    });
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      position = d;
      notifyListeners();
      if (position.inSeconds.toDouble() == duration.inSeconds.toDouble()) {
        position = Duration.zero;
        isPlay = false;
        notifyListeners();
      }
    });
  }

  void getSeek(value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
    notifyListeners();
  }

  void initVideoPlayer(String videoLink) async {
    videoPlayerController = VideoPlayerController.network(videoLink);
    await videoPlayerController.initialize();
    videoPlayerController.addListener(updateSliderPosition);
    videoPlayerController.play();
    isVideoPlay = true;
    notifyListeners();
  }

  void updateSliderPosition() {
    position = videoPlayerController.value.position;
    if (videoPlayerController.value.position.inSeconds != 0 &&
        videoPlayerController.value.position.inSeconds ==
            videoPlayerController.value.duration.inSeconds) {
      getVideoSeek(0);
    }
    notifyListeners();
  }

  void getVideoSeek(value) async {
    videoPlayerController.seekTo(Duration(seconds: value.toInt()));
    notifyListeners();
  }

  void changePortraitToLandscape(bool value) {
    if (!value) {
      isPortrait = value;
    } else {
      isPortrait = value;
    }
    notifyListeners();
  }

  void showControlVideo() {
    showControl = !showControl;
    notifyListeners();
  }

  void pauseAndPlayVideo() {
    if (isVideoPlay) {
      isVideoPlay = false;
      videoPlayerController.pause();
    } else {
      isVideoPlay = true;
      videoPlayerController.play();
    }
    notifyListeners();
  }

  void increaseOrDecrease(bool increase) {
    if (increase) {
      videoPlayerController.value.position.inSeconds + 5;
      getVideoSeek(videoPlayerController.value.position.inSeconds + 5);
    }
    if (!increase) {
      videoPlayerController.value.position.inSeconds - 5;
      getVideoSeek(videoPlayerController.value.position.inSeconds - 5);
    }
    notifyListeners();
  }

  void killVideo() async {
    videoPlayerController.removeListener(() {});
    videoPlayerController.pause();
    videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    notifyListeners();
  }

  List usersImage = [];

  void getRoomUsers(String docId) async {
    usersImage = [];
    var users = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(docId)
        .get();
    List allUsers = users['users'];
    for (int i = 0; i < allUsers.length; i++) {
      var image = await FirebaseFirestore.instance
          .collection('users')
          .doc(allUsers[i])
          .get();
      usersImage.add(image['image']);
      notifyListeners();
    }
    notifyListeners();
  }

  YoutubePlayerController youtubePlayerController =
      YoutubePlayerController(initialVideoId: '');

  void initializeYoutubePlayer(String videoLink) {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoLink).toString(),
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }
}
