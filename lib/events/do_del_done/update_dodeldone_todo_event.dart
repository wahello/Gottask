import 'package:flutter/material.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/do_del_done_task.dart';

class UpdateDoDelDoneTodoEvent extends BaseEvent {
  final DoDelDoneTodo doDelDoneTodo;
  UpdateDoDelDoneTodoEvent({@required this.doDelDoneTodo});
}
