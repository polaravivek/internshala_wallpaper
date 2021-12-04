import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/screens/image_viewer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikedImages extends StatefulWidget {
  const LikedImages({Key? key}) : super(key: key);

  @override
  _LikedImagesState createState() => _LikedImagesState();
}

class _LikedImagesState extends State<LikedImages> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uid;
  late List<dynamic> data;
  late List<dynamic> reversedData;

  Future<dynamic> getLikedInfo() async {
    var docref = _firestore.collection('users').doc('$uid');

    var doc = await docref.get();

    setState(() {
      data = doc.get('likedUrls');
    });

    var reversedData = List.from(data.reversed);

    return reversedData;
  }

  @override
  void initState() {
    uid = auth.currentUser!.uid;
    getLikedInfo();
    super.initState();
  }

  _buildImageCard(int index, dynamic urldata) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageViewer(
                      title: "Liked Images",
                      url: urldata[index],
                    )));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Hero(
            tag: urldata[index],
            child: CachedNetworkImage(
              imageUrl: urldata[index],
              placeholder: (context, __) {
                return Center(child: CircularProgressIndicator());
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 24,
                    color: Colors.black,
                  ),
                  Text(
                    "Liked Wallpapers",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              (data.isEmpty)
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Nothing to Show...',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Expanded(
                      child: buildImagesWithStaggered(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> buildImagesWithStaggered() {
    return FutureBuilder(
      future: getLikedInfo(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
                height: 30, width: 30, child: CircularProgressIndicator()),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(top: 20),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildImageCard(index, snapshot.data);
              },
              staggeredTileBuilder: (index) =>
                  StaggeredTile.count(1, index.isEven ? 2 : 1),
            ),
          );
        }
      },
    );
  }
}
