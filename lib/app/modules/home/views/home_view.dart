import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sachatapp/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> myChats = List.generate(
    20,
    (index) => ListTile(
      onTap: () => Get.toNamed(Routes.CHAT_ROOM),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black26,
        child: Image.asset(
          "assets/logo/noimage.png",
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        "Title ${index + 1}",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        "Subtitle ${index + 1}",
        style: TextStyle(fontSize: 16),
      ),
      trailing: Chip(
        label: Text("3"),
      ),
    ),
  ).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red[900],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myChats.length,
              itemBuilder: (context, index) => myChats[index],
              padding: EdgeInsets.zero,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH_CONTACT),
        child: Icon(Icons.message_rounded),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}
