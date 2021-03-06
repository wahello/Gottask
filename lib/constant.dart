

import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PlayerState {
  READY,
  PLAY,
  PAUSE,
  END,
}

enum TimerState {
  PLAY,
  PAUSE,
  DONE,
}

enum ScreenState {
  Home,
  Chart,
}

enum HandSide {
  Left,
  Right,
}

class TodoColors {
  static const deepPurple = Color(0xFF44427D);
  static const lightOrange = Color(0xFFFAA662);
  static const pastelPink = Color(0xFFE9857B);
  static const scaffoldWhite = Color(0xFFF6F5F4);
  static const chocolate = Color(0xFFD2691E);
  static const grassOld = Color(0xFF535F2D);
  static const lightGreen = Color(0xFF8BBC2F);
  static const spiritBlue = Color(0xFF4C6AC4);
  static const blueMoon = Color(0xFF71AEC3);
  static const blueAqua = Color(0xFF0181A0);
  static const spaceGrey = Color(0xFF687C95);
  static const groundPink = Color(0xFFD05D40);
  static const massiveRed = Color(0xFF89202D);
}

List<String> splashScreen = [
  'assets/splash/screen_home.jpg',
  'assets/splash/screen_add_todo.png',
  'assets/splash/screen_habit.jpg',
  'assets/splash/screen_habit.png',
  'assets/splash/screen_pokemon_all.jpg',
];

Future<bool> currentStartState() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_start_key';
  final res = prefs.getBool(key) == null ? false : prefs.getBool(key);
  return res;
}

Future<bool> updateStartState() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_start_key';
  prefs.setBool(key, true);
  return prefs.getBool(key);
}

Future<int> currentFavouritePokemon() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_favourite_pokemon_key';
  final res = prefs.getInt(key) == null ? -1 : prefs.getInt(key);
  return res;
}

Future<int> updateFavouritePokemon(int newPokemon) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_favourite_pokemon_key';
  prefs.setInt(key, newPokemon);
  return prefs.getInt(key);
}

Future<HandSide> currentHandSide() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_handside_key';
  final res = prefs.getInt(key) == null ? 0 : prefs.getInt(key);
  if (res == 0) return HandSide.Left;
  return HandSide.Right;
}

Future<int> updateHandSide(HandSide handSide) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_handside_key';
  handSide == HandSide.Left ? prefs.setInt(key, 0) : prefs.setInt(key, 1);
  return prefs.getInt(key);
}

Future<int> currentStar() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_star_key';
  if (prefs.getInt(key) == null) prefs.setInt(key, 0);
  final value = prefs.getInt(key);
  return value;
}

Future<int> getStar(int value) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_star_key';
  final res = prefs.getInt(key) + value;
  prefs.setInt(key, res);
  return value;
}

Future<int> loseStar(int value) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_star_key';
  final res = prefs.getInt(key) - value;
  prefs.setInt(key, res);
  return value;
}

Future<bool> isInitDatabase() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'is_init_database_key';
  if (prefs.getBool(key) == null) {
    prefs.setBool(key, true);
    return false;
  } else {
    return true;
  }
}

String durationFormat(String duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  List<String> elements = duration.split(':');
  List<String> seconds = elements[2].split('.');
  return '${twoDigits(int.parse(elements[0]))}h : ${twoDigits(int.parse(elements[1]))}m : ${twoDigits(int.parse(seconds[0]))}\'';
}

String durationFormatByDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  return '${twoDigits(duration.inHours)} : ${twoDigits(duration.inMinutes.remainder(60))} : ${twoDigits(duration.inSeconds.remainder(60))}';
}

int getTaskComplete(List<bool> isDoneAchieve) {
  int res = 0;
  isDoneAchieve.forEach((isDone) {
    if (isDone == true) res++;
  });
  return res;
}

Future<int> savePetState(int value) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_pet_key';
  prefs.setInt(key, value);
  return value;
}

Future<int> readPetState() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_pet_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : -1;
  return value;
}

Future<int> saveTodayTaskID() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_todaytask_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) + 1 : 1;
  prefs.setInt(key, value);
  return value;
}

Future<int> readTodayTaskID() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_todaytask_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : 0;
  return value;
}

Future<int> saveHabitID() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_habit_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) + 1 : 1;
  prefs.setInt(key, value);
  return value;
}

Future<int> readHabitID() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_habit_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : 0;
  return value;
}

Future<int> saveDoneTask() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_done_task_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) + 1 : 1;
  prefs.setInt(key, value);
  return value;
}

Future<int> readDoneTask() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_done_task_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : 0;
  return value;
}

Future<int> saveDeleteTask() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_delete_task_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) + 1 : 1;
  prefs.setInt(key, value);
  return value;
}

Future<int> readDeleteTask() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_delete_task_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : 0;
  return value;
}

Future<int> onDoingTask() async {
  int value =
      await readTodayTaskID() - await readDeleteTask() - await readDoneTask();
  return value;
}

Future<int> onDoingHabit() async {
  int value =
      await readHabitID() - await readHabitGiveUp() - await readHabitDone();
  return value;
}

Future<void> saveHabitDone() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_habit_done_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) + 1 : 1;
  prefs.setInt(key, value);
}

Future<int> readHabitDone() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_habit_done_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : 0;
  return value;
}

Future<void> saveHabitGiveUp() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_habit_give_up_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) + 1 : 1;
  prefs.setInt(key, value);
}

Future<int> readHabitGiveUp() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_habit_give_up_key';
  final value = prefs.getInt(key) != null ? prefs.getInt(key) : 0;
  return value;
}

Future<void> setTime() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_time_open_app_key';
  final value = DateTime.now().toString();
  prefs.setString(key, value);
}

Future<String> readTime() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_time_open_app_key';
  final value = prefs.getString(key);
  return value;
}

Future<void> resetVideoReward() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_video_reward_key';
  final value = 0;
  prefs.setInt(key, value);
}

Future<void> updateVideoReward() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_video_reward_key';
  final value = prefs.getInt(key) == null ? 0 : prefs.getInt(key) + 1;
  prefs.setInt(key, value);
}

Future<int> getVideoReward() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_video_reward_key';
  final value = prefs.getInt(key) == null ? 0 : prefs.getInt(key);
  return value;
}

Future<void> setLoadAdsInfirst(bool val) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_load_ads_in_first_key';
  final value = prefs.getBool(key) == null ? false : val;
  prefs.setBool(key, value);
}

Future<bool> getLoadAdsInfirst() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_load_ads_in_first_key';
  final value = prefs.getBool(key) == null ? false : prefs.getBool(key);
  return value;
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['Gottask', 'productive apps', 'to-do', 'note'],
  contentUrl: 'https://www.facebook.com/profile.php?id=100013808691060',
  childDirected: false,
  testDevices: testDevice != null
      ? <String>[testDevice] // Android emulators are considered test devices
      : null,
);

const double kListViewHeight = 155;

const String testDevice = 'Test-id';

const String appId = 'ca-app-pub-8520565961626834~6649996964';

const String interstitialId = 'ca-app-pub-8520565961626834/1369750120';

const String bannerId = 'ca-app-pub-8520565961626834/2808677078';

const String rewardId = 'ca-app-pub-8520565961626834/9794007386';

List<String> icons = [
  "Icons.star_border",
  "Icons.airline_seat_individual_suite",
  "Icons.library_books",
  "Icons.library_music",
  "Icons.wallpaper",
  "Icons.warning",
  "Icons.wifi",
  "Icons.work",
  "Icons.wb_incandescent",
  "Icons.hot_tub",
  "Icons.import_contacts",
  "Icons.important_devices",
  "Icons.screen_lock_portrait",
  "Icons.rowing",
  "Icons.description",
  "Icons.directions_bike",
  "Icons.email",
  "Icons.fastfood",
  "fa.heart",
  "fa.heartbeat",
  "fa.dog",
];

List<String> colors = [
  TodoColors.deepPurple.toString().substring(6, 16),
  TodoColors.grassOld.toString().substring(6, 16),
  TodoColors.massiveRed.toString().substring(6, 16),
  TodoColors.chocolate.toString().substring(6, 16),
  TodoColors.spaceGrey.toString().substring(6, 16),
  TodoColors.spiritBlue.toString().substring(6, 16),
  TodoColors.groundPink.toString().substring(6, 16),
  TodoColors.blueAqua.toString().substring(6, 16),
  TodoColors.lightGreen.toString().substring(6, 16),
  TodoColors.lightOrange.toString().substring(6, 16),
  TodoColors.pastelPink.toString().substring(6, 16),
  TodoColors.blueMoon.toString().substring(6, 16),
];

List<String> catagories = [
  'Grocery',
  'Study',
  'Work',
  'Relax',
  'Event',
  'Party',
  'Hobby',
  'Reminder',
  'Planing',
];

List<IconData> catagoryIcons = [
  Icons.shopping_basket,
  Icons.library_books,
  Icons.work,
  Icons.hot_tub,
  Icons.event,
  Icons.local_play,
  Icons.weekend,
  Icons.edit,
  Icons.calendar_today,
];

Map<String, String> audioFile = {
  'Caught_Pokemon': 'musics/caught_pokemon.mp3',
  'Level_Up': 'musics/level_up.mp3',
};

List<String> pokeballImages = [
  'assets/png/038.png',
  'assets/png/017.png',
  'assets/png/019.png',
  'assets/png/024.png',
  'assets/png/028.png',
  'assets/png/030.png',
  'assets/png/035.png',
  'assets/png/040.png',
  'assets/png/048.png',
  'assets/png/055.png',
];

List<Map<String, dynamic>> pokeballInfo = [
  {
    'name': 'Poké Ball',
    'type': 'Psychic',
    'description':
        "It has a simple red and white design, and it's the most known kind of Poké Ball.",
  },
  {
    'name': "Great Ball",
    'type': 'Water',
    'description': "It is slightly better than the regular Poké Ball.",
  },
  {
    'name': 'Heavy Ball',
    'type': 'Normal',
    'description':
        "A ball whose catch rate increases as the weight of the targeted Pokémon does."
  },
  {
    'name': 'Fast Ball',
    'type': 'Electric',
    'description':
        "A kind of Poké Ball that works better with Pokémon that like to flee from trainers. It is normally associated with Raikou, Entei and Suicune."
  },
  {
    'name': 'Master Ball',
    'type': 'Poison',
    'description':
        "A very rare Poké Ball that never fails in an attempt to catch a Pokémon."
  },
  {
    'name': 'Nest Ball',
    'type': 'Grass',
    'description':
        "A kind of ball that becomes better if the level of the targeted Pokémon is lower.",
  },
  {
    'name': 'Park Ball',
    'type': 'Flying',
    'description':
        "A type of Poké Ball to be used only in the Bug Catching Contest in Johto. The are also used in the Pal Park in Sinnoh.",
  },
  {
    'name': 'Premier Ball',
    'type': 'Rock',
    'description':
        "They act the same way as a regular Poké Ball but has a completely white design and is given as a gift when ten or more Poké Balls are bought at once.",
  },
  {
    'name': 'Sport Ball',
    'type': 'Fire',
    'description':
        "A ball that is only used to capture Pokémon during a Bug-Catching Contest.",
  },
  {
    'name': 'Ultra Ball',
    'type': 'Bug',
    'description': "It is twice as good as a regular Poké Ball.",
  },
];

List<String> pokemonImages = [
  'assets/png/001.png',
  'assets/png/002.png',
  'assets/png/003.png',
  'assets/png/004.png',
  'assets/png/005.png',
  'assets/png/006.png',
  'assets/png/007.png',
  'assets/png/008.png',
  'assets/png/009.png',
  'assets/png/010.png',
  'assets/png/011.png',
  'assets/png/012.png',
  'assets/png/013.png',
  'assets/png/014.png',
  'assets/png/015.png',
  'assets/png/016.png',
  'assets/png/018.png',
  'assets/png/020.png',
  'assets/png/021.png',
  'assets/png/022.png',
  'assets/png/023.png',
  'assets/png/025.png',
  'assets/png/026.png',
  'assets/png/027.png',
  'assets/png/029.png',
  'assets/png/031.png',
  'assets/png/032.png',
  'assets/png/033.png',
  'assets/png/034.png',
  'assets/png/036.png',
  'assets/png/037.png',
  'assets/png/039.png',
  'assets/png/041.png',
  'assets/png/042.png',
  'assets/png/043.png',
  'assets/png/044.png',
  'assets/png/045.png',
  'assets/png/046.png',
  'assets/png/047.png',
  'assets/png/049.png',
  'assets/png/050.png',
  'assets/png/051.png',
  'assets/png/052.png',
  'assets/png/053.png',
  'assets/png/054.png',
  'assets/png/056.png',
  'assets/png/057.png',
  'assets/png/058.png',
  'assets/png/059.png',
  'assets/png/060.png',
];

Map<String, Color> tagColor = {
  'Bug': Color(0xFF729F3F),
  'Dragon': Color(0xFFF16E57),
  'Fairy': Color(0xFFFDB9E9),
  'Ghost': Color(0xFF7B62A3),
  'Ground': Color(0xFFF7DE3F),
  'Normal': Color(0xFFA4ACAF),
  'Steel': Color(0xFF9EB7B8),
  'Dark': Color(0xFF707070),
  'Electric': Color(0xFFEED535),
  'Fighting': Color(0xFFD56723),
  'Grass': Color(0xFF9BCC50),
  'Poison': Color(0xFFB97FC9),
  'Water': Color(0xFF4592C4),
  'Rock': Color(0xFFA38C21),
  'Fire': Color(0xFFFD7D24),
  'Flying': Color(0xFF3DC7EF),
  'Ice': Color(0xFF51C4E7),
  'Psychic': Color(0xFFF366B9),
};

List<Map<String, dynamic>> pokedex = [
  {
    'name': 'Aron',
    'HP': '50',
    'Attack': '70',
    'Defense': '100',
    'Speed': '30',
    'Sp Atk': '40',
    'Sp Def': '40',
    'height': '''1' 04"''',
    'weight': '132.3 lbs',
    'category': 'Iron Armor',
    'type': [
      'Steel',
      'Rock',
    ],
    'weaknesses': [
      'Fighting',
      'Ground',
      'Water',
    ],
    'introduction':
        '''This Pokémon has a body of steel. To make its body, Aron feeds on iron ore that it digs from mountains. Occasionally, it causes major trouble by eating bridges and rails.'''
  },
  {
    'name': 'Bellsprout',
    'HP': '50',
    'Attack': '75',
    'Defense': '35',
    'Speed': '40',
    'Sp Atk': '70',
    'Sp Def': '30',
    'height': '''2' 04"''',
    'weight': '8.8 lbs',
    'category': 'Flower',
    'type': [
      'Grass',
      'Poison',
    ],
    'weaknesses': [
      'Fire',
      'Flying',
      'Ice',
      'Psychic',
    ],
    'introduction':
        '''Bellsprout's thin and flexible body lets it bend and sway to avoid any attack, however strong it may be. From its mouth, this Pokémon spits a corrosive fluid that melts even iron.''',
  },
  {
    'name': 'Breloom',
    'HP': '60',
    'Attack': '130',
    'Defense': '80',
    'Speed': '70',
    'Sp Atk': '60',
    'Sp Def': '60',
    'height': '''3' 11"''',
    'weight': '86.4 lbs',
    'category': 'Mushroom',
    'type': [
      'Grass',
      'Fighting',
    ],
    'weaknesses': [
      'Flying',
      'Fire',
      'Ice',
      'Poison',
      'Psychic',
      'Fairy',
    ],
    'introduction':
        '''Breloom closes in on its foe with light and sprightly footwork, then throws punches with its stretchy arms. This Pokémon's fighting technique puts boxers to shame.''',
  },
  {
    'name': 'Bulbasaur',
    'HP': '45',
    'Attack': '49',
    'Defense': '49',
    'Speed': '45',
    'Sp Atk': '65',
    'Sp Def': '65',
    'height': '''2' 04"''',
    'weight': '15.2 lbs',
    'category': 'Seed',
    'type': [
      'Grass',
      'Poison',
    ],
    'weaknesses': [
      'Fire',
      'Flying',
      'Ice',
      'Psychic',
    ],
    'introduction':
        '''Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger.''',
  },
  {
    'name': 'Cacnea',
    'HP': '50',
    'Attack': '85',
    'Defense': '40',
    'Speed': '35',
    'Sp Atk': '85',
    'Sp Def': '40',
    'height': '''1' 04"''',
    'weight': '113.1 lbs',
    'category': 'Cactus',
    'type': [
      'Grass',
    ],
    'weaknesses': [
      'Bug',
      'Fire',
      'Flying',
      'Ice',
      'Poison',
    ],
    'introduction':
        '''Cacnea lives in arid locations such as deserts. It releases a strong aroma from its flower to attract prey. When prey comes near, this Pokémon shoots sharp thorns from its body to bring the victim down.''',
  },
  {
    'name': 'Onix',
    'HP': '35',
    'Attack': '45',
    'Defense': '160',
    'Speed': '70',
    'Sp Atk': '30',
    'Sp Def': '45',
    'height': '''28' 10"''',
    'weight': '463.0 lbs',
    'category': 'Rock Snake',
    'type': [
      'Rock',
      'Ground',
    ],
    'weaknesses': [
      'Grass',
      'Water',
      'Fighting',
      'Ground',
      'Ice',
      'Psychic',
    ],
    'introduction':
        '''Onix has a magnet in its brain. It acts as a compass so that this Pokémon does not lose direction while it is tunneling. As it grows older, its body becomes increasingly rounder and smoother.''',
  },
  {
    'name': 'Charmander',
    'HP': '39',
    'Attack': '52',
    'Defense': '43',
    'Speed': '65',
    'Sp Atk': '60',
    'Sp Def': '50',
    'height': '''2' 00"''',
    'weight': '18.7 lbs',
    'category': 'Lizard',
    'type': [
      'Fire',
    ],
    'weaknesses': [
      'Ground',
      'Rock',
      'Water',
    ],
    'introduction':
        '''The flame that burns at the tip of its tail is an indication of its emotions. The flame wavers when Charmander is enjoying itself. If the Pokémon becomes enraged, the flame burns fiercely.''',
  },
  {
    'name': 'Chikorita',
    'HP': '45',
    'Attack': '49',
    'Defense': '65',
    'Speed': '45',
    'Sp Atk': '49',
    'Sp Def': '65',
    'height': '''2' 11"''',
    'weight': '14.1 lbs',
    'category': 'Leaf',
    'type': [
      'Grass',
    ],
    'weaknesses': [
      'Bug',
      'Fire',
      'Flying',
      'Ice',
      'Poison',
    ],
    'introduction':
        '''In battle, Chikorita waves its leaf around to keep the foe at bay. However, a sweet fragrance also wafts from the leaf, becalming the battling Pokémon and creating a cozy, friendly atmosphere all around.''',
  },
  {
    'name': 'Chinchou',
    'HP': '75',
    'Attack': '38',
    'Defense': '38',
    'Speed': '67',
    'Sp Atk': '56',
    'Sp Def': '56',
    'height': '''1' 08"''',
    'weight': '26.5 lbs',
    'category': 'Angler',
    'type': [
      'Water',
      'Electric',
    ],
    'weaknesses': [
      'Grass',
      'Ground',
    ],
    'introduction':
        '''Chinchou lets loose positive and negative electrical charges from its two antennas to make its prey faint. This Pokémon flashes its electric lights to exchange signals with others.''',
  },
  {
    'name': 'Diglett',
    'HP': '10',
    'Attack': '55',
    'Defense': '25',
    'Speed': '95',
    'Sp Atk': '35',
    'Sp Def': '45',
    'height': '''0' 08"''',
    'weight': '1.8 lbs',
    'category': 'Mole',
    'type': [
      'Ground',
    ],
    'weaknesses': [
      'Grass',
      'Ice',
      'Water',
    ],
    'introduction':
        '''Diglett are raised in most farms. The reason is simple— wherever this Pokémon burrows, the soil is left perfectly tilled for planting crops. This soil is made ideal for growing delicious vegetables.''',
  },
  {
    'name': 'Ditto',
    'HP': '48',
    'Attack': '48',
    'Defense': '48',
    'Speed': '48',
    'Sp Atk': '48',
    'Sp Def': '48',
    'height': '''1' 00"''',
    'weight': '8.8 lbs',
    'category': 'Transform',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''Ditto rearranges its cell structure to transform itself into other shapes. However, if it tries to transform itself into something by relying on its memory, this Pokémon manages to get details wrong.''',
  },
  {
    'name': 'Duskull',
    'HP': '20',
    'Attack': '40',
    'Defense': '90',
    'Speed': '25',
    'Sp Atk': '30',
    'Sp Def': '90',
    'height': '''2' 07"''',
    'weight': '33.1 lbs',
    'category': 'Requiem',
    'type': [
      'Ghost',
    ],
    'weaknesses': [
      'Dark',
      'Ghost',
    ],
    'introduction':
        '''Duskull can pass through any wall no matter how thick it may be. Once this Pokémon chooses a target, it will doggedly pursue the intended victim until the break of dawn.''',
  },
  {
    'name': 'Jolteon',
    'HP': '65',
    'Attack': '65',
    'Defense': '60',
    'Speed': '130',
    'Sp Atk': '110',
    'Sp Def': '95',
    'height': '''2' 07"''',
    'weight': '54.0 lbs',
    'category': 'Lightning',
    'type': [
      'Electric',
    ],
    'weaknesses': [
      'Ground',
    ],
    'introduction':
        '''Jolteon's cells generate a low level of electricity. This power is amplified by the static electricity of its fur, enabling the Pokémon to drop thunderbolts. The bristling fur is made of electrically charged needles.''',
  },
  {
    'name': 'Exeggutor',
    'HP': '95',
    'Attack': '95',
    'Defense': '85',
    'Speed': '55',
    'Sp Atk': '125',
    'Sp Def': '75',
    'height': '''6' 07"''',
    'weight': '264.6 lbs',
    'category': 'Coconut',
    'type': [
      'Grass',
      'Psychic',
    ],
    'weaknesses': [
      'Bug',
      'Dark',
      'Fire',
      'Flying',
      'Ghost',
      'Ice',
      'Poison',
    ],
    'introduction':
        '''Exeggutor originally came from the tropics. Its heads steadily grow larger from exposure to strong sunlight. It is said that when the heads fall off, they group together to form Exeggcute.''',
  },
  {
    'name': 'Gastly',
    'HP': '30',
    'Attack': '35',
    'Defense': '30',
    'Speed': '80',
    'Sp Atk': '100',
    'Sp Def': '35',
    'height': '''4' 03"''',
    'weight': '0.2 lbs',
    'category': 'Gas',
    'type': [
      'Ghost',
      'Poison',
    ],
    'weaknesses': [
      'Dark',
      'Ghost',
      'Psychic',
    ],
    'introduction':
        '''Gastly is largely composed of gaseous matter. When exposed to a strong wind, the gaseous body quickly dwindles away. Groups of this Pokémon cluster under the eaves of houses to escape the ravages of wind.''',
  },
  {
    'name': 'Gloom',
    'HP': '60',
    'Attack': '65',
    'Defense': '70',
    'Speed': '40',
    'Sp Atk': '85',
    'Sp Def': '75',
    'height': '''2' 07"''',
    'weight': '19.0 lbs',
    'category': 'Weed',
    'type': [
      'Poison',
      'Grass',
    ],
    'weaknesses': [
      'Fire',
      'Flying',
      'Ice',
      'Psychic',
    ],
    'introduction':
        '''Gloom releases a foul fragrance from the pistil of its flower. When faced with danger, the stench worsens. If this Pokémon is feeling calm and secure, it does not release its usual stinky aroma.''',
  },
  {
    'name': 'Gulpin',
    'HP': '70',
    'Attack': '43',
    'Defense': '53',
    'Speed': '40',
    'Sp Atk': '43',
    'Sp Def': '53',
    'height': '''1' 04"''',
    'weight': '22.7 lbs',
    'category': 'Stomach',
    'type': [
      'Poison',
    ],
    'weaknesses': [
      'Ground',
      'Psychic',
    ],
    'introduction':
        '''Virtually all of Gulpin's body is its stomach. As a result, it can swallow something its own size. This Pokémon's stomach contains a special fluid that digests anything.''',
  },
  {
    'name': 'Hoothoot',
    'HP': '60',
    'Attack': '30',
    'Defense': '30',
    'Speed': '50',
    'Sp Atk': '36',
    'Sp Def': '56',
    'height': '''2' 04"''',
    'weight': '46.7 lbs',
    'category': 'Owl',
    'type': [
      'Flying',
      'Normal',
    ],
    'weaknesses': [
      'Electric',
      'Ice',
      'Rock',
    ],
    'introduction':
        '''Hoothoot has an internal organ that senses and tracks the earth's rotation. Using this special organ, this Pokémon begins hooting at precisely the same time every day.''',
  },
  {
    'name': 'Hoppip',
    'HP': '35',
    'Attack': '35',
    'Defense': '40',
    'Speed': '50',
    'Sp Atk': '35',
    'Sp Def': '55',
    'height': '''1' 04"''',
    'weight': '1.1 lbs',
    'category': 'Cottonweed',
    'type': [
      'Grass',
      'Flying',
    ],
    'weaknesses': [
      'Ice',
      'Fire',
      'Flying',
      'Poison',
      'Rock',
    ],
    'introduction':
        '''This Pokémon drifts and floats with the wind. If it senses the approach of strong winds, Hoppip links its leaves with other Hoppip to prepare against being blown away.''',
  },
  {
    'name': 'Jigglypuff',
    'HP': '115',
    'Attack': '45',
    'Defense': '20',
    'Speed': '20',
    'Sp Atk': '45',
    'Sp Def': '25',
    'height': '''1' 08"''',
    'weight': '12.1 lbs',
    'category': 'Balloon',
    'type': [
      'Fairy',
      'Normal',
    ],
    'weaknesses': [
      'Steel',
      'Poison',
    ],
    'introduction':
        '''Jigglypuff's vocal cords can freely adjust the wavelength of its voice. This Pokémon uses this ability to sing at precisely the right wavelength to make its foes most drowsy.''',
  },
  {
    'name': 'Ledyba',
    'HP': '40',
    'Attack': '20',
    'Defense': '30',
    'Speed': '55',
    'Sp Atk': '40',
    'Sp Def': '80',
    'height': '''3' 03"''',
    'weight': '23.8 lbs',
    'category': 'Five Star',
    'type': [
      'Bug',
      'Flying',
    ],
    'weaknesses': [
      'Rock',
      'Electric',
      'Fire',
      'Flying',
      'Ice',
    ],
    'introduction':
        '''Ledyba secretes an aromatic fluid from where its legs join its body. This fluid is used for communicating with others. This Pokémon conveys its feelings to others by altering the fluid's scent.''',
  },
  {
    'name': 'Magnemite',
    'HP': '25',
    'Attack': '35',
    'Defense': '70',
    'Speed': '45',
    'Sp Atk': '95',
    'Sp Def': '55',
    'height': '''1' 00"''',
    'weight': '13.2 lbs',
    'category': 'Magnet',
    'type': [
      'Electric',
      'Steel',
    ],
    'weaknesses': [
      'Ground',
      'Fire',
      'Fighting',
    ],
    'introduction':
        '''Magnemite attaches itself to power lines to feed on electricity. If your house has a power outage, check your circuit breakers. You may find a large number of this Pokémon clinging to the breaker box.''',
  },
  {
    'name': 'Marill',
    'HP': '70',
    'Attack': '20',
    'Defense': '50',
    'Speed': '40',
    'Sp Atk': '20',
    'Sp Def': '50',
    'height': '''1' 04"''',
    'weight': '18.7 lbs',
    'category': 'Aqua Mouse',
    'type': [
      'Water',
      'Fairy',
    ],
    'weaknesses': [
      'Electric',
      'Grass',
      'Poison',
    ],
    'introduction':
        '''Marill's oil-filled tail acts much like a life preserver. If you see just its tail bobbing on the water's surface, it's a sure indication that this Pokémon is diving beneath the water to feed on aquatic plants.''',
  },
  {
    'name': 'Masquerain',
    'HP': '70',
    'Attack': '60',
    'Defense': '62',
    'Speed': '80',
    'Sp Atk': '100',
    'Sp Def': '82',
    'height': '''2' 07"''',
    'weight': '7.9 lbs',
    'category': 'Eyeball',
    'type': [
      'Bug',
      'Flying',
    ],
    'weaknesses': [
      'Rock',
      'Electric',
      'Fire',
      'Flying',
      'Ice',
    ],
    'introduction':
        '''Masquerain intimidates enemies with the eyelike patterns on its antennas. This Pokémon flaps its four wings to freely fly in any direction—even sideways and backwards—as if it were a helicopter.''',
  },
  {
    'name': 'Meowth',
    'HP': '40',
    'Attack': '45',
    'Defense': '35',
    'Speed': '90',
    'Sp Atk': '40',
    'Sp Def': '40',
    'height': '''1' 04"''',
    'weight': '9.3 lbs',
    'category': 'Scratch Cat',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''Meowth withdraws its sharp claws into its paws to slinkily sneak about without making any incriminating footsteps. For some reason, this Pokémon loves shiny coins that glitter with light.''',
  },
  {
    'name': 'Rattata',
    'HP': '30',
    'Attack': '56',
    'Defense': '35',
    'Speed': '72',
    'Sp Atk': '25',
    'Sp Def': '35',
    'height': '''1' 00"''',
    'weight': '7.7 lbs',
    'category': 'Mouse',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''Rattata is cautious in the extreme. Even while it is asleep, it constantly listens by moving its ears around. It is not picky about where it lives—it will make its nest anywhere.''',
  },
  {
    'name': 'Numel',
    'HP': '60',
    'Attack': '60',
    'Defense': '40',
    'Speed': '35',
    'Sp Atk': '65',
    'Sp Def': '45',
    'height': '''2' 04"''',
    'weight': '52.9 lbs',
    'category': 'Numb',
    'type': [
      'Fire',
      'Ground',
    ],
    'weaknesses': [
      'Water',
      'Ground',
    ],
    'introduction':
        '''Numel is extremely dull witted—it doesn't notice being hit. However, it can't stand hunger for even a second. This Pokémon's body is a seething cauldron of boiling magma.''',
  },
  {
    'name': 'Oddish',
    'HP': '45',
    'Attack': '50',
    'Defense': '55',
    'Speed': '30',
    'Sp Atk': '75',
    'Sp Def': '65',
    'height': '''1' 08"''',
    'weight': '11.9 lbs',
    'category': 'Weed',
    'type': [
      'Poison',
      'Grass',
    ],
    'weaknesses': [
      'Fire',
      'Flying',
      'Ice',
      'Psychic',
    ],
    'introduction':
        '''During the daytime, Oddish buries itself in soil to absorb nutrients from the ground using its entire body. The more fertile the soil, the glossier its leaves become.''',
  },
  {
    'name': 'Omanyte',
    'HP': '35',
    'Attack': '40',
    'Defense': '100',
    'Speed': '35',
    'Sp Atk': '90',
    'Sp Def': '55',
    'height': '''1' 04"''',
    'weight': '16.5 lbs',
    'category': 'Spiral',
    'type': [
      'Rock',
      'Water',
    ],
    'weaknesses': [
      'Grass',
      'Electric',
      'Fighting',
      'Ground',
    ],
    'introduction':
        '''Omanyte is one of the ancient and long-since-extinct Pokémon that have been regenerated from fossils by people. If attacked by an enemy, it withdraws itself inside its hard shell.''',
  },
  {
    'name': 'Phanpy',
    'HP': '90',
    'Attack': '60',
    'Defense': '60',
    'Speed': '40',
    'Sp Atk': '40',
    'Sp Def': '40',
    'height': '''1' 08"''',
    'weight': '73.9 lbs',
    'category': 'Long Nose',
    'type': [
      'Ground',
    ],
    'weaknesses': [
      'Grass',
      'Ice',
      'Water',
    ],
    'introduction':
        '''For its nest, Phanpy digs a vertical pit in the ground at the edge of a river. It marks the area around its nest with its trunk to let the others know that the area has been claimed.''',
  },
  {
    'name': 'Pikachu',
    'HP': '35',
    'Attack': '55',
    'Defense': '40',
    'Speed': '90',
    'Sp Atk': '50',
    'Sp Def': '50',
    'height': '''1' 04"''',
    'weight': '13.2 lbs',
    'category': 'Mouse',
    'type': [
      'Electric',
    ],
    'weaknesses': [
      'Ground',
    ],
    'introduction':
        '''Whenever Pikachu comes across something new, it blasts it with a jolt of electricity. If you come across a blackened berry, it's evidence that this Pokémon mistook the intensity of its charge.''',
  },
  {
    'name': 'Poliwhirl',
    'HP': '65',
    'Attack': '65',
    'Defense': '65',
    'Speed': '90',
    'Sp Atk': '50',
    'Sp Def': '50',
    'height': '''3' 03"''',
    'weight': '44.1 lbs',
    'category': 'Tadpole',
    'type': [
      'Water',
    ],
    'weaknesses': [
      'Electric',
      'Grass',
    ],
    'introduction':
        '''The surface of Poliwhirl's body is always wet and slick with a slimy fluid. Because of this slippery covering, it can easily slip and slide out of the clutches of any enemy in battle.''',
  },
  {
    'name': 'Psyduck',
    'HP': '50',
    'Attack': '52',
    'Defense': '48',
    'Speed': '55',
    'Sp Atk': '65',
    'Sp Def': '50',
    'height': '''2' 07"''',
    'weight': '43.2 lbs',
    'category': 'Duck',
    'type': [
      'Water',
    ],
    'weaknesses': [
      'Electric',
      'Grass',
    ],
    'introduction':
        '''Psyduck uses a mysterious power. When it does so, this Pokémon generates brain waves that are supposedly only seen in sleepers. This discovery spurred controversy among scholars.''',
  },
  {
    'name': 'Roselia',
    'HP': '50',
    'Attack': '60',
    'Defense': '45',
    'Speed': '65',
    'Sp Atk': '100',
    'Sp Def': '80',
    'height': '''1' 00"''',
    'weight': '4.4 lbs',
    'category': 'Thorn',
    'type': [
      'Grass',
      'Poison',
    ],
    'weaknesses': [
      'Fire',
      'Flying',
      'Ice',
      'Psychic',
    ],
    'introduction':
        '''Roselia shoots sharp thorns as projectiles at any opponent that tries to steal the flowers on its arms. The aroma of this Pokémon brings serenity to living things.''',
  },
  {
    'name': 'Sandshrew',
    'HP': '50',
    'Attack': '75',
    'Defense': '85',
    'Speed': '40',
    'Sp Atk': '20',
    'Sp Def': '30',
    'height': '''2' 00"''',
    'weight': '26.5 lbs',
    'category': 'Mouse',
    'type': [
      'Ground',
    ],
    'weaknesses': [
      'Grass',
      'Ice',
      'Water',
    ],
    'introduction':
        '''Sandshrew's body is configured to absorb water without waste, enabling it to survive in an arid desert. This Pokémon curls up to protect itself from its enemies.''',
  },
  {
    'name': 'Seedot',
    'HP': '40',
    'Attack': '40',
    'Defense': '50',
    'Speed': '30',
    'Sp Atk': '30',
    'Sp Def': '30',
    'height': '''1' 08"''',
    'weight': '8.8 lbs',
    'category': 'Acorn',
    'type': [
      'Grass',
    ],
    'weaknesses': [
      'Bug',
      'Fire',
      'Flying',
      'Ice',
      'Poison',
    ],
    'introduction':
        '''Seedot attaches itself to a tree branch using the top of its head. It sucks moisture from the tree while hanging off the branch. The more water it drinks, the glossier this Pokémon's body becomes.''',
  },
  {
    'name': 'Sentret',
    'HP': '35',
    'Attack': '46',
    'Defense': '34',
    'Speed': '20',
    'Sp Atk': '35',
    'Sp Def': '45',
    'height': '''2' 07"''',
    'weight': '13.2 lbs',
    'category': 'Scout',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''When Sentret sleeps, it does so while another stands guard. The sentry wakes the others at the first sign of danger. When this Pokémon becomes separated from its pack, it becomes incapable of sleep due to fear.''',
  },
  {
    'name': 'Snorlax',
    'HP': '160',
    'Attack': '110',
    'Defense': '65',
    'Speed': '30',
    'Sp Atk': '65',
    'Sp Def': '110',
    'height': '''6' 11"''',
    'weight': '1014.1 lbs',
    'category': 'Sleeping',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''Snorlax's typical day consists of nothing more than eating and sleeping. It is such a docile Pokémon that there are children who use its expansive belly as a place to play.''',
  },
  {
    'name': 'Spheal',
    'HP': '70',
    'Attack': '40',
    'Defense': '50',
    'Speed': '25',
    'Sp Atk': '55',
    'Sp Def': '50',
    'height': '''2' 07"''',
    'weight': '87.1 lbs',
    'category': 'Clap',
    'type': [
      'Ice',
      'Water',
    ],
    'weaknesses': [
      'Electric',
      'Fighting',
      'Grass',
      'Rock',
    ],
    'introduction':
        '''Spheal is much faster rolling than walking to get around. When groups of this Pokémon eat, they all clap at once to show their pleasure. Because of this, their mealtimes are noisy.''',
  },
  {
    'name': 'Staryu',
    'HP': '30',
    'Attack': '45',
    'Defense': '55',
    'Speed': '85',
    'Sp Atk': '70',
    'Sp Def': '55',
    'height': '''2' 07"''',
    'weight': '76.1 lbs',
    'category': 'Star Shape',
    'type': [
      'Water',
    ],
    'weaknesses': [
      'Electric',
      'Grass',
    ],
    'introduction':
        '''Staryu's center section has an organ called the core that shines bright red. If you go to a beach toward the end of summer, the glowing cores of these Pokémon look like the stars in the sky.''',
  },
  {
    'name': 'Sudowoodo',
    'HP': '70',
    'Attack': '100',
    'Defense': '115',
    'Speed': '30',
    'Sp Atk': '65',
    'Sp Def': '30',
    'height': '''3' 11"''',
    'weight': '83.8 lbs',
    'category': 'Imitation',
    'type': [
      'Rock',
    ],
    'weaknesses': [
      'Fighting',
      'Grass',
      'Ground',
      'Steel',
      'Water',
    ],
    'introduction':
        '''Sudowoodo camouflages itself as a tree to avoid being attacked by enemies. However, because its hands remain green throughout the year, the Pokémon is easily identified as a fake during the winter.''',
  },
  {
    'name': 'Sunkern',
    'HP': '30',
    'Attack': '30',
    'Defense': '30',
    'Speed': '30',
    'Sp Atk': '30',
    'Sp Def': '30',
    'height': '''1' 00"''',
    'weight': '4.0 lbs',
    'category': 'Seed',
    'type': [
      'Grass',
    ],
    'weaknesses': [
      'Bug',
      'Fire',
      'Flying',
      'Ice',
      'Poison',
    ],
    'introduction':
        '''Sunkern tries to move as little as it possibly can. It does so because it tries to conserve all the nutrients it has stored in its body for its evolution. It will not eat a thing, subsisting only on morning dew.''',
  },
  {
    'name': 'Swablu',
    'HP': '45',
    'Attack': '40',
    'Defense': '60',
    'Speed': '50',
    'Sp Atk': '40',
    'Sp Def': '75',
    'height': '''1' 04"''',
    'weight': '2.6 lbs',
    'category': 'Cotton Bird',
    'type': [
      'Flying',
      'Normal',
    ],
    'weaknesses': [
      'Electric',
      'Ice',
      'Rock',
    ],
    'introduction':
        '''Swablu has light and fluffy wings that are like cottony clouds. This Pokémon is not frightened of people. It lands on the heads of people and sits there like a cotton-fluff hat.''',
  },
  {
    'name': 'Swinub',
    'HP': '50',
    'Attack': '50',
    'Defense': '40',
    'Speed': '50',
    'Sp Atk': '30',
    'Sp Def': '30',
    'height': '''1' 04"''',
    'weight': '14.3 lbs',
    'category': 'Pig',
    'type': [
      'Ice',
      'Ground',
    ],
    'weaknesses': [
      'Fighting',
      'Fire',
      'Grass',
      'Steel',
      'Water',
    ],
    'introduction':
        '''Swinub roots for food by rubbing its snout against the ground. Its favorite food is a mushroom that grows under the cover of dead grass. This Pokémon occasionally roots out hot springs.''',
  },
  {
    'name': 'Teddiursa',
    'HP': '60',
    'Attack': '80',
    'Defense': '50',
    'Speed': '40',
    'Sp Atk': '50',
    'Sp Def': '50',
    'height': '''2' 00"''',
    'weight': '19.4 lbs',
    'category': 'Little Bear',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''This Pokémon likes to lick its palms that are sweetened by being soaked in honey. Teddiursa concocts its own honey by blending fruits and pollen collected by Beedrill.''',
  },
  {
    'name': 'Voltorb',
    'HP': '40',
    'Attack': '30',
    'Defense': '50',
    'Speed': '100',
    'Sp Atk': '55',
    'Sp Def': '55',
    'height': '''1' 08"''',
    'weight': '22.9 lbs',
    'category': 'Ball',
    'type': [
      'Electric',
    ],
    'weaknesses': [
      'Ground',
    ],
    'introduction':
        '''Voltorb was first sighted at a company that manufactures Poké Balls. The link between that sighting and the fact that this Pokémon looks very similar to a Poké Ball remains a mystery.''',
  },
  {
    'name': 'Wailmer',
    'HP': '130',
    'Attack': '70',
    'Defense': '35',
    'Speed': '60',
    'Sp Atk': '70',
    'Sp Def': '35',
    'height': '''6' 07"''',
    'weight': '286.6 lbs',
    'category': 'Ball Whale',
    'type': [
      'Water',
    ],
    'weaknesses': [
      'Electric',
      'Grass',
    ],
    'introduction':
        '''Wailmer's nostrils are located above its eyes. This playful Pokémon loves to startle people by forcefully snorting out seawater it stores inside its body out of its nostrils.''',
  },
  {
    'name': 'Whismur',
    'HP': '64',
    'Attack': '51',
    'Defense': '23',
    'Speed': '28',
    'Sp Atk': '51',
    'Sp Def': '23',
    'height': '''2' 00"''',
    'weight': '35.9 lbs',
    'category': 'Whisper',
    'type': [
      'Normal',
    ],
    'weaknesses': [
      'Fighting',
    ],
    'introduction':
        '''Normally, Whismur's voice is very quiet—it is barely audible even if one is paying close attention. However, if this Pokémon senses danger, it starts crying at an earsplitting volume.''',
  },
  {
    'name': 'Wingull',
    'HP': '40',
    'Attack': '30',
    'Defense': '30',
    'Speed': '85',
    'Sp Atk': '55',
    'Sp Def': '30',
    'height': '''2' 00"''',
    'weight': '15.2 lbs',
    'category': 'Seed',
    'type': [
      'Water',
      'Flying',
    ],
    'weaknesses': [
      'Electric',
      'Rock',
    ],
    'introduction':
        '''Wingull has the habit of carrying prey and valuables in its beak and hiding them in all sorts of locations. This Pokémon rides the winds and flies as if it were skating across the sky.''',
  },
  {
    'name': 'Yanma',
    'HP': '65',
    'Attack': '65',
    'Defense': '45',
    'Speed': '95',
    'Sp Atk': '75',
    'Sp Def': '45',
    'height': '''3' 11"''',
    'weight': '83.8 lbs',
    'category': 'Clear Wing',
    'type': [
      'Bug',
      'Flying',
    ],
    'weaknesses': [
      'Rock',
      'Electric',
      'Fire',
      'Flying',
      'Ice',
    ],
    'introduction':
        '''Yanma is capable of seeing 360 degrees without having to move its eyes. It is a great flier that is adept at making sudden stops and turning midair. This Pokémon uses its flying ability to quickly chase down targeted prey.''',
  },
];
