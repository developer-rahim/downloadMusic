import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ayat/Services/download_button.dart';
import 'package:ayat/widgets/cnt.dart';
import 'package:ayat/widgets/custom_text.dart';
import 'package:ayat/widgets/loop_controll.dart';
import 'package:ayat/widgets/music_card.dart';
import 'package:ayat/widgets/position_seek_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import '../downloading_dialog.dart';
import '../provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Audio? selectedAudio;
   Future<void> main() async {
    await Hive.openBox('Favorite Songs');
  }
  late ViewModelProvider viewModelProvider;
  bool downloade=false;
  bool isNavShow = false;
  int globalIndex = 0;
  Random rnd = new Random();
  bool isShuffle = false;
  bool isLoop = false;
  LoopMode? loopMode;
  List<Audio> audioList = [
    Audio.network(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
        metas: Metas(
            title: 'Song1',
            artist: 'Artist1',
            album: 'album1',
            image: const MetasImage.network(
                'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg'),
            //: MetasImage.network("assets/images/country.jpg"),
            id: 'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg')),
    Audio.network(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
        metas: Metas(
            title: 'Song2',
            artist: 'Artist2',
            album: 'album1',
            image: const MetasImage.network(
                'https://tinypng.com/images/social/website.jpg'),
            id: 'https://tinypng.com/images/social/website.jpg')),
    Audio.network(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
        metas: Metas(
            title: 'Song3',
            artist: 'Artist3',
            album: 'album1',
            image: const MetasImage.network(
                'https://static.addtoany.com/images/dracaena-cinnabari.jpg'),
            id: 'https://static.addtoany.com/images/dracaena-cinnabari.jpg')),
  ];
  @override
  void initState() {
    super.initState();
    main();
    viewModelProvider = Provider.of<ViewModelProvider>(context, listen: false);
    audioPlayer.playlistAudioFinished.listen(
      (Playing playing) {
        print('playlistAudioFinished : $playing');
        if (viewModelProvider.isLoop == false) {
          if (globalIndex == (audioList.length - 1)) {
            globalIndex = 0;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
            // audioPlayer.playlistPlayAtIndex(globalIndex);
            setState(() {});
          } else if (globalIndex < audioList.length - 1) {
            globalIndex++;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
            //audioPlayer.playlistPlayAtIndex(globalIndex);
            setState(() {});
          }
        }

        //skipNext();

        audioPlayer.play();

//         //audioPlayer.next(keepLoopMode: true);
      },
    );

    setupPlaylist();
  }

  @override
  // void dispose() {
  //   super.dispose();
  //   audioPlayer.dispose();
  // }

  void setupPlaylist() async {
    audioPlayer.open(Playlist(audios: audioList),
        notificationSettings: NotificationSettings(
          customPrevAction: (player) {
            if (globalIndex > 0) {
              globalIndex--;
              setState(() {});
              selectedAudio = audioList[globalIndex];
              setState(() {});
              player.playlistPlayAtIndex(globalIndex);
              setState(() {});
            } else if (globalIndex == 0) {
              globalIndex = audioList.length - 1;
              setState(() {});
              selectedAudio = audioList[globalIndex];
              setState(() {});
              // player.previous(keepLoopMode: false);
              player.playlistPlayAtIndex(globalIndex);

              setState(() {});
            }
            // player.previous();
            audioPlayer.play();
          },
          customNextAction: (player) {
            if (globalIndex == (audioList.length - 1)) {
              globalIndex = 0;
              setState(() {});
              selectedAudio = audioList[globalIndex];
              setState(() {});
              audioPlayer.playlistPlayAtIndex(globalIndex);
              setState(() {});
            } else if (globalIndex < audioList.length - 1) {
              globalIndex++;
              setState(() {});
              selectedAudio = audioList[globalIndex];
              setState(() {});
              audioPlayer.playlistPlayAtIndex(globalIndex);
              setState(() {});
            }

            // player.next();
            audioPlayer.play();
          },
        ),
        showNotification: true,
        autoStart: false,
        loopMode: LoopMode.none

        // loopMode: isLoop == true ? LoopMode.single : LoopMode.none

        );
  }

  playMusic() async {
    await audioPlayer.play();

    //await audioPlayer.playlistPlayAtIndex(globalIndex);
  }

  pauseMusic() async {
    await audioPlayer.pause();
    // await audioPlayer.playlistPlayAtIndex(globalIndex);
  }

  skipPrevious() async {
    await audioPlayer.previous();

    // globalIndex--;
    // setState(() {});
    // await audioPlayer.prev();
  }

  skipNext() async {
    await audioPlayer.next();
    // globalIndex++;

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Music Player',
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // SizedBox(
              //   height: 10,
              // ),
             
              Container(
                alignment: Alignment.center,
                child:
                    audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                  return Column(
                    children: [
                      Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              itemCount: audioList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemExtent: 125,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    globalIndex = index;
                                    selectedAudio = audioList[globalIndex];
                                    isNavShow = true;
                                    setState(() {});
                                    isPlaying ? pauseMusic() : playMusic();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 100,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          audioList[index].metas.image!.path,
                                          height: 100,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          audioList[index].metas.title!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          audioList[index].metas.artist!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          audioList[index].metas.album!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //         iconSize: 50,
                      //         icon: Icon(Icons.skip_previous_rounded),
                      //         onPressed: () => skipPrevious()),
                      //     IconButton(
                      //         iconSize: 50,
                      //         icon: Icon(isPlaying
                      //             ? Icons.pause_rounded
                      //             : Icons.play_arrow_rounded),
                      //         onPressed: () =>
                      //             isPlaying ? pauseMusic() : playMusic()),
                      //     IconButton(
                      //         iconSize: 50,
                      //         icon: Icon(Icons.skip_next_rounded),
                      //         onPressed: () {
                      //           globalIndex++;
                      //           selectedAudio = audioList[globalIndex];

                      //           setState(() {});
                      //           skipNext();
                      //         }),
                      //   ],
                      // ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isNavShow == false
            ? Container(
                height: 50,
              )
            : audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        useRootNavigator: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: buildPlayer(),
                          );
                        });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 65,
                    decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 00),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      // topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(16)),
                                  child: Image.network(
                                    // selectedMuisc!.imageUrl,
                                    selectedAudio!.metas.image!.path,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    // text: selectedMuisc!.title,
                                    text: selectedAudio!.metas.title,
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    // text: selectedMuisc!.lebel,
                                    text: selectedAudio!.metas.artist!,
                                    color: Colors.cyanAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (globalIndex > 0) {
                                    globalIndex--;
                                    setState(() {});
                                    selectedAudio = audioList[globalIndex];
                                    setState(() {});
                                    audioPlayer
                                        .playlistPlayAtIndex(globalIndex);
                                    setState(() {});
                                  } else if (globalIndex == 0) {
                                    globalIndex = audioList.length - 1;
                                    setState(() {});
                                    selectedAudio = audioList[globalIndex];
                                    setState(() {});
                                    // player.previous(keepLoopMode: false);
                                    audioPlayer
                                        .playlistPlayAtIndex(globalIndex);
                                    setState(() {});
                                  }
                                  audioPlayer.play();
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 34,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                // audioPlayerState == PlayerState.PLAYING
                                //     ? pauseMusic()
                                //     : playMusic();
                                isPlaying ? pauseMusic() : playMusic();
                              },
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // audioPlayerState == PlayerState.PLAYING
                            //     //     ? pauseMusic()
                            //     //     : playMusic();
                            //     skipNext();
                            //     selectedAudio;
                            //     setState(() {});
                            //   },
                            //   child: Icon(
                            //     Icons.skip_next_rounded,
                            //     color: Colors.white,
                            //     size: 30,
                            //   ),
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  if (globalIndex == (audioList.length - 1)) {
                                    globalIndex = 0;
                                    setState(() {});
                                    selectedAudio = audioList[globalIndex];
                                    setState(() {});
                                    audioPlayer
                                        .playlistPlayAtIndex(globalIndex);
                                    setState(() {});
                                  } else if (globalIndex <
                                      audioList.length - 1) {
                                    globalIndex++;
                                    setState(() {});
                                    selectedAudio = audioList[globalIndex];
                                    setState(() {});
                                    audioPlayer
                                        .playlistPlayAtIndex(globalIndex);
                                    setState(() {});
                                  }
                                  //skipNext();
                                  // audioPlayer.next();
                                  audioPlayer.play();
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 34,
                                  color: Colors.white,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
  }

  Widget buildPlayer() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: ((context, setState) {
        return audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
          // return Consumer<ViewModelProvider>(
          //     builder: (context, viewModelProvider, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              toolbarHeight: 120,
              centerTitle: true,
              backgroundColor: Colors.black,
              elevation: 0.0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 26,
                  )),
              title: Column(
                children: [
                  CustomText(
                    text: selectedAudio!.metas.title,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  CustomText(
                    text: selectedAudio!.metas.artist,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    size: 26,
                  ),
                )
              ],
            ),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 40,
                  // ),
                  Container(
                    height: 200,
                    color: Colors.white,
                    child: Image.network(
                      selectedAudio!.metas.image!.path,
                      // height: height * 0.4,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: selectedAudio!.metas.title,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: selectedAudio!.metas.artist,
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border_outlined,
                            size: 30,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // audioPlayer.builderRealtimePlayingInfos(
                      //     builder: ((context, infos) {
                      //   return Text(
                      //     infos.currentPosition.inSeconds < 60
                      //         ? '00:${infos.currentPosition.inSeconds}'
                      //         : '${(infos.currentPosition.inSeconds / 60).toInt()} : ${(infos.currentPosition.inSeconds % 60).toInt()}',
                      //     style: TextStyle(color: Colors.white),
                      //   );
                      // })),
                      Container(
                        width: 340,
                        color: Colors.green,
                        child: audioPlayer.builderRealtimePlayingInfos(
                          builder: (context, infos) {
                            return PositionSeekWidget(
                              currentPosition: infos.currentPosition,
                              duration: infos.duration,
                              seekTo: (to) {
                                audioPlayer.seek(to);
                              },
                            );
                          },
                        ),
                      ),
                      // audioPlayer.builderRealtimePlayingInfos(
                      //     builder: ((context, infos) {
                      //   int minute = (infos.duration.inSeconds / 60).toInt();
                      //   int reminder = (infos.duration.inSeconds % 60);
                      //   return Text(
                      //     // infos.duration.inMinutes.toString(),
                      //     '${minute.toString()} : $reminder',
                      //     style: TextStyle(color: Colors.white),
                      //   );
                      // })),

                      // Container(color: Colors.pink,
                      //   child: Row(
                      //     children: [
                      //       audioPlayer.builderCurrentPosition(
                      //           builder: (context, duration) {
                      //         return Text(duration.toString());
                      //       })
                      //     ],
                      // ),
                      // )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            // if (isShuffle == false) {
                            //   isShuffle = true;

                            //   int randomIndex =
                            //       rnd.nextInt((audioList.length - 1) - 0);
                            //   globalIndex = randomIndex;
                            //   setState(() {});
                            //   selectedAudio = audioList[globalIndex];
                            //   playMusic();
                            //   setState(() {});
                            // } else {
                            //   isNavShow = false;
                            //   setState(() {});
                            // }
                          },
                          icon: Icon(Icons.shuffle,
                              size: 28,
                              color: isShuffle == false
                                  ? Colors.white
                                  : Colors.blueGrey)),
                      IconButton(
                          onPressed: () {
                            if (globalIndex > 0) {
                              globalIndex--;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                              audioPlayer.playlistPlayAtIndex(globalIndex);
                              setState(() {});
                            } else if (globalIndex == 0) {
                              globalIndex = audioList.length - 1;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                              // player.previous(keepLoopMode: false);
                              audioPlayer.playlistPlayAtIndex(globalIndex);
                              setState(() {});
                            }
                            audioPlayer.play();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 34,
                            color: Colors.white,
                          )),
                      GestureDetector(
                        onTap: () {
                          // audioPlayerState == PlayerState.PLAYING
                          //     ? pauseMusic()
                          //     : playMusic();
                          // setState(() {});
                          isPlaying ? pauseMusic() : playMusic();
                        },
                        child: Icon(
                          // audioPlayerState == PlayerState.PLAYING
                          isPlaying
                              ? Icons.pause_circle_filled_outlined
                              : Icons.play_circle_fill_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // audioPlayerState == PlayerState.PLAYING
                          //     ? pauseMusic()
                          //     : playMusic();
                          // setState(() {});
                          audioPlayer.stop();
                        },
                        child: Icon(
                          // audioPlayerState == PlayerState.PLAYING
                          Icons.stop_sharp,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (globalIndex == (audioList.length - 1)) {
                              globalIndex = 0;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                              audioPlayer.playlistPlayAtIndex(globalIndex);
                              setState(() {});
                            } else if (globalIndex < audioList.length - 1) {
                              globalIndex++;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                              audioPlayer.playlistPlayAtIndex(globalIndex);
                              setState(() {});
                            }
                            //skipNext();
                            // audioPlayer.next();
                            audioPlayer.play();
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            size: 34,
                            color: Colors.white,
                          )),
                      audioPlayer.builderLoopMode(builder: (context, loop) {
                        return PlayerBuilder.isPlaying(
                            player: audioPlayer,
                            builder: (context, isPlaying) {
                              return LoopControll(
                                loopMode: loop,
                                toggleLoop: () {
                                  // isLoop = true;
                                  // setState(() {});
                                  print(isLoop);
                                  audioPlayer.toggleLoop();
                                },
                              );
                            });
                      }),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const DownloadingDialog(),
                            );
                          },
                          icon: Icon(
                            Icons.download_outlined,
                            size: 28,
                            color: downloade == false
                                ? Colors.white
                                : Colors.blueGrey,
                          )),
                    ],
                  ),
                ],
              ),
            )),
          );
        });
      }),
    );
  }
}
