
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
  const MusicPlayer({super.key});

  @override
  flut.State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends flut.State<MusicPlayer> {
  final player = AudioPlayer();
  Music music = Music(trackId: '5ZtK8XAVnoaGdBXZWCEVCY');


  

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final credentials = SpotifyApiCredentials(
        CustomId.clientId, CustomId.clientSecret);
    final spotify = SpotifyApi(credentials);
    spotify.tracks.get(music.trackId).then((track) async {
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
        final video = (await yt.search.search("$tempSongName ${music.artistName??""}")).first;
        final videoId = video.id.value;
        music.duration = video.duration;
        setState(() {});
        var manifest = await yt.videos.streamsClient.getManifest(videoId);
        var audioUrl = manifest.audioOnly.last.url;
        player.play(UrlSource(audioUrl.toString()));
      }
    });
    super.initState();
  }

  Future<flut.Color?> getImagePalette(flut.ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
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
                        style: textTheme.bodyMedium
                            ?.copyWith(color: CustomColors.primaryColor),
                      ),
                      const flut.SizedBox(height: 6),
                      flut.Row(
                        mainAxisSize: flut.MainAxisSize.min,
                        children: [
                          flut.CircleAvatar(
                            backgroundColor: flut.Colors.white,
                            backgroundImage: music.artistImage != null
                                ? flut.NetworkImage(music.artistImage!)
                                : null,
                            radius: 10,
                          ),
                          const flut.SizedBox(width: 4),
                          flut.Text(
                            music.artistName ?? '-',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: flut.Colors.white),
                          )
                        ],
                      )
                    ],
                  ),





                flut.IconButton(
                          onPressed: () {
                            flut.Navigator.push(
                                context,
                                flut.MaterialPageRoute(
                                    builder: (context) =>
                                        Homepage()));
                          },
                          icon: const flut.Icon(flut.Icons.close,
                              color: flut.Colors.white)),
                    


                  // const flut.Icon(
                  //   flut.Icons.close,
                  //   color: flut.Colors.white,
                    
                  // ),
                ],
              ),
              flut.Expanded(
                  flex: 2,
                  child: flut.Center(
                    child: ArtWorkImage(image: music.songImage),
                  )),
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
                            music.songName ?? '',
                            style: textTheme.titleLarge
                                ?.copyWith(color: flut.Colors.white),
                          ),
                          flut.Text(
                            music.artistName ?? '-',
                            style: textTheme.titleMedium
                                ?.copyWith(color: flut.Colors.white60),
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
                          total: music.duration ?? const Duration(minutes: 4),
                          bufferedBarColor: flut.Colors.white38,
                          baseBarColor: flut.Colors.white10,
                          thumbColor: flut.Colors.white,
                          timeLabelTextStyle:
                              const flut.TextStyle(color: flut.Colors.white),
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
                                    builder: (context) =>
                                        LyricsPage(music: music, player: player,)));
                          },
                          icon: const flut.Icon(flut.Icons.lyrics_outlined,
                              color: flut.Colors.white)),
                      flut.IconButton(
                          onPressed: () {},
                          icon: const flut.Icon(flut.Icons.skip_previous,
                              color: flut.Colors.white, size: 36)),
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
                            player.state == PlayerState.playing
                                ? flut.Icons.pause
                                : flut.Icons.play_circle,
                            color: flut.Colors.white,
                            size: 60,
                          )),
                      flut.IconButton(
                          onPressed: () {},
                          icon: const flut.Icon(flut.Icons.skip_next,
                              color: flut.Colors.white, size: 36)),
                      flut.IconButton(
                          onPressed: () {},
                          icon: const flut.Icon(flut.Icons.loop,
                              color: CustomColors.primaryColor)),
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}















// class MusicPlayer extends flut.StatefulWidget{
//   const MusicPlayer({super.key});

//   @override
//   flut.State<MusicPlayer> createState() => _MusicPlayerState();
// }


// class _MusicPlayerState  extends flut.State<MusicPlayer>{
//    Music music = Music(trackId: '5ZtK8XAVnoaGdBXZWCEVCY');
//     // String musicTrackId = "5ZtK8XAVnoaGdBXZWCEVCY?si=e78302eecd5844c9";
//    final player = AudioPlayer();
//     Duration ? duration;

//  @override
//   void initState() {
//     final credentials = SpotifyApiCredentials(
//         CustomId.clientId, CustomId.clientSecret);
//     final spotify = SpotifyApi(credentials);
//     spotify.tracks.get(music.trackId).then((track) async {
//       String? tempSongName = track.name;
//       if (tempSongName != null) {
//         music.songName = tempSongName;
//         music.artistName = track.artists?.first.name ?? "";
//         String? image = track.album?.images?.first.url;
//         if (image != null) {
//           music.songImage = image;
//           final tempSongColor = await getImagePalette(flut.NetworkImage(image));
//           if (tempSongColor != null) {
//             music.songColor = tempSongColor;
//           }
//         }
//         music.artistImage = track.artists?.first.images?.first.url;
//         final yt = YoutubeExplode();
//         final video = (await yt.search.search("$tempSongName ${music.artistName??""}")).first;
//         final videoId = video.id.value;
//         music.duration = video.duration;
//         setState(() {});
//         var manifest = await yt.videos.streamsClient.getManifest(videoId);
//         var audioUrl = manifest.audioOnly.last.url;
//         player.play(UrlSource(audioUrl.toString()));
//       }
//     });
//     super.initState();
//   }


//   Future<flut.Color?> getImagePalette(flut.ImageProvider imageProvider) async {
//     final PaletteGenerator paletteGenerator =
//         await PaletteGenerator.fromImageProvider(imageProvider);
//     return paletteGenerator.dominantColor?.color;
//   }

//   @override
// flut.Widget build(flut.BuildContext context){
//   // final textTheme = Theme.of(context).textTheme;
//   const String artistName = "Music 1";
//   const String songName = "Lonely At The Top";
  


  
//   return flut.Scaffold(
//     body:  flut.SafeArea(
//       child : flut.Padding(
//         padding: const flut.EdgeInsets.symmetric(horizontal: 26),
//       child: flut.Column(
//       children: [
//        const flut.SizedBox(height: 14,),
//         flut.Row(
//           mainAxisAlignment: flut.MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: flut.CrossAxisAlignment.start,
//          children: [
//          const flut.Icon(flut.Icons.close,color: flut.Colors.transparent,),
//           flut.Column(
//             mainAxisSize: flut.MainAxisSize.min,
//             children: [

//              const flut.Text(
//                 'Singing Now',
//                 style: flut.TextStyle(
//                   color: CustomColors.primaryColor,
//                   fontSize: 12,
//                 ),

//               ),
//                const flut.SizedBox(height: 8,),
//               flut.Row(
//                 mainAxisSize: flut.MainAxisSize.min,
                
//                 children: [
//                      flut.ClipOval(
//                       child: flut.Image.asset(
//                         'images/img1.jpg',
//                         width: 20,
//                         height: 20,
//                         fit: flut.BoxFit.cover, 
//                       ),
//                     ),
                                  
//                   // CircleAvatar(
//                   //   backgroundColor: Colors.white,
               
//                   //   radius: 10,
//                   // ),
//                    const flut.SizedBox(width: 4,),
//                  const flut.Text(
//                     artistName,
//                     style: flut.TextStyle(
//                       color: flut.Colors.white,
//                       fontWeight: flut.FontWeight.bold,
//                       fontSize: 20
//                     ),
//                   )
//                 ],
//               ),


//             ],
//           ),
//          const flut.Icon(flut.Icons.close,color: flut.Colors.white,),
//          ],
//       ),
      
//           const flut.Expanded(
//             flex: 2,
//             child: flut.Center(
//             child: ArtWorkImage(image : "images/img1.jpg"),
//           )),
      
//      const  flut.Expanded(
//       child: flut.Column(
//         children: [
          
//         flut.Row(
//           mainAxisAlignment: flut.MainAxisAlignment.spaceBetween,
//           children: [
//             flut.Column(
//               crossAxisAlignment: flut.CrossAxisAlignment.start,
//               children: [
//                 flut.Text(artistName,
//                 style: flut.TextStyle(
//                   color: flut.Colors.white,
//                   fontSize: 25,
//                   fontWeight: flut.FontWeight.bold
//                 ),
//                 )
              
//                 ,
//                 flut.Text(songName,
//                 style: flut.TextStyle(
//                   color: flut.Colors.grey,
//                 ),
//                 ),
//               ],
//             ),
//           flut.Icon(flut.Icons.favorite, color: CustomColors.primaryColor,)
//           ],
//         ),
//                 flut.SizedBox(height: 16,),

//              flut.StreamBuilder(
              
//                       stream: player.onPositionChanged,
//                       builder: (context, data) {
//                         return ProgressBar(
//                           progress: data.data ?? const Duration(seconds: 0),
//                           total: music.duration ?? const Duration(minutes: 4),
//                           bufferedBarColor: flut.Colors.white38,
//                           baseBarColor: flut.Colors.white10,
//                           thumbColor: flut.Colors.white,
//                           timeLabelTextStyle:
//                               const flut.TextStyle(color: flut.Colors.white),
//                           progressBarColor: flut.Colors.white,
//                           onSeek: (duration) {
//                             player.seek(duration);
//                           },
//                         );
//                       }),



//             // ProgressBar(
              
//             //   progress: Duration(seconds: 0),
              
//             //   // buffered: Duration(milliseconds: 2000),
//             //   total:  Duration(minutes: 3,seconds: 30),
//             //   bufferedBarColor: flut.Colors.white38,
//             //   progressBarColor: flut.Colors.white,
//             //   thumbColor: flut.Colors.white,
//             //   baseBarColor: flut.Colors.white10,
//             //   timeLabelTextStyle: flut.TextStyle(
//             //     color: flut.Colors.white,
//             //   ),
//             //   // onSeek: (duration) {
//             //   //       print('User selected a new time: $duration');
//             //   //          },
//             //       ),

//       flut.SizedBox(height: 16,),

//       flut.Row(
//         mainAxisAlignment: flut.MainAxisAlignment.spaceEvenly,
//         children: [
//           flut.IconButton(
//             onPressed: value, 
//             icon: flut.Icon(flut.Icons.lyrics_outlined,
//                     color: flut.Colors.white,
//              )),



//              flut.IconButton(
//             onPressed: value, 
//             icon: flut.Icon(flut.Icons.skip_previous,
//                     color: flut.Colors.white,
//                     size: 36,
//              )),


//             flut.IconButton(
//                           onPressed: () async {
//                             if (player.state == PlayerState.playing) {
//                               await player.pause(); 
//                             } else {
//                               await player.resume();
//                             }
//                             setState(() {});
//                           },
//                           icon: flut.Icon(
//                             player.state == PlayerState.playing
//                                 ? flut.Icons.pause
//                                 : flut.Icons.play_circle,
//                             color: flut.Colors.white,
//                             size: 60,
//                           )),
//              flut.IconButton(
//             onPressed: value, 
//             icon: flut.Icon(flut.Icons.skip_next,
//                     color: flut.Colors.white,
//                     size: 36,
//              )),


//              flut.IconButton(
//             onPressed: value, 
//             icon: flut.Icon(flut.Icons.loop,
//                     color: CustomColors.primaryColor,
//              )),
//         ],
//       )

//       ],))


//       ],
//       ),),),
//       backgroundColor: flut.Colors.black,
//   );
// }
// }





// value () {

// }

