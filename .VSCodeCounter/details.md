# Details

Date : 2020-03-08 16:29:50

Directory c:\flutter\project\gottask\lib

Total : 63 files,  10442 codes, 31 comments, 571 blanks, all 11044 lines

[summary](results.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/app.dart](/lib/app.dart) | Dart | 45 | 0 | 6 | 51 |
| [lib/base/base_bloc.dart](/lib/base/base_bloc.dart) | Dart | 22 | 0 | 4 | 26 |
| [lib/base/base_event.dart](/lib/base/base_event.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/bloc/all_pokemon_bloc.dart](/lib/bloc/all_pokemon_bloc.dart) | Dart | 35 | 0 | 10 | 45 |
| [lib/bloc/current_pokemon_bloc.dart](/lib/bloc/current_pokemon_bloc.dart) | Dart | 32 | 0 | 9 | 41 |
| [lib/bloc/do_del_done_habit_bloc.dart](/lib/bloc/do_del_done_habit_bloc.dart) | Dart | 36 | 0 | 11 | 47 |
| [lib/bloc/do_del_done_todo_bloc.dart](/lib/bloc/do_del_done_todo_bloc.dart) | Dart | 37 | 0 | 10 | 47 |
| [lib/bloc/habit_bloc.dart](/lib/bloc/habit_bloc.dart) | Dart | 52 | 0 | 13 | 65 |
| [lib/bloc/handside_bloc.dart](/lib/bloc/handside_bloc.dart) | Dart | 23 | 0 | 9 | 32 |
| [lib/bloc/pokemon_bloc.dart](/lib/bloc/pokemon_bloc.dart) | Dart | 37 | 0 | 10 | 47 |
| [lib/bloc/star_bloc.dart](/lib/bloc/star_bloc.dart) | Dart | 39 | 0 | 9 | 48 |
| [lib/bloc/today_task_bloc.dart](/lib/bloc/today_task_bloc.dart) | Dart | 83 | 0 | 13 | 96 |
| [lib/components/clip_digit.dart](/lib/components/clip_digit.dart) | Dart | 40 | 2 | 7 | 49 |
| [lib/components/countdown_clock.dart](/lib/components/countdown_clock.dart) | Dart | 237 | 0 | 16 | 253 |
| [lib/components/digit.dart](/lib/components/digit.dart) | Dart | 141 | 0 | 16 | 157 |
| [lib/components/habit_tile.dart](/lib/components/habit_tile.dart) | Dart | 121 | 0 | 8 | 129 |
| [lib/components/image_viewer.dart](/lib/components/image_viewer.dart) | Dart | 68 | 7 | 6 | 81 |
| [lib/components/pet_tag.dart](/lib/components/pet_tag.dart) | Dart | 37 | 0 | 2 | 39 |
| [lib/components/pet_tag_custom.dart](/lib/components/pet_tag_custom.dart) | Dart | 40 | 0 | 2 | 42 |
| [lib/components/slide_direction.dart](/lib/components/slide_direction.dart) | Dart | 4 | 0 | 1 | 5 |
| [lib/components/today_task_tile.dart](/lib/components/today_task_tile.dart) | Dart | 279 | 4 | 12 | 295 |
| [lib/components/todo_app_bar.dart](/lib/components/todo_app_bar.dart) | Dart | 71 | 0 | 4 | 75 |
| [lib/constant.dart](/lib/constant.dart) | Dart | 1,620 | 0 | 62 | 1,682 |
| [lib/database/doDelDoneHabitDatabase.dart](/lib/database/doDelDoneHabitDatabase.dart) | Dart | 26 | 3 | 7 | 36 |
| [lib/database/doDelDoneHabitTable.dart](/lib/database/doDelDoneHabitTable.dart) | Dart | 61 | 0 | 6 | 67 |
| [lib/database/doDelDoneTodoDatabase.dart](/lib/database/doDelDoneTodoDatabase.dart) | Dart | 26 | 0 | 7 | 33 |
| [lib/database/doDelDoneTodoTable.dart](/lib/database/doDelDoneTodoTable.dart) | Dart | 61 | 0 | 6 | 67 |
| [lib/database/habitDatabase.dart](/lib/database/habitDatabase.dart) | Dart | 25 | 0 | 6 | 31 |
| [lib/database/habitTable.dart](/lib/database/habitTable.dart) | Dart | 100 | 0 | 8 | 108 |
| [lib/database/pokemonStateDatabase.dart](/lib/database/pokemonStateDatabase.dart) | Dart | 39 | 0 | 6 | 45 |
| [lib/database/pokemonStateTable.dart](/lib/database/pokemonStateTable.dart) | Dart | 47 | 0 | 7 | 54 |
| [lib/database/todayTaskDatabase.dart](/lib/database/todayTaskDatabase.dart) | Dart | 25 | 0 | 6 | 31 |
| [lib/database/todayTaskTable.dart](/lib/database/todayTaskTable.dart) | Dart | 90 | 0 | 8 | 98 |
| [lib/events/current_pokemon/update_favourite_pokemon_event.dart](/lib/events/current_pokemon/update_favourite_pokemon_event.dart) | Dart | 5 | 0 | 3 | 8 |
| [lib/events/do_del_done/update_dodeldone_habit_event.dart](/lib/events/do_del_done/update_dodeldone_habit_event.dart) | Dart | 7 | 0 | 2 | 9 |
| [lib/events/do_del_done/update_dodeldone_todo_event.dart](/lib/events/do_del_done/update_dodeldone_todo_event.dart) | Dart | 7 | 0 | 2 | 9 |
| [lib/events/habit/add_habit_event.dart](/lib/events/habit/add_habit_event.dart) | Dart | 8 | 0 | 2 | 10 |
| [lib/events/habit/delete_habit_event.dart](/lib/events/habit/delete_habit_event.dart) | Dart | 6 | 0 | 2 | 8 |
| [lib/events/habit/update_habit_event.dart](/lib/events/habit/update_habit_event.dart) | Dart | 8 | 0 | 2 | 10 |
| [lib/events/pokemon_state/update_pokemon_state_event.dart](/lib/events/pokemon_state/update_pokemon_state_event.dart) | Dart | 6 | 0 | 3 | 9 |
| [lib/events/star/add_star_event.dart](/lib/events/star/add_star_event.dart) | Dart | 5 | 0 | 2 | 7 |
| [lib/events/star/buy_item_event.dart](/lib/events/star/buy_item_event.dart) | Dart | 5 | 0 | 2 | 7 |
| [lib/events/today_task/add_today_task_event.dart](/lib/events/today_task/add_today_task_event.dart) | Dart | 9 | 0 | 2 | 11 |
| [lib/events/today_task/checked_today_task_event.dart](/lib/events/today_task/checked_today_task_event.dart) | Dart | 7 | 0 | 5 | 12 |
| [lib/events/today_task/delete_today_task_event.dart](/lib/events/today_task/delete_today_task_event.dart) | Dart | 6 | 0 | 2 | 8 |
| [lib/events/today_task/edit_today_task_event.dart](/lib/events/today_task/edit_today_task_event.dart) | Dart | 6 | 0 | 2 | 8 |
| [lib/main.dart](/lib/main.dart) | Dart | 10 | 0 | 2 | 12 |
| [lib/models/do_del_done_habit.dart](/lib/models/do_del_done_habit.dart) | Dart | 21 | 0 | 4 | 25 |
| [lib/models/do_del_done_task.dart](/lib/models/do_del_done_task.dart) | Dart | 21 | 0 | 3 | 24 |
| [lib/models/habit.dart](/lib/models/habit.dart) | Dart | 39 | 0 | 2 | 41 |
| [lib/models/pokemon_state.dart](/lib/models/pokemon_state.dart) | Dart | 14 | 0 | 1 | 15 |
| [lib/models/today_task.dart](/lib/models/today_task.dart) | Dart | 30 | 0 | 3 | 33 |
| [lib/screens/habit_screen/add_habit_screen.dart](/lib/screens/habit_screen/add_habit_screen.dart) | Dart | 631 | 0 | 13 | 644 |
| [lib/screens/habit_screen/habit_screen.dart](/lib/screens/habit_screen/habit_screen.dart) | Dart | 926 | 1 | 26 | 953 |
| [lib/screens/home_screen.dart](/lib/screens/home_screen.dart) | Dart | 628 | 0 | 27 | 655 |
| [lib/screens/option_screen/about_me_screen.dart](/lib/screens/option_screen/about_me_screen.dart) | Dart | 253 | 0 | 7 | 260 |
| [lib/screens/option_screen/setting_screen.dart](/lib/screens/option_screen/setting_screen.dart) | Dart | 122 | 0 | 9 | 131 |
| [lib/screens/pokemon_screen/all_pokemon_screen.dart](/lib/screens/pokemon_screen/all_pokemon_screen.dart) | Dart | 1,295 | 0 | 36 | 1,331 |
| [lib/screens/pokemon_screen/pokemon_info_screen.dart](/lib/screens/pokemon_screen/pokemon_info_screen.dart) | Dart | 600 | 0 | 14 | 614 |
| [lib/screens/splash_screen/config_screen.dart](/lib/screens/splash_screen/config_screen.dart) | Dart | 45 | 0 | 3 | 48 |
| [lib/screens/splash_screen/splash_screen.dart](/lib/screens/splash_screen/splash_screen.dart) | Dart | 123 | 0 | 3 | 126 |
| [lib/screens/todo_screen/add_today_task_screen.dart](/lib/screens/todo_screen/add_today_task_screen.dart) | Dart | 969 | 8 | 42 | 1,019 |
| [lib/screens/todo_screen/today_task_screen.dart](/lib/screens/todo_screen/today_task_screen.dart) | Dart | 1,030 | 6 | 37 | 1,073 |

[summary](results.md)