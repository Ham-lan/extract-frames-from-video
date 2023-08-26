import 'dart:async';
import 'dart:io';
//import 'dart:js_util';
//import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:deep_fake_detection/component/button.dart';
import 'package:deep_fake_detection/providers/screenTwoProvider.dart';
import 'package:deep_fake_detection/third_screen.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

//import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
//import 'providers/';
import 'package:provider/provider.dart';

//import 'package:image/image.dart' as img;
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  @override
  void initState() {
    super.initState();
    loadModel();
  }


  Future<Float32List> imageToFloat32(Image image) async {
    ui.Image img = image as ui.Image;
    // Convert the image to a byte array
    ByteData? imageData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);

// Convert the byte array to a Float32List
    return Float32List.view(
      imageData!.buffer,
      imageData.offsetInBytes ~/ Float32List.bytesPerElement,
      imageData.lengthInBytes ~/ Float32List.bytesPerElement,
    );
  }



  Future loadModel()
  async {
    final interpreter = await tfl.Interpreter.fromAsset('model.tflite');
    interpreter.close();
  }



  Future<Float32List> imageToFloat32conv(ui.Image image) async {
    // Convert the image to a byte array
    ByteData? imageData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    // Convert the byte array to a Float32List
    return Float32List.view(
      imageData!.buffer,
      imageData.offsetInBytes ~/ Float32List.bytesPerElement,
      imageData.lengthInBytes ~/ Float32List.bytesPerElement,
    );
  }

  Future<double> getDataFromModel(List<Image> images) async {
    var sum = 0.0;

    // Load the model
    final interpreter = await tfl.Interpreter.fromAsset('model.tflite');

    // Resize the image to the required input shape
    final inputSize = interpreter.getInputTensor(0).shape[1];
    for (final image in images) {
     //  final resizedImage = await image.toByteData();
     //  ui.Image img = await decodeImageFromList(resizedImage.buffer.asUint8List());
     // // img = await cropImage(img);
    //  img = await resizeImage(img, inputSize, inputSize);
    //   final input = await imageToFloat32(img as Image);
    //
    //   // Run the inference
    //   final output = List.filled(2, 0.0).reshape([1, 2]);
    //   interpreter.run(input, output);
    //
    //   // Print the output
    //   print(output);
    //
    //   sum += output[0][0] as double;
    }

    // Close the interpreter
    interpreter.close();

    return sum;
  }

  Future<String?> pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    //setPath(pickedFile!.path);
    //return pickedFile!.path;
    //setfilePicked(true);
   // setSnapShots(pickedFile);
    //accessScreenshotsDirectory();
    File video = File(pickedFile!.path);
    print("We are in pickVideo function ");
    print(video.path);
    return video.path;
    //Future<List<Image>> images = generateVideoThumbnails();
    //video.length();
  }




  // A function To get Image SnapShots from video
  Future<List<Image>> pickVideo2(String path, bool filePicked) async {

    if (filePicked == true) {
      File videoFile = File(path);

      List<Image> snapshotImages = [];

      int snapshotCount = 0;
      for (double i = 1.0; i <= 10.0; i += 1.0) {
        // Use the VideoThumbnail package to get the snapshot
        final uint8list = await VideoThumbnail.thumbnailData(
          video: videoFile.path,
          imageFormat: ImageFormat.JPEG,
          timeMs: (i * 1000).toInt(),
        );

        // Convert the snapshot to an Image widget
        final image = Image.memory(
          uint8list!,
          fit: BoxFit.cover,
        );

        snapshotImages.add(image);

        snapshotCount++;
      }
      // double sum = await getDataFromModel(snapshotImages);
      // print(sum);

      return snapshotImages;
    }

    // If no video was picked, return an empty list
    return [];
  }



// If we use the FFMPEG (which we are not using currently) we can use this function
  Future<List<Image>> generateVideoThumbnails() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
    await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      //{
      File videoFile = File(pickedFile.path);
      String videoFilePath = pickedFile.path;
      int imagesCount = 20;
      final Directory outputDirectory = await Directory.systemTemp.createTemp();
      final String outputPath = outputDirectory.path + "/image-%03d.png";

      final String command = "-i ${videoFilePath} -r $imagesCount -f image2 ${outputPath}";

      final session = await FFmpegKit.executeAsync(command);

      final returnCode = await session.getReturnCode();

      List<Image> images = [];

      if (ReturnCode.isSuccess(returnCode)) {
        final List<FileSystemEntity> files = outputDirectory.listSync();

        for (final FileSystemEntity file in files) {
          if (file is File) {
            final contents = await file.readAsBytes();

            final image = Image.memory(
              contents,
              fit: BoxFit.cover,
            );

            images.add(image);
          }
        }
      }

      await outputDirectory.delete(recursive: true);

      return images;
    }
    return [];
  }


  @override
  Widget build(BuildContext context) {
    List images = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<screenTwoProvider>(
                builder: (context,value,child){
                  String myPath = " ";
                  return  InkWell(
                    onTap: () async {
                      String? path =  await pickVideo();

                      print(path);
                      if(path==null)
                      {

                        value.setPath(" ");

                      }
                      if(path!=null)
                      {
                        print("Here is path for Video : ");
                        print(path.toString());
                        value.setPath(path.toString());
                      }

                      value.setfilePicked(true);
                      List<Image> images = await pickVideo2(
                          value.getPath().toString(),
                          value.getfilePicked()
                      );

                      value.setImages(images);
                    },
                    child: Container(
                      height: 90,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange,
                      ),
                      child: Center(child: Text('Upload Video')),
                    ),
                  );

                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Consumer<screenTwoProvider>(
                builder: (context,value,child){
                  String path=' ';
                  return InkWell(
                    onTap: () async{
                      double totalSum = await getDataFromModel(value.images);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.orange,
                          ),
                          child: Center(child: Text('Detect')),
                        ),
                      ],

                    ),
                  );
                },
              ),

          ]),
      ),
    );
  }
}
