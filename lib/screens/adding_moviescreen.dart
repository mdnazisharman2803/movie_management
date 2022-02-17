import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../model/firestore.dart';
import '../model/pickimage.dart';
import '../model/user_model.dart';
import 'home_screen.dart';

class AddMovies extends StatefulWidget {
  const AddMovies({Key? key}) : super(key: key);

  @override
  _AddMoviesState createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  final _formKey = GlobalKey<FormState>();
  final titleController = new TextEditingController();
  final directorController = new TextEditingController();
  bool isLoading = false;
  Uint8List? _file;

  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void savemovie(
    String uid,
  ) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPoster(
        uid,
        titleController.text,
        directorController.text,
        _file!,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Created a movie list',
        );
        clearImage();
        clearInputfield();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void clearInputfield() {
    setState(() {
      titleController.text = "";
      directorController.text = "";
    });
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add Poster'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    directorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleField = TextFormField(
        autofocus: false,
        controller: titleController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Movie title can not be empty");
          }
          return null;
        },
        onSaved: (value) {
          titleController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Title of the movie",
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final directorField = TextFormField(
        autofocus: false,
        controller: directorController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Name of director can not be empty");
          }
          return null;
        },
        onSaved: (value) {
          directorController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name of the director",
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final createButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          savemovie(
            '${loggedInUser.uid}',
          );
        },
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                "Save",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        title: Text('Add a Movie'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 25),
                      titleField,
                      SizedBox(height: 25),
                      directorField,
                      SizedBox(height: 25),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.red),
                            ),
                            child: _file == null
                                ? const Text(
                                    'No poster selected',
                                    textAlign: TextAlign.center,
                                  )
                                : Image(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: FlatButton.icon(
                              onPressed: () => _selectImage(context),
                              icon: Icon(Icons.add_a_photo_sharp),
                              label: Text('Upload Poster'),
                              textColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 55),
                      createButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
