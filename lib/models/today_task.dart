import 'package:flutter/material.dart';

class TodayTask {
  int id;
  String content;
  bool isDone = false;
  String images;
  int color;
  String audioPath;
  String catagories;
  TodayTask({
    this.content,
    this.id,
    this.images,
    this.isDone,
    this.color,
    this.audioPath,
    @required this.catagories,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'images': images.toString(),
      'isDone': isDone == true ? 1 : 0,
      'color': color,
      'audioPath': audioPath,
      'catagories': catagories,
    };
  }
}
