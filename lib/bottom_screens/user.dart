import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:shikha_tycs/constants.dart';
import 'package:shikha_tycs/authentication/loginpage.dart';
import 'package:shikha_tycs/favourite/wishlist.dart';
import 'dart:io'; // For handling file
import 'myVideos.dart';
import 'userprofile.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ImagePicker _picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instanceFor(
    bucket: 'gs://diymaking-34b69.appspot.com',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _showVideoOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.video_library,color: Colors.lightBlue,),
                title: Text("Upload from Gallery",style: TextStyle(color: Colors.black54),),
                onTap: () async {
                  final XFile? video = await _picker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (video != null) {
                    print('Gallery video selected: ${video.path}');
                    await _showVideoMetadataForm(File(video.path));
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam,color: Colors.lightBlue,),
                title: Text("Record Video",style: TextStyle(color: Colors.black54),),
                onTap: () async {
                  final XFile? video = await _picker.pickVideo(
                    source: ImageSource.camera,
                  );
                  if (video != null) {
                    print('Camera video recorded: ${video.path}');
                    await _showVideoMetadataForm(File(video.path));
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showVideoMetadataForm(File videoFile) async {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _thingsRequiredController = TextEditingController();
    XFile? _thumbnail; // To hold the thumbnail image file

    print('Showing video metadata form');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.lightBlue,
              scrollable: true,
              title: Text(
                'Add Video Details',
                style: TextStyle(color: Colors.white,fontFamily: "StardosStencil"),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _thingsRequiredController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Things Required',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _thumbnail == null
                        ? ElevatedButton.icon(
                      onPressed: () async {
                        // Using a lightweight image picker
                        final pickedThumbnail = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 300, // Limit size for faster processing
                          maxHeight: 300,
                        );

                        if (pickedThumbnail != null) {
                          setState(() {
                            _thumbnail = pickedThumbnail; // Update thumbnail immediately
                          });
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.lightBlue,
                      ),
                      label: Text(
                        'Pick Thumbnail',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                        : Column(
                      children: [
                        Image.file(File(_thumbnail!.path), height: 100, fit: BoxFit.cover),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _thumbnail = null; // Update thumbnail to null
                            });
                          },
                          child: Text('Remove Thumbnail',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (_thumbnail != null && _titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _thingsRequiredController.text.isNotEmpty)  {
                      await _uploadVideoToFirebase(
                        videoFile,
                        _thumbnail!,
                        _titleController.text,
                        _descriptionController.text,
                        _thingsRequiredController.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter all the fields and select a thumbnail image.',style: TextStyle(color: Colors.white),),backgroundColor: Colors.lightBlue,),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _uploadVideoToFirebase(
      File videoFile,
      XFile thumbnailFile,
      String title,
      String description,
      String thingsRequired,
      ) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String fileName = 'videos/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      String thumbnailName = 'thumbnails/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload video
      UploadTask uploadTask = storage.ref(fileName).putFile(videoFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String videoDownloadURL = await taskSnapshot.ref.getDownloadURL();

      // Upload thumbnail
      UploadTask thumbnailUploadTask = storage.ref(thumbnailName).putFile(File(thumbnailFile.path));
      TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask.whenComplete(() => {});
      String thumbnailDownloadURL = await thumbnailSnapshot.ref.getDownloadURL();

      // Store video and thumbnail information in Firestore
      await _firestore.collection('user_videos').add({
        'userId': user.uid,
        'videoUrl': videoDownloadURL,
        'thumbnailUrl': thumbnailDownloadURL,
        'title': title,
        'description': description,
        'thingsRequired': thingsRequired,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully!',style: TextStyle(color: Colors.white),),backgroundColor: Colors.lightBlue,)
      );

      print('Video uploaded successfully: $videoDownloadURL');
    } catch (e) {
      print('Error uploading video: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading video. Please try again.',style: TextStyle(color: Colors.white),),backgroundColor: Colors.lightBlue,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/splash.jpg'), // Optional background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white30.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Userprofile()));
                          }, icon: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.lightBlue,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          ),
                          SizedBox(height: 15),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Come on",style: TextStyle(fontSize: 22,color: Colors.black54,fontFamily: "StardosStencil"
                                  ),),
                                  UserNameWidget(),
                                ],
                              ),
                              Text(
                                'Add Yours!',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Let\'s get started with your videos!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          IconButton(
                            onPressed: _showVideoOptions,
                            icon: Icon(Icons.add_circle, size: 40, color: Colors.lightBlue),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyVideosScreen()),
                              );
                            },
                            child: Text('Show My Videos',),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.lightBlue,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        backgroundColor: Colors.white,
                        contentPadding: EdgeInsets.all(20),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout, color: Colors.lightBlue, size: 50), // Added logout icon
                            SizedBox(height: 20), // Space between icon and text
                            Text(
                              "Do you want to log out?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Slightly less harsh than pure black
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.cancel, color: Colors.redAccent),
                                iconSize: 30,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => login()),
                                    );
                                  }
                                },
                                icon: Icon(Icons.done, color: Colors.green),
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Sign Out"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}