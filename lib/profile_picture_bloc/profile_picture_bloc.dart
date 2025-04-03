import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_picture_event.dart';
part 'profile_picture_state.dart';

class ProfilePictureBloc
    extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  ProfilePictureBloc() : super(ProfilePictureInitial()) {
    on<UploadProfilePicture>((event, emit) async {
      String imageUrl = await uploadProfilePicture();

      if (imageUrl.isNotEmpty) {
        if (kDebugMode) {
          print("Profile picture uploaded and Firestore updated: $imageUrl");
        }

      } else {
        emit(ProfilePictureError(error: "Image upload failed."));
      }

    });
    on<ProfilePictureFetch>((event, emit) async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          DocumentSnapshot doc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (doc.exists) {
            var data = doc.data() as Map<String, dynamic>?;

            if (data != null && data.containsKey('profilePic')) {
              String profilePicUrl = data['profilePic'];

              emit(ProfilePictureLoaded(imageURl: profilePicUrl));
            } else {
              emit(
                ProfilePictureError(
                  error: "no profile picture try adding profile picture",
                ),
              );
            }
          } else {
            emit(ProfilePictureError(error: "Document doesn't exist"));
          }
        } catch (e) {
          emit(ProfilePictureError(error: e as String));
        }
      }
      return; // Return null if user is not logged in
    });
  }

  Future<File?> pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        if (kDebugMode) print("No image selected.");
        return null;
      }

      File imageFile = File(pickedFile.path);
      if (kDebugMode) print("Image picked: ${imageFile.path}");
      return imageFile;
    } catch (e) {
      if (kDebugMode) print("Error picking image: $e");
      return null;
    }
  }

  Future<String> uploadProfilePicture() async {
    try {
      File? imageFile = await pickImage();

      if (imageFile == null) {
        if (kDebugMode) print("No image selected.");
        return "";
      }

      if (!await imageFile.exists()) {
        if (kDebugMode) print("File does not exist.");
        return "";
      }

      String fileName =
          "profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref = FirebaseStorage.instance.ref().child(fileName);

      if (kDebugMode) print("Uploading image to Firebase Storage...");

      UploadTask uploadTask = ref.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          print(
            "Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}",
          );
        }
      });

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      if (kDebugMode) print("Image uploaded successfully: $downloadUrl");

      await updateProfilePicture(downloadUrl);
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) print("Error uploading image: $e");
      return "";
    }
  }

  Future<void> updateProfilePicture(String imageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "profilePic": imageUrl,
      }, SetOptions(merge: true));
    }
  }
}
