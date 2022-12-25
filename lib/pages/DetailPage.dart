import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:note/components/ButtonIcon.dart';
import 'package:note/constant.dart';
import 'package:note/models/Note.dart';
import 'package:note/provider/NotesProvider.dart';
import 'package:note/utils/Debouncer.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Debouncer debouncer = Debouncer(milliseconds: 1000);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    debouncer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvide>(context);
    Note editNote = provider.noteSelected;
    editNote.date = DateTime.now();

    return Hero(
      tag: provider.noteSelected,
      child: Scaffold(
        backgroundColor: colores[provider.noteSelected.color],
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: 100.w,
                height: 100.h,
                child: Column(
                  children: [
                    EditNoteHeader(),
                    Expanded(
                      child: SizedBox(
                        width: 100.w,
                        child: Column(children: [
                          Form(
                            key: _formKey,
                            onChanged: () {
                              if (!provider.isTyping) provider.setIsTyping(true);
                              debouncer.run(() {
                                if (_formKey.currentState!.validate()) {
                                  provider.setIsTyping(false);
                                  _formKey.currentState!.save();
                                  provider.editNote(editNote);
                                }
                              });
                            },
                            child: Expanded(
                              child: SizedBox(
                                width: 100.w,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      initialValue: provider.noteSelected.title,
                                      onEditingComplete: () {},
                                      onSaved: (value) =>
                                          editNote.title = value ?? "",
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
                                        if (value == null || value.isEmpty) {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 100.w,
                                        child: TextFormField(
                                          onEditingComplete: () {},
                                          initialValue:
                                              provider.noteSelected.content,
                                          onSaved: (value) =>
                                              editNote.content = value ?? "",
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "";
                                            }
                                            return null;
                                          },
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
                    ),
                  ],
                ),
              ),
              SlidingUpPanel(
                boxShadow: const <BoxShadow>[
                  BoxShadow(blurRadius: 5.0, color: Color.fromRGBO(0, 0, 0, 0.35))
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                color: colores[provider.noteSelected.color].withAlpha(240),
                panel: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    children: [
                      SizedBox(
                        width: constraint.maxWidth,
                        height: constraint.maxHeight * .37,
                        child: Row(children: [
                          Text(
                            "Ultima modificacion: ${DateFormat('dd/MM/yyyy').format(provider.noteSelected.date).toString()}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.sp),
                          ),
                        ]),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: constraint.maxWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: colores
                                .map((e) => OptionColor(
                                    color: e,
                                    onTap: () {
                                      editNote.color = colores.indexOf(e);
                                      provider.editNote(editNote);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  );
                }),
                padding: EdgeInsets.all(10),
                maxHeight: 15.h,
                minHeight: 8.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OptionColor extends StatelessWidget {
  const OptionColor({super.key, required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black.withOpacity(.6), width: 1)),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}

class EditNoteHeader extends StatelessWidget {
  const EditNoteHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonIcon(
            onTap: () => Navigator.pop(context),
            icon: Iconsax.arrow_left,
            color: colores[context.watch<NotesProvide>().noteSelected.color],
          ),
          context.watch<NotesProvide>().isTyping
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
