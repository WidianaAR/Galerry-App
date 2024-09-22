import 'package:art_gallery/detail_screen.dart';
import 'package:art_gallery/model/art_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoriteButton extends StatefulWidget {
  final Color color;
  final int indexFav;
  const FavoriteButton({Key? key, required this.color, required this.indexFav})
      : super(key: key);

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  final storage = const FlutterSecureStorage();

  Future<bool> getFavoriteStatus() async {
    String? isFavoriteStorage = await storage.read(key: '${widget.indexFav}');
    return isFavoriteStorage == '1';
  }

  Future<void> saveFavoriteStatus(bool isFavorite) async {
    await storage.write(
        key: '${widget.indexFav}', value: isFavorite ? '1' : '0');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getFavoriteStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else {
          bool isFavorite = snapshot.data ?? false;
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.color,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                saveFavoriteStatus(isFavorite);
              });
            },
          );
        }
      },
    );
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 45, 45, 45),
        title: const Text(
          'Art Gallery App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 600) {
          return const MobileList();
        } else {
          return const WebList();
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ListScreen()),
          );
        },
        tooltip: 'Refresh',
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }
}

class WebList extends StatelessWidget {
  const WebList({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 10),
        child: Row(children: [
          Expanded(
              child: ArtItem(
            dataList: artDataList,
            type: 1,
          )),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Expanded(
              child: ArtItem(
            dataList: artDataList2,
            type: 2,
          )),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Expanded(
              child: ArtItem(
            dataList: artDataList,
            type: 1,
          )),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Expanded(
              child: ArtItem(
            dataList: artDataList2,
            type: 2,
          )),
        ]),
      ),
    );
  }
}

class MobileList extends StatelessWidget {
  const MobileList({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
        child: Row(
          children: [
            Expanded(child: ArtItem(dataList: artDataList, type: 1)),
            SizedBox(
              width: screenWidth * 0.04,
            ),
            Expanded(child: ArtItem(dataList: artDataList2, type: 2)),
          ],
        ),
      ),
    );
  }
}

class ArtItem extends StatelessWidget {
  final List<ArtData> dataList;
  final int type;
  const ArtItem({super.key, required this.dataList, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dataList.asMap().entries.map(
        (art) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailScreen(
                        art: art.value,
                        artIndex: type == 2 ? art.key + 5 : art.key,
                      );
                    }));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      art.value.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FavoriteButton(
                      color: Colors.white,
                      indexFav: type == 2 ? art.key + 5 : art.key),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
