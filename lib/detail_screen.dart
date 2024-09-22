import 'package:art_gallery/list_screen.dart';
import 'package:art_gallery/model/art_data.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailScreen extends StatefulWidget {
  final ArtData art;
  final int artIndex;

  const DetailScreen({super.key, required this.art, required this.artIndex});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String artName;
  late String artArtist;
  late String artYear;
  late String artDesc;
  late int favIndex;
  List<Widget> carouselItems = [
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/birth_venus.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/starry_night.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/the_last_supper.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/monalisa.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:
            Image.asset('images/the_creation_of_adam.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/the_scream.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/pearl_earring.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/persistence_memory.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/guernica.jpg', fit: BoxFit.cover)),
    ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/the_kiss.jpg', fit: BoxFit.cover)),
  ];

  @override
  void initState() {
    super.initState();
    artName = widget.art.name;
    artArtist = widget.art.artist;
    artYear = widget.art.year;
    artDesc = widget.art.description;
    favIndex = widget.artIndex;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightItem = size.width <= 600 ? 0.2 : 0.4;
    double fracItem = size.width <= 600 ? 0.5 : 0.2;

    return Scaffold(
      appBar: AppBar(
        actions: [
          FavoriteButton(
              color: const Color.fromARGB(255, 45, 45, 45), indexFav: favIndex)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                items: carouselItems,
                options: CarouselOptions(
                  initialPage: widget.artIndex,
                  height: size.height * heightItem,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  viewportFraction: fracItem,
                  onPageChanged: (index, reason) {
                    if (index < 5) {
                      setState(() {
                        artName = artDataList[index].name;
                        artArtist = artDataList[index].artist;
                        artYear = artDataList[index].year;
                        artDesc = artDataList[index].description;
                      });
                    } else {
                      setState(() {
                        artName = artDataList2[index - 5].name;
                        artArtist = artDataList2[index - 5].artist;
                        artYear = artDataList2[index - 5].year;
                        artDesc = artDataList2[index - 5].description;
                      });
                    }
                    setState(() {
                      favIndex = index;
                    });
                  },
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: size.height - (size.height * 0.2)),
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 45, 45, 45),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        artName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            Text(
                              artArtist,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 175, 175, 175),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              artYear,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 175, 175, 175),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        artDesc,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
