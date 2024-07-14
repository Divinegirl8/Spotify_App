import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/screens/music_player.dart';

import 'models/category_model.dart';
import 'models/hits_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<CategoryModel> categories = [];
  List<HitsModel> hits = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Fetch categories synchronously
    categories = CategoryModel.getCategory();

    // Fetch hits asynchronously
    hits = await HitsModel.getHitModel();

    // Update the UI after fetching data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          search(),
          const SizedBox(height: 40),
          charts(categories),
          const SizedBox(height: 40),
          hitz(hits),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget hitz(List<HitsModel> hits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Today\'s biggest hits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView.separated(
            itemCount: hits.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MusicPlayer(),
                      ),
                    );
                  },
                child: SizedBox(
                  width: 150, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                hits[index].urlPath,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                            ),

                      Text(
                        hits[index].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    
                      Text(
                      hits[index].musicTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget charts(List<CategoryModel> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Featured Charts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 150, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset(categories[index].iconPath), 
                    ),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      categories[index].description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Spotify',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          // child: SvgPicture.asset(
          //   'images/Arrow - Left 2.svg',
          //   height: 20,
          //   width: 20,
          // ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 37,
            // child: SvgPicture.asset(
            //   'images/dots.svg',
            //   height: 5,
            //   width: 5,
            // ),
          ),
        )
      ],
    );
  }

  Container search() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset('images/Search.svg'),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
