import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/constant.dart';



class HandsideBloc extends BaseBloc {
  StreamController<HandSide> _handSideStreamController =
      StreamController<HandSide>.broadcast();

  StreamController<HandSide> get handSideStreamController => _handSideStreamController;
  Stream<HandSide> get handsideStream => _handSideStreamController.stream;
  Sink<HandSide> get handsideSink => _handSideStreamController.sink;

  initHandsideBloc() async {
    handsideSink.add(await currentHandSide());
  }

  @override
  void dispose() {
    super.dispose();
    _handSideStreamController.close();
  }

  @override
  void actEvent(BaseEvent event) async {
    _handSideStreamController.sink.add(await currentHandSide());
  }
}
