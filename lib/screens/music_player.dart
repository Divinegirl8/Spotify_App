// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart' as flut;
// import 'package:palette_generator/palette_generator.dart';
// import 'package:spotify/spotify.dart';
// import 'package:spotify_clone/constants/colors.dart';
// import 'package:spotify_clone/homepage.dart';
// import 'package:spotify_clone/models/music.dart';
// import 'package:spotify_clone/screens/lyrics_page.dart';
// import 'package:spotify_clone/view/customid.dart';
// import 'package:spotify_clone/view/widgets/art_work_image.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// class MusicPlayer extends flut.StatefulWidget {
//   const MusicPlayer({super.key});

//   @override
//   flut.State<MusicPlayer> createState() => _MusicPlayerState();
// }

// class _MusicPlayerState extends flut.State<MusicPlayer> {
//   final player = AudioPlayer();

//   static const trackIds = [
//     '5ZtK8XAVnoaGdBXZWCEVCY',
//       '2AaZJAh9FifPCQdba87Hzr',
//       '3aGroTtXwkWJ7wOwKEI8Px',
//       '1mk8ZC9OeTZMr8Wy31LqRj',
//       '5IgjP7X4th6nMNDh4akUHb',
//       '6O2hrfRRPBJ59PwKhSKFHz',
//       '5HM5trJxTouv3eUVcbW8sh',
//       '6cyXHTix4NQ069gKJEYv41',
//       '2JfRd9fkzyZge8BZzs7aUI',
    
//   ];





//   List<Music> musicList = [];
//   int currentTrackIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     initializeMusicList();
//     player.onPlayerComplete.listen((event) {
//       playNextTrack();
//     });
//   }

//   void initializeMusicList() {
//     for (var song in trackIds) {
//       Music music = Music(trackId: song);
//       musicList.add(music);
//     }
//     if (musicList.isNotEmpty) {
//       initializeMusic(musicList.first);
//     }
//   }

//   void initializeMusic(Music music) async {
//     final credentials = SpotifyApiCredentials(CustomId.clientId, CustomId.clientSecret);
//     final spotify = SpotifyApi(credentials);

//     final track = await spotify.tracks.get(musicList[currentTrackIndex].trackId);
//     String? tempSongName = track.name;
//     if (tempSongName != null) {
//       music.songName = tempSongName;
//       music.artistName = track.artists?.first.name ?? "";
//       String? image = track.album?.images?.first.url;
//       if (image != null) {
//         music.songImage = image;
//         final tempSongColor = await getImagePalette(flut.NetworkImage(image));
//         if (tempSongColor != null) {
//           music.songColor = tempSongColor;
//         }
//       }
//       music.artistImage = track.artists?.first.images?.first.url;
//       final yt = YoutubeExplode();
//       final video = (await yt.search.search("$tempSongName ${music.artistName ?? ""}")).first;
//       final videoId = video.id.value;
//       music.duration = video.duration;
//       setState(() {});
//       var manifest = await yt.videos.streamsClient.getManifest(videoId);
//       var audioUrl = manifest.audioOnly.last.url;
//       player.play(UrlSource(audioUrl.toString()));
//     }
//   }

//   void playNextTrack() {
//     if (currentTrackIndex < musicList.length - 1) {
//       currentTrackIndex++;
//       initializeMusic(musicList[currentTrackIndex]);
//     } else {
//       currentTrackIndex = 0;
//       initializeMusic(musicList[currentTrackIndex]);
//     }
//   }

//   void playPreviousTrack() {
//     if (currentTrackIndex > 0) {
//       currentTrackIndex--;
//       initializeMusic(musicList[currentTrackIndex]);
//     } else {
//       currentTrackIndex = musicList.length - 1;
//       initializeMusic(musicList[currentTrackIndex]);
//     }
//   }

//   Future<flut.Color?> getImagePalette(flut.ImageProvider imageProvider) async {
//     final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
//     return paletteGenerator.dominantColor?.color;
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   flut.Widget build(flut.BuildContext context) {
//     final textTheme = flut.Theme.of(context).textTheme;
//     return flut.Scaffold(
//       backgroundColor: flut.Colors.black,
//       body: flut.SafeArea(
//         child: flut.Padding(
//           padding: const flut.EdgeInsets.symmetric(horizontal: 26),
//           child: flut.Column(
//             children: [
//               const flut.SizedBox(height: 16),
//               flut.Row(
//                 mainAxisAlignment: flut.MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: flut.CrossAxisAlignment.start,
//                 children: [
//                   const flut.Icon(flut.Icons.close, color: flut.Colors.transparent),
//                   flut.Column(
//                     mainAxisSize: flut.MainAxisSize.min,
//                     children: [
//                       flut.Text(
//                         'Singing Now',
//                         style: textTheme.bodyMedium?.copyWith(color: CustomColors.primaryColor),
//                       ),
//                       const flut.SizedBox(height: 6),
//                       flut.Row(
//                         mainAxisSize: flut.MainAxisSize.min,
//                         children: [
//                           flut.CircleAvatar(
//                             backgroundColor: flut.Colors.white,
//                             backgroundImage: musicList.isNotEmpty && musicList[currentTrackIndex].artistImage != null
//                                 ? flut.NetworkImage(musicList[currentTrackIndex].artistImage!)
//                                 : null,
//                             radius: 10,
//                           ),
//                           const flut.SizedBox(width: 4),
//                           flut.Text(
//                             musicList.isNotEmpty ? musicList[currentTrackIndex].artistName ?? '-' : '-',
//                             style: textTheme.bodyLarge?.copyWith(color: flut.Colors.white),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   flut.IconButton(
//                     onPressed: () {
//                       flut.Navigator.push(context, flut.MaterialPageRoute(builder: (context) => Homepage()));
//                     },
//                     icon: const flut.Icon(flut.Icons.close, color: flut.Colors.white)),
//                 ],
//               ),
//               flut.Expanded(
//                 flex: 2,
//                 child: flut.Center(
//                   child: ArtWorkImage(image: musicList.isNotEmpty ? musicList[currentTrackIndex].songImage : ''),
//                 ),
//               ),
//               flut.Expanded(
//                 child: flut.Column(
//                   children: [
//                     flut.Row(
//                       mainAxisAlignment: flut.MainAxisAlignment.spaceBetween,
//                       children: [
//                         flut.Column(
//                           crossAxisAlignment: flut.CrossAxisAlignment.start,
//                           children: [
//                             flut.Text(
//                               musicList.isNotEmpty ? musicList[currentTrackIndex].songName ?? '' : '',
//                               style: textTheme.titleLarge?.copyWith(color: flut.Colors.white),
//                             ),
//                             flut.Text(
//                               musicList.isNotEmpty ? musicList[currentTrackIndex].artistName ?? '-' : '-',
//                               style: textTheme.titleMedium?.copyWith(color: flut.Colors.white60),
//                             ),
//                           ],
//                         ),
//                         const flut.Icon(
//                           flut.Icons.favorite,
//                           color: CustomColors.primaryColor,
//                         )
//                       ],
//                     ),
//                     const flut.SizedBox(height: 16),
//                     flut.StreamBuilder(
//                       stream: player.onPositionChanged,
//                       builder: (context, data) {
//                         return ProgressBar(
//                           progress: data.data ?? const Duration(seconds: 0),
//                           total: musicList.isNotEmpty ? musicList[currentTrackIndex].duration ?? const Duration(minutes: 4) : const Duration(minutes: 4),
//                           bufferedBarColor: flut.Colors.white38,
//                           baseBarColor: flut.Colors.white10,
//                           thumbColor: flut.Colors.white,
//                           timeLabelTextStyle: const flut.TextStyle(color: flut.Colors.white),
//                           progressBarColor: flut.Colors.white,
//                           onSeek: (duration) {
//                             player.seek(duration);
//                           },
//                         );
//                       }),
//                     const flut.SizedBox(height: 16),
//                     flut.Row(
//                       mainAxisAlignment: flut.MainAxisAlignment.spaceEvenly,
//                       children: [
//                         flut.IconButton(
//                           onPressed: () {
//                             flut.Navigator.push(
//                               context,
//                               flut.MaterialPageRoute(
//                                 builder: (context) => LyricsPage(
//                                   music: musicList.isNotEmpty ? musicList[currentTrackIndex] : Music(trackId: ''),
//                                   player: player,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const flut.Icon(flut.Icons.lyrics_outlined, color: flut.Colors.white)),
//                         flut.IconButton(
//                           onPressed: playPreviousTrack,
//                           icon: const flut.Icon(flut.Icons.skip_previous, color: flut.Colors.white, size: 36)),
//                         flut.IconButton(
//                           onPressed: () async {
//                             if (player.state == PlayerState.playing) {
//                               await player.pause();
//                             } else {
//                               await player.resume();
//                             }
//                             setState(() {});
//                           },
//                           icon: flut.Icon(
//                             player.state == PlayerState.playing ? flut.Icons.pause : flut.Icons.play_circle,
//                             color: flut.Colors.white,
//                             size: 60,
//                           )),
//                         flut.IconButton(
//                           onPressed: playNextTrack,
//                           icon: const flut.Icon(flut.Icons.skip_next, color: flut.Colors.white, size: 36)),
//                         flut.IconButton(
//                           onPressed: () {},
//                           icon: const flut.Icon(flut.Icons.loop, color: CustomColors.primaryColor)),
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart' as flut;
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/homepage.dart';
import 'package:spotify_clone/models/music.dart';
import 'package:spotify_clone/screens/lyrics_page.dart';
import 'package:spotify_clone/view/customid.dart';
import 'package:spotify_clone/view/widgets/art_work_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayer extends flut.StatefulWidget {
  final int initialTrackIndex;

  const MusicPlayer({super.key, required this.initialTrackIndex});

  @override
  flut.State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends flut.State<MusicPlayer> {
  final player = AudioPlayer();
  List<Music> musicList = [];
   static const trackIds = [
    '5ZtK8XAVnoaGdBXZWCEVCY',
      '2AaZJAh9FifPCQdba87Hzr',
      '3aGroTtXwkWJ7wOwKEI8Px',
      '1mk8ZC9OeTZMr8Wy31LqRj',
      '5IgjP7X4th6nMNDh4akUHb',
      '6O2hrfRRPBJ59PwKhSKFHz',
      '5HM5trJxTouv3eUVcbW8sh',
      '6cyXHTix4NQ069gKJEYv41',
      '2JfRd9fkzyZge8BZzs7aUI',
      '4jyZRIiSAEkziHwhZsfmXc',
      '7ux3omD4Rp8TXkxcUJ2vhw'
    
  ];

  late int currentTrackIndex;

  @override
  void initState() {
    super.initState();
    currentTrackIndex = widget.initialTrackIndex;
    initializeMusicList();
    player.onPlayerComplete.listen((event) {
      playNextTrack();
    });
  }

  void initializeMusicList() {
    for (var song in trackIds) {
      Music music = Music(trackId: song);
      musicList.add(music);
    }
    if (musicList.isNotEmpty) {
      initializeMusic(musicList[currentTrackIndex]);
    }
  }

  void initializeMusic(Music music) async {
    final credentials = SpotifyApiCredentials(CustomId.clientId, CustomId.clientSecret);
    final spotify = SpotifyApi(credentials);

    final track = await spotify.tracks.get(musicList[currentTrackIndex].trackId);
    String? tempSongName = track.name;
    if (tempSongName != null) {
      music.songName = tempSongName;
      music.artistName = track.artists?.first.name ?? "";
      String? image = track.album?.images?.first.url;
      if (image != null) {
        music.songImage = image;
        final tempSongColor = await getImagePalette(flut.NetworkImage(image));
        if (tempSongColor != null) {
          music.songColor = tempSongColor;
        }
      }
      music.artistImage = track.artists?.first.images?.first.url;
      final yt = YoutubeExplode();
      final video = (await yt.search.search("$tempSongName ${music.artistName ?? ""}")).first;
      final videoId = video.id.value;
      music.duration = video.duration;
      setState(() {});
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.last.url;
      player.play(UrlSource(audioUrl.toString()));
    }
  }

  void playNextTrack() {
    if (currentTrackIndex < musicList.length - 1) {
      currentTrackIndex++;
      initializeMusic(musicList[currentTrackIndex]);
    } else {
      currentTrackIndex = 0;
      initializeMusic(musicList[currentTrackIndex]);
    }
  }

  void playPreviousTrack() {
    if (currentTrackIndex > 0) {
      currentTrackIndex--;
      initializeMusic(musicList[currentTrackIndex]);
    } else {
      currentTrackIndex = musicList.length - 1;
      initializeMusic(musicList[currentTrackIndex]);
    }
  }

  Future<flut.Color?> getImagePalette(flut.ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  flut.Widget build(flut.BuildContext context) {
    final textTheme = flut.Theme.of(context).textTheme;
    return flut.Scaffold(
      backgroundColor: flut.Colors.black,
      body: flut.SafeArea(
        child: flut.Padding(
          padding: const flut.EdgeInsets.symmetric(horizontal: 26),
          child: flut.Column(
            children: [
              const flut.SizedBox(height: 16),
              flut.Row(
                mainAxisAlignment: flut.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: flut.CrossAxisAlignment.start,
                children: [
                  const flut.Icon(flut.Icons.close, color: flut.Colors.transparent),
                  flut.Column(
                    mainAxisSize: flut.MainAxisSize.min,
                    children: [
                      flut.Text(
                        'Singing Now',
                        style: textTheme.bodyMedium?.copyWith(color: CustomColors.primaryColor),
                      ),
                      const flut.SizedBox(height: 6),
                      flut.Row(
                        mainAxisSize: flut.MainAxisSize.min,
                        children: [
                          flut.CircleAvatar(
                            backgroundColor: flut.Colors.white,
                            backgroundImage: musicList.isNotEmpty && musicList[currentTrackIndex].artistImage != null
                                ? flut.NetworkImage(musicList[currentTrackIndex].artistImage!)
                                : null,
                            radius: 10,
                          ),
                          const flut.SizedBox(width: 4),
                          flut.Text(
                            musicList.isNotEmpty ? musicList[currentTrackIndex].artistName ?? '-' : '-',
                            style: textTheme.bodyLarge?.copyWith(color: flut.Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                  flut.IconButton(
                    onPressed: () {
                      flut.Navigator.push(context, flut.MaterialPageRoute(builder: (context) => Homepage()));
                    },
                    icon: const flut.Icon(flut.Icons.close, color: flut.Colors.white)),
                ],
              ),
              flut.Expanded(
                flex: 2,
                child: flut.Center(
                  child: ArtWorkImage(image: musicList.isNotEmpty ? musicList[currentTrackIndex].songImage : ''),
                ),
              ),
              flut.Expanded(
                child: flut.Column(
                  children: [
                    flut.Row(
                      mainAxisAlignment: flut.MainAxisAlignment.spaceBetween,
                      children: [
                        flut.Column(
                          crossAxisAlignment: flut.CrossAxisAlignment.start,
                          children: [
                            flut.Text(
                              musicList.isNotEmpty ? musicList[currentTrackIndex].songName ?? '' : '',
                              style: textTheme.titleLarge?.copyWith(color: flut.Colors.white),
                            ),
                            flut.Text(
                              musicList.isNotEmpty ? musicList[currentTrackIndex].artistName ?? '-' : '-',
                              style: textTheme.titleMedium?.copyWith(color: flut.Colors.white60),
                            ),
                          ],
                        ),
                        const flut.Icon(
                          flut.Icons.favorite,
                          color: CustomColors.primaryColor,
                        )
                      ],
                    ),
                    const flut.SizedBox(height: 16),
                    flut.StreamBuilder(
                      stream: player.onPositionChanged,
                      builder: (context, data) {
                        return ProgressBar(
                          progress: data.data ?? const Duration(seconds: 0),
                          total: musicList.isNotEmpty ? musicList[currentTrackIndex].duration ?? const Duration(minutes: 4) : const Duration(minutes: 4),
                          bufferedBarColor: flut.Colors.white38,
                          baseBarColor: flut.Colors.white10,
                          thumbColor: flut.Colors.white,
                          timeLabelTextStyle: const flut.TextStyle(color: flut.Colors.white),
                          progressBarColor: flut.Colors.white,
                          onSeek: (duration) {
                            player.seek(duration);
                          },
                        );
                      }),
                    const flut.SizedBox(height: 16),
                    flut.Row(
                      mainAxisAlignment: flut.MainAxisAlignment.spaceEvenly,
                      children: [
                        flut.IconButton(
                          onPressed: () {
                            flut.Navigator.push(
                              context,
                              flut.MaterialPageRoute(
                                builder: (context) => LyricsPage(
                                  music: musicList.isNotEmpty ? musicList[currentTrackIndex] : Music(trackId: ''),
                                  player: player,
                                ),
                              ),
                            );
                          },
                          icon: const flut.Icon(flut.Icons.lyrics_outlined, color: flut.Colors.white)),
                        flut.IconButton(
                          onPressed: playPreviousTrack,
                          icon: const flut.Icon(flut.Icons.skip_previous, color: flut.Colors.white, size: 36)),
                        flut.IconButton(
                          onPressed: () async {
                            if (player.state == PlayerState.playing) {
                              await player.pause();
                            } else {
                              await player.resume();
                            }
                            setState(() {});
                          },
                          icon: flut.Icon(
                            player.state == PlayerState.playing ? flut.Icons.pause : flut.Icons.play_circle,
                            color: flut.Colors.white,
                            size: 60,
                          )),
                        flut.IconButton(
                          onPressed: playNextTrack,
                          icon: const flut.Icon(flut.Icons.skip_next, color: flut.Colors.white, size: 36)),
                        flut.IconButton(
                          onPressed: () {},
                          icon: const flut.Icon(flut.Icons.loop, color: CustomColors.primaryColor)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
