import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sachatapp/app/data/models/user_model.dart';
import 'package:sachatapp/app/routes/app_pages.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  var user = UserModel().obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then(
      (value) {
        if (value) {
          isAuth.value = true;
        }
      },
    );

    await skipIntro().then(
      (value) {
        if (value) {
          isSkipIntro.value = true;
        }
      },
    );
  }

  Future<bool> skipIntro() async {
    final box = GetStorage();
    if (box.read("skipIntro") != null || box.read("skipIntro") == true) {
      return true;
    }

    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        final box = GetStorage();

        if (box.read("skipIntro") != null) {
          box.remove("skipIntro");
        }

        box.write("skipIntro", true);
        isSkipIntro.value = true;

        CollectionReference users = firestore.collection("users");

        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(currUserData));

        return true;
      }

      return false;
    } catch (err) {
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        print(_currentUser);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        final box = GetStorage();

        if (box.read("skipIntro") != null) {
          box.remove("skipIntro");
        }

        box.write("skipIntro", true);

        CollectionReference users = firestore.collection("users");

        final checkUser = await users.doc(_currentUser!.email).get();

        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
            "chats": [],
          });
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(currUserData));

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("Login gagal");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void changeProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection("users");

    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(title: "Success", middleText: "Change Profile success");
  }

  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection("users");

    users.doc(_currentUser!.email).update({
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    user.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(title: "Success", middleText: "Update status success");
  }

  void addNewConnection(friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    final date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docUser = await users.doc(_currentUser!.email).get();
    final docChats = (docUser.data() as Map<String, dynamic>)["chats"] as List;

    if (docChats.length != 0) {
      docChats.forEach((singleChat) {
        if (singleChat["connection"] == friendEmail) {
          chat_id = singleChat["chat_id"];
        }
      });

      if (chat_id != null) {
        flagNewConnection = false;
      } else {
        flagNewConnection = true;
      }
    } else {
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      final newChatDoc = await chats.add({
        "connections": [_currentUser!.email, friendEmail],
        "total_chats": 0,
        "total_read": 0,
        "total_unread": 0,
        "chat": [],
        "lastTime": date,
      });

      await users.doc(_currentUser!.email).update({
        "chats": [
          {
            "connection": friendEmail,
            "chat_id": newChatDoc.id,
            "lastTime": date,
          }
        ]
      });

      user.update((user) {
        user!.chats = [
          ChatUser(
            chatId: newChatDoc.id,
            connection: friendEmail,
            lastTime: date,
          )
        ];
      });

      chat_id = newChatDoc.id;
      user.refresh();
    }

    Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
  }
}
