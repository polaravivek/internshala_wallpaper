import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/constants/api_string.dart';
import 'image_viewer_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabBarController;
  var urlData;

  Future<dynamic> _getData(String queryName) async {
    var url = Uri.parse(
        "https://api.unsplash.com/search/collections?per_page=30&query=$queryName&client_id=$api");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      urlData = jsonDecode(res.body);
      return urlData['results'];
    }
  }

  var userName;
  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  var bySearchName = "";
  final TextEditingController _searchController = TextEditingController();

  _buildImageCard(int index, dynamic urldata) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewer(
              url2: urldata[index]['cover_photo']['urls']['full'],
              url: urldata[index]['cover_photo']['urls']['regular'],
              title: _tabBarController.index,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Hero(
            tag: urldata[index]['cover_photo']['urls']['regular'],
            child: CachedNetworkImage(
              imageUrl: urldata[index]['cover_photo']['urls']['regular'],
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

  makeItNull() {
    setState(() {
      bySearchName = "";
    });
  }

  @override
  void initState() {
    _tabBarController = TabController(length: 4, vsync: this);
    _tabBarController.addListener(() {
      makeItNull();
    });
    getName();
    super.initState();
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style:
                            TextStyle(color: Color(0xff3B4071), fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text((userName != null) ? "$userName 👋" : "User 👋",
                          style: TextStyle(
                              color: Color(0xff3B4071),
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                      color: Color(0xff3B4071),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: _searchController,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    bySearchName = _searchController.value.text;
                  });
                  _searchController.clear();
                },
                decoration: InputDecoration(
                  hintText: "Search Wallpaper....",
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                  filled: true,
                  fillColor: Color(0xffF3F3F3),
                  contentPadding: EdgeInsets.all(20),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Color(0xff3B4071),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TabBar(
                physics: BouncingScrollPhysics(),
                indicatorWeight: 2,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff3B4071),
                ),
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 16),
                unselectedLabelStyle: TextStyle(fontSize: 14),
                isScrollable: true,
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                unselectedLabelColor: Colors.black26,
                tabs: [
                  Text(
                    'Nature',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Game',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Sunset',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Waterfall',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
                controller: _tabBarController,
              ),
              (bySearchName != "")
                  ? Expanded(
                      child: buildImagesWithStaggered(bySearchName),
                    )
                  : Expanded(
                      child:
                          TabBarView(controller: _tabBarController, children: [
                        buildImagesWithStaggered("nature"),
                        buildImagesWithStaggered("game"),
                        buildImagesWithStaggered("sunset"),
                        buildImagesWithStaggered("waterfall"),
                      ]),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> buildImagesWithStaggered(String name) {
    return FutureBuilder(
      future: _getData(name),
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
