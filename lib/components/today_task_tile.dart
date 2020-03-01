
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gottask/bloc/do_del_done_todo_bloc.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/bloc/today_task_bloc.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/do_del_done/update_dodeldone_todo_event.dart';
import 'package:gottask/events/star/add_star_event.dart';
import 'package:gottask/events/today_task/checked_today_task_event.dart';
import 'package:gottask/events/today_task/delete_today_task_event.dart';
import 'package:gottask/models/do_del_done_task.dart';
import 'package:gottask/models/today_task.dart';
import 'package:gottask/screens/todo_screen/today_task_screen.dart';
import 'package:provider/provider.dart';

class TodayTaskTile extends StatefulWidget {
  final TodayTask task;
  final BuildContext ctx;
  final int index;
  const TodayTaskTile({
    Key key,
    this.task,
    this.ctx,
    @required this.index,
  }) : super(key: key);

  @override
  _TodayTaskTileState createState() => _TodayTaskTileState();
}

class _TodayTaskTileState extends State<TodayTaskTile> {
  bool _isChecked;
  TodayTaskBloc _todayTaskBloc;
  DoDelDoneTodoBloc _doDelDoneTodoBloc;
  StarBloc _starBloc;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    _todayTaskBloc = Provider.of<TodayTaskBloc>(context);
    _doDelDoneTodoBloc = Provider.of<DoDelDoneTodoBloc>(context);
    _starBloc = Provider.of<StarBloc>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: 8,
        right: 10,
        left: 10,
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        fastThreshold: 20,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodayTaskScreen(
                    todayTask: widget.task,
                    ctx: widget.ctx,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                    _todayTaskBloc.event.add(CheckedTodayTaskEvent(
                      todayTask: widget.task,
                      value: _isChecked,
                    ));
                  },
                  child: _isChecked
                      ? Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color:
                                  Color(int.parse(colors[widget.task.color])),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(
                                  int.parse(colors[widget.task.color]),
                                ),
                                width: 2,
                              ),
                            ),
                            // child: Icon(
                            //   Icons.check,
                            //   color: Colors.white,
                            // ),
                          ),
                        ),
                ),
                Expanded(
                  child: Text(
                    widget.task.content,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontSize: 15,
                      decoration: _isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: _isChecked
                          ? Color(int.parse(colors[widget.task.color]))
                          : Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: 2,
                  color: Color(int.parse(colors[widget.task.color])),
                ),
              ],
            ),
          ),
        ),
        secondaryActions: <Widget>[
          SlideAction(
            closeOnTap: true,
            decoration: BoxDecoration(
              color: _isChecked == false
                  ? Colors.lightGreen
                  : Color(int.parse(colors[widget.task.color])),
              borderRadius: _isChecked
                  ? BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(
                      _isChecked == false
                          ? MaterialCommunityIcons.check
                          : Icons.check_circle,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text(
                      _isChecked == false ? 'Check' : 'Done',
                      style: TextStyle(
                        fontFamily: 'Alata',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              if (_isChecked == false) {
                setState(() {
                  _isChecked = !_isChecked;
                });
                _todayTaskBloc.event.add(
                  CheckedTodayTaskEvent(
                    todayTask: widget.task,
                    value: _isChecked,
                  ),
                );
              } else if (_isChecked == true) {
                await saveDoneTask();

                int doTodo = await onDoingTask();
                int delTodo = await readDeleteTask();
                int doneTodo = await readDoneTask();

                _doDelDoneTodoBloc.event.add(
                  UpdateDoDelDoneTodoEvent(
                    doDelDoneTodo: DoDelDoneTodo(
                      id: 1,
                      doTodo: doTodo,
                      delTodo: delTodo,
                      doneTodo: doneTodo,
                    ),
                  ),
                );
                _todayTaskBloc.event.add(
                  DeleteTodayTaskEvent(
                    todayTask: widget.task,
                  ),
                );

                _starBloc.event.add(
                  AddStarEvent(
                    point: 1,
                  ),
                );
              }
            },
          ),
          if (_isChecked == false)
            SlideAction(
              onTap: () async {
                await saveDeleteTask();
                int doTodo = await onDoingTask();
                int delTodo = await readDeleteTask();
                int doneTodo = await readDoneTask();

                _doDelDoneTodoBloc.event.add(
                  UpdateDoDelDoneTodoEvent(
                    doDelDoneTodo: DoDelDoneTodo(
                      id: 1,
                      doTodo: doTodo,
                      delTodo: delTodo,
                      doneTodo: doneTodo,
                    ),
                  ),
                );
                _todayTaskBloc.event.add(
                  DeleteTodayTaskEvent(
                    todayTask: widget.task,
                  ),
                );
              },
              closeOnTap: true,
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Icon(
                        MaterialIcons.delete_forever,
                        size: 30,
                        color: Colors.white,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                          fontFamily: 'Alata',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
