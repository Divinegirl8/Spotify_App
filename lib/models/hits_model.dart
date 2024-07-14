import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotify_clone/view/customid.dart';

class HitsModel {
  String urlPath;
  String name;
  String musicTitle;
  
  // MusicPlayer? musicPlayer;

  HitsModel({
    required this.urlPath,
    required this.name,
    // required this.musicPlayer,
    required this.musicTitle,
  });

  static Future<String> getAccessToken(String clientId, String clientSecret) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  static Future<Map<String, String>> getArtistDetails(String trackId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final artist = json['artists'][0];
      final artistName = artist['name'];
       final songName = json['name']; 
      final artistImage = (await getArtistImage(artist['id'], accessToken)) ?? '';
      return {
        'name': artistName,
        'image': artistImage,
        'musicname': songName,
        
      };
    } else {
      throw Exception('Failed to get track details');
    }
  }

  static Future<String?> getArtistImage(String artistId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['images'].isNotEmpty ? json['images'][0]['url'] : null;
    } else {
      throw Exception('Failed to get artist details');
    }
  }

  static Future<List<HitsModel>> getHitModel() async {
    const clientId = CustomId.clientId;
    const clientSecret = CustomId.clientSecret;
    const trackIds = [
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

    final accessToken = await getAccessToken(clientId, clientSecret);

    List<HitsModel> models = [];

    for (var trackId in trackIds) {
      final artistDetails = await getArtistDetails(trackId, accessToken);
      final artistName = artistDetails['name']!;
      final artistImage = artistDetails['image']!;
      final songName = artistDetails['musicname']!;
      models.add(
        HitsModel(
          urlPath: artistImage,
          name: artistName,
          musicTitle: songName
        ),
      );
    }

    return models;
  }
}
