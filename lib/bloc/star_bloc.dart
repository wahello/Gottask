import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/star/add_star_event.dart';
import 'package:gottask/events/star/buy_item_event.dart';


int currentStarPoint = 0;

class StarBloc extends BaseBloc {
  StreamController<int> _pointController = StreamController<int>();
  Stream<int> get pointStream => _pointController.stream;
  Sink<int> get pointSink => _pointController.sink;
  initStarBloc() async {
    currentStarPoint = await currentStar();
    pointSink.add(currentStarPoint);
  }

  _addEvent(int point) async {
    await getStar(point);
    currentStarPoint += point;
    pointSink.add(currentStarPoint);
  }

  _buyEvent(int cost) async {
    await loseStar(cost);
    currentStarPoint -= cost;
    pointSink.add(currentStarPoint);
  }

  @override
  void dispose() {
    super.dispose();
    _pointController.close();
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is AddStarEvent) {
      _addEvent(event.point);
    } else if (event is BuyItemEvent) {
      _buyEvent(event.point);
    }
  }
}
