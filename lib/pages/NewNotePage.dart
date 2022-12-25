import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:note/components/ButtonIcon.dart';
import 'package:note/constant.dart';
import 'package:note/models/Note.dart';
import 'package:note/provider/NotesProvider.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../utils/Debouncer.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  Debouncer debouncer = Debouncer(milliseconds: 300);
  final _formKey = GlobalKey<FormState>();
  
  Note note = Note(
    color: Random().nextInt(colores.length),
    content: "",
    title: "",
    date: DateTime.now(),
  );

  bool shosButtonSave = false;

  onChangeHandler() {
    debouncer.run(() {
      if (_formKey.currentState!.validate()) {
        setState(() => shosButtonSave = true);
      } else {
        setState(() => shosButtonSave = false);
      }
    });
  }

  @override
  void dispose() {
    debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: 100.w,
            height: 100.h,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const NewNoteHeader(),
                Expanded(
                  child: SizedBox(
                    width: 100.w,
                    child: Column(children: [
                      Form(
                        onChanged: onChangeHandler,
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Expanded(
                          child: SizedBox(
                            width: 100.w,
                            child: Column(
                              children: [
                                TextFormField(
                                  onSaved: (value) => note.title = value ?? "",
                                  style: TextStyle(
                                    color: const Color(0XFFEEEEEE),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Note title',
                                    hintStyle: TextStyle(
                                      color: const Color(0XFFEEEEEE),
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return "";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  width: 100.w,
                                  height: 20,
                                  child: Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(note.date)
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: 100.w,
                                    child: TextFormField(
                                      onSaved: (value) => note.content = value ?? "",
                                      style: TextStyle(
                                        color: const Color(0XFFEEEEEE),
                                        fontSize: 20.sp,
                                      ),
                                      minLines: null,
                                      maxLines: null,
                                      expands: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Note content',
                                        hintStyle: TextStyle(
                                          color: const Color(0XFFEEEEEE),
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: shosButtonSave
            ? FloatingActionButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    context.read<NotesProvide>().addNote(note);
                    _formKey.currentState!.reset();
                    Navigator.pop(context);
                  }
                },
                backgroundColor: const Color(0XFF191919),
                child: Icon(
                  Icons.save,
                  size: 30.sp,
                  color: const Color(0XFFEEEEEE),
                ),
              )
            : null);
  }
}

class NewNoteHeader extends StatelessWidget {
  const NewNoteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ButtonIcon(
                  onTap: () => Navigator.pop(context),
                  icon: Iconsax.arrow_left),
              const SizedBox(
                width: 10,
              ),
              Text(
                "New Note",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: const Color(0XFFEEEEEE),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
