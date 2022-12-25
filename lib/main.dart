import 'package:flutter/material.dart';
import 'package:note/DataBase.dart';
import 'package:note/config.dart';
import 'package:note/pages/DetailPage.dart';
import 'package:note/pages/HomePage.dart';
import 'package:note/pages/NewNotePage.dart';
import 'package:note/provider/NotesProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialConfig();

  await BaseData().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvide()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, devices) {
        return MaterialApp(
          title: 'Note app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0X00181D31),
          ),
          initialRoute: 'home',
          routes: {
            'home': (_) =>  HomePage(),
            'newnote': (_) =>  NewNotePage(),
            'detailnote': (_) => DetailPage(),
          },
        );
      },
    );
  }
}
