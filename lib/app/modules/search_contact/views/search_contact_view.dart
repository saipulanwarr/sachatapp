import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sachatapp/app/controllers/auth_controller.dart';
import 'package:sachatapp/app/routes/app_pages.dart';

import '../controllers/search_contact_controller.dart';

class SearchContactView extends GetView<SearchContactController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          backgroundColor: Colors.red[900],
          title: const Text('Search'),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 20, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                controller: controller.searchC,
                onChanged: (value) =>
                    controller.searchFriend(value, authC.user.value.email!),
                cursorColor: Colors.red[900],
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  hintText: "Search",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      color: Colors.red[900],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.tempSearch.length == 0
            ? Center(
                child: Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Lottie.asset("assets/lottie/empty.json"),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black26,
                    child: Image.asset(
                      "assets/logo/noimage.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "${controller.tempSearch[index]["name"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    "${controller.tempSearch[index]["email"]}",
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: GestureDetector(
                    onTap: () => authC.addNewConnection(
                        "${controller.tempSearch[index]["email"]}"),
                    child: Chip(
                      label: Text("Message"),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
