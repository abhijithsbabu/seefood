import 'dart:async';
import 'dart:io';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    String _food = 'apple pie';
    return Scaffold(
      appBar: AppBar(title: const Text('Food Name')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(File(imagePath)),
            ElevatedButton(
                onPressed: () async {
                  String url;
                  url = await extractData(_food);
                  print(url);
                  extractNutrient(url);
                },
                child: Text("Search"))
          ],
        ),
      ),
    );
  }
}

Future<String> extractData(String _food) async {
//Getting the response from the targeted url
  final response = await http.Client().get(Uri.parse(
      'https://www.nutritionvalue.org/search.php?food_query=' + _food));
  //Status Code 200 means response has been received successfully
  if (response.statusCode == 200) {
    //Getting the html document from the response
    var document = parser.parse(response.body);
    try {
      //Scraping the first article title
      var responseString1 = document
          .getElementsByClassName('results')[0]
          .children[0]
          .children[1]
          .children[0]
          .getElementsByTagName('a')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList()[0];
      //Converting the extracted titles into string and returning a list of Strings
      return responseString1.toString();
    } catch (e) {
      return 'err';
    }
  } else {
    return '${response.statusCode}';
  }
}

Future<String> extractNutrient(String _url) async {
//Getting the response from the targeted url
  final response_final = await http.Client()
      .get(Uri.parse('https://www.nutritionvalue.org' + _url));

  if (response_final.statusCode == 200) {
    var document_final = parser.parse(response_final.body);
    try {
      //NUTRIENTS PAGE
      var responseString_final = document_final
          .getElementById('nutrition-label')!
          .children[0]
          .children[0]
          .children[0]
          .children[0]
          .children[0]
          .children
          .map((e) => e.text.trim())
          .toList();
      print(responseString_final.toString());
      return responseString_final.toString();
    } catch (e) {
      return 'err';
    }
  } else {
    return '${response_final.statusCode}';
  }
}