import 'package:flutter/material.dart';
import 'package:flutter_saas/widgets/image_preview.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  late TextRecognizer textRecognizer;

  String? pikedImagePath;
  String recognizedText = "";
  bool isImagePicked = false;
  bool isprocessing = false;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  //Function to pick image

  void _pickImage({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pikedImagePath = pickedImage.path;
      isImagePicked = true;
    });
  }

  //Fnction to process the picked image

  void _processImage() async {
    if (pikedImagePath == null) {
      return;
    }
    setState(() {
      isprocessing = true;
      recognizedText = "";
    });

    try {
      final inputImage = InputImage.fromFilePath(pikedImagePath!);

      final RecognizedText textReturnedFrommodel =
          await textRecognizer.processImage(inputImage);

      for (TextBlock block in textReturnedFrommodel.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text}\n";
        }
      }
    } catch (error) {
      print(error.toString());
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Recognizing text"),
        ),
      );
    } finally {
      setState(() {
        isprocessing = false;
      });
    }
  }

  //show bottom sheet

  void _showBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source: ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take a Image from camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source: ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ML Text Recognition",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: ImagePreview(
                  imagePath: pikedImagePath,
                ),
              ),
              if (!isImagePicked)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _showBottomSheetWidget,
                      child: const Text(
                        "Pick an Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              if (isImagePicked)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: isprocessing ? null : _processImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Process Image",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          if (isprocessing) ...[
                            const SizedBox(
                              width: 20,
                            ),
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Reconozed text",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.copy,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              if (!isprocessing) ...[
                Expanded(
                  child: Scrollbar(
                    child: Row(
                      children: [
                        SelectableText(
                          recognizedText.isEmpty
                              ? "No Text recognized"
                              : recognizedText,
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
