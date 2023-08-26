
import 'package:flutter/cupertino.dart';

class screenTwoProvider with ChangeNotifier{
  String? path = " ";
  List<Image> images = [];
  bool filePicked= false;

  void setfilePicked(bool value)
  {
    filePicked = value;
  }
  bool getfilePicked()
  {
    return filePicked;
  }

  void setPath(String value)
  {
    path = value;
  }
  String? getPath()
  {
    return path;
  }

  void setImages(List<Image> imageValues)
  {
    images = imageValues;
  }
  List<Image> getImages()
  {
    return images;
  }

}