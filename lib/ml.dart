import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ModelTestPage extends StatefulWidget {
  const ModelTestPage({Key? key}) : super(key: key);

  @override
  State<ModelTestPage> createState() => _ModelTestPageState();
}

class _ModelTestPageState extends State<ModelTestPage> {
  List? _outputs;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel().then((value) {
      setState(() {});
    });
  }

  _loadModel() async {
    await Tflite.loadModel(
      model: "assets/seefood.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 0.0,
      imageStd: 255.0,
    );
    setState(() {
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  // Camera Code

  // Gallery Code
  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = image;
    });
    classifyImage(File(_image!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Model Test"),
      ),
      body: _image == null
          ? Center(
              child: Column(
              children: [
                Text("No Image Selected"),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF65708F),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        _pickImage();
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      )),
                )
              ],
            ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Image.file(File(_image!.path)), Text(_outputs != null ? _outputs.toString() : 'No Output')],
              ),
            ),
    );
  }
}
