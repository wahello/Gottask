import 'dart:async';
import 'package:flutter/material.dart';

import 'base_event.dart';

abstract class BaseBloc {
  final StreamController<BaseEvent> _streamController = StreamController<
      BaseEvent>(); //Khởi tạo controller chung để xác thực event đưa vào
  Sink<BaseEvent> get event =>
      _streamController.sink; //Lấy event từ stream bằng sink
  BaseBloc() {
    _streamController.stream.listen((event) {
      if (event is! BaseEvent) {
        throw Exception('It\'s not the BaseEvent.');
      }
      actEvent(event); // thực hiện tác vụ của event
    });
  }
  void actEvent(BaseEvent event);

  @mustCallSuper
  void dispose() {
    _streamController.close();
  }
}
