import 'package:flutter/cupertino.dart';

class screenTwoProvider with ChangeNotifier{
  String? _path = " ";
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
    _path = value;
  }
  String? getPath()
  {
    return _path;
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