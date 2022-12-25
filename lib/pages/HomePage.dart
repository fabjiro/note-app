import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:note/DataBase.dart';
import 'package:note/components/ButtonIcon.dart';
import 'package:note/components/CardNote.dart';
import 'package:note/models/Note.dart';
import 'package:note/provider/NotesProvider.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    BaseData().closeBaseData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes = context.watch<NotesProvide>().notes;
    List<Note> notesSelected = context.watch<NotesProvide>().notesSelected;
  
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: 100.w,
            height: 100.h,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                HeaderHome(),
                Expanded(
                  child: SizedBox(
                    width: 100.w,
                    child: notes.isNotEmpty
                        ? GridView.count(
                            crossAxisCount: 2,
                            physics: const BouncingScrollPhysics(),
                            children: notes.map((e) {
                              return Hero(
                                tag: e,
                                child: CardNote(
                                  note: e,
                                  isSelected: notesSelected.contains(e),
                                ),
                              );
                            }).toList(),
                          )
                        : Center(
                            child: Lottie.asset('assets/lottie/Comp1.json'),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: notesSelected.isEmpty
            ? FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, 'newnote'),
                backgroundColor: const Color(0XFF191919),
                child: Icon(
                  Iconsax.add,
                  size: 30.sp,
                  color: const Color(0XFFEEEEEE),
                ),
              )
            : null);
  }
}

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    List<Note> notesSelected = context.watch<NotesProvide>().notesSelected;
    return SizedBox(
      width: 100.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Note App",
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0XFFEEEEEE),
              fontWeight: FontWeight.bold,
            ),
          ),
          ButtonActionHeader(
            isDeletedMode: notesSelected.isNotEmpty,
          )
        ],
      ),
    );
  }
}

class ButtonActionHeader extends StatelessWidget {
  const ButtonActionHeader({super.key, required this.isDeletedMode});

  final bool isDeletedMode;

  @override
  Widget build(BuildContext context) {
    if (isDeletedMode) {
      return ButtonIcon(
        onTap: () => context.read<NotesProvide>().deleteNoteSelected(),
        icon: Icons.delete,
      );
    }

    return ButtonIcon(
      onTap: () => {},
      icon: Icons.search,
    );
  }
}
