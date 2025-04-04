import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_authendication/pages/Update_employee.dart';
import 'package:email_authendication/pages/add_employee.dart';
import 'package:email_authendication/pages/login_page.dart';
import 'package:email_authendication/profile_picture_bloc/profile_picture_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    fetchUsername();
    context.read<ProfilePictureBloc>().add((ProfilePictureFetch()));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              BlocConsumer<ProfilePictureBloc, ProfilePictureState>(
                listener: (context, state) {
                  if (state is ProfilePictureError) {
                    context.read<ProfilePictureBloc>().add(
                      ProfilePictureFetch(),
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is ProfilePictureLoading) {
                    if (kDebugMode) {
                      print('Builder: ProfilePictureLoading');
                    }

                    return Center(
                      child: CircleAvatar(
                        radius: 65.r,
                        backgroundColor: Colors.grey,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (state is ProfilePictureLoaded) {
                    if (kDebugMode) {
                      print('Builder: ProfilePictureLoaded');
                    }
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 65.r,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Image.network(
                              state.imageURl,
                              height: 128.h,
                              width: 128.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -8.h,
                          child: IconButton(
                            onPressed: () async {
                              context.read<ProfilePictureBloc>().add(
                                UploadProfilePicture(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("it might take few min please wait......")),
                              );
                            },
                            icon: Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 65.r,
                          backgroundColor: Colors.grey,
                          child: SvgPicture.asset(
                            "assets/images/profile-default.svg",
                            height: 130.h,
                            width: 130.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: -8.h,
                          child: IconButton(
                            onPressed: () {
                              context.read<ProfilePictureBloc>().add(
                                UploadProfilePicture(),
                              );
                            },
                            icon: Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              Text(
                userName != null ? 'Welcome, $userName!' : 'Loading...',
                style: TextStyle(fontSize: 20.r, fontFamily: "SourceSansPro"),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "SourceSansPro",
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEmployee()),
                  );
                },
                child: Text(
                  "Add employee",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "SourceCodePro",
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'List of employees',
                style: TextStyle(
                  fontFamily: "SourceSansPro",
                  fontSize: 12.r,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 18.h),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .collection('employees')
                          .snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No employees found.'));
                    }
                    var employees = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        var employee = employees[index];
                        String name = employee["name"];
                        String age = employee["age"];

                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.account_circle),
                            ),
                            title: Text(name),
                            subtitle: Text(age),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => UpdateEmployee(
                                              employeeId: employee.id,
                                              oldName: name,
                                              oldAge: age,
                                            ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('employees')
                                        .doc(employee.id)
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      userName = fetchedUsername;
    });
  }

  Future<String?> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      return userDoc["username"];
    }
    return null;
  }

  // <editor-fold desc="without bloc">
  // Future<File?> pickImage() async {
  //   try {
  //     final XFile? pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //     );
  //
  //     if (pickedFile == null) {
  //       if (kDebugMode) print("No image selected.");
  //       return null;
  //     }
  //
  //     File imageFile = File(pickedFile.path);
  //     if (kDebugMode) print("Image picked: ${imageFile.path}");
  //     return imageFile;
  //   } catch (e) {
  //     if (kDebugMode) print("Error picking image: $e");
  //     return null;
  //   }
  // }
  //
  // Future<String> uploadProfilePicture() async {
  //   try {
  //     File? imageFile = await pickImage();
  //
  //     if (imageFile == null) {
  //       if (kDebugMode) print("No image selected.");
  //       return "";
  //     }
  //
  //     if (!await imageFile.exists()) {
  //       if (kDebugMode) print("File does not exist.");
  //       return "";
  //     }
  //
  //     String fileName =
  //         "profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg";
  //     Reference ref = FirebaseStorage.instance.ref().child(fileName);
  //
  //     if (kDebugMode) print("Uploading image to Firebase Storage...");
  //
  //     UploadTask uploadTask = ref.putFile(imageFile);
  //
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       if (kDebugMode) {
  //         print(
  //           "Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}",
  //         );
  //       }
  //     });
  //
  //     TaskSnapshot snapshot = await uploadTask;
  //
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     if (kDebugMode) print("Image uploaded successfully: $downloadUrl");
  //
  //     await updateProfilePicture(downloadUrl);
  //     return downloadUrl;
  //   } catch (e) {
  //     if (kDebugMode) print("Error uploading image: $e");
  //     return "";
  //   }
  // }
  //
  // Future<void> updateProfilePicture(String imageUrl) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
  //       "profilePic": imageUrl,
  //     }, SetOptions(merge: true));
  //   }
  // }
  //
  // Future<String?> fetchProfilePic() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     try {
  //       DocumentSnapshot doc =
  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(user.uid)
  //               .get();
  //
  //       if (doc.exists) {
  //         // Safely check if the document data is not null
  //         var data = doc.data() as Map<String, dynamic>?;
  //
  //         if (data != null && data.containsKey('profilePic')) {
  //           setState(() {
  //             profilePicUrl = data['profilePic'];
  //           });
  //           return profilePicUrl; // Return the fetched URL
  //         } else {
  //           if (kDebugMode) {
  //             print("Profile picture field doesn't exist");
  //           }
  //           return null; // Return null if field doesn't exist
  //         }
  //       } else {
  //         if (kDebugMode) {
  //           print("Document doesn't exist");
  //         }
  //         return null; // Return null if document doesn't exist
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print("Error fetching profile picture: $e");
  //       }
  //       return null; // Return null in case of error
  //     }
  //   }
  //   return null; // Return null if user is not logged in
  // }
  //</editor-fold>
}
