import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/constant.dart';
import 'package:note/models/Note.dart';
import 'package:note/pages/DetailPage.dart';
import 'package:note/provider/NotesProvider.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CardNote extends StatelessWidget {
  CardNote({super.key, required this.note, required this.isSelected});

  Note note;
  bool isSelected;
  @override
  Widget build(BuildContext context) {
    List<Note> notesSelected = context.read<NotesProvide>().notesSelected;
    return GestureDetector(
      onLongPress: () => context.read<NotesProvide>().addNoteSelected(note),
      onTap: () {
        if (notesSelected.isEmpty) {
          context.read<NotesProvide>().setNoteSelected(note);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage()));
          return;
        }

        if (isSelected) {
          context.read<NotesProvide>().removeNoteSelected(note);
        } else {
          context.read<NotesProvide>().addNoteSelected(note);
        }
      },
      child: Card(
        color: isSelected
            ? Colors.grey
            : context.read<NotesProvide>().notesSelected.isNotEmpty
                ? colores[note.color].withOpacity(.30)
                : colores[note.color],
        child: Container(
            padding: const EdgeInsets.all(7),
            child: LayoutBuilder(
              builder: (context, constaint) {
                return Column(
                  children: [
                    SizedBox(
                      width: constaint.maxWidth,
                      height: constaint.maxHeight * .8,
                      child: Text(
                        note.content,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Expanded(
                      child: SizedBox(
                        width: constaint.maxWidth,
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(note.date).toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
