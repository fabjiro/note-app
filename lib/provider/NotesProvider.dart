import 'package:flutter/cupertino.dart';
import 'package:note/DataBase.dart';
import 'package:note/models/Note.dart';

class NotesProvide with ChangeNotifier {
  // ignore: unused_field
  final List<Note> _notes = [];
  final List<Note> _notesSelected = [];
  late  Note _noteSelected;
  bool _isTyping = false;

  List<Note> get notes => _notes;
  List<Note> get notesSelected => _notesSelected;
  Note get noteSelected => _noteSelected;
  bool get isTyping => _isTyping;

  void setIsTyping(bool value){
    _isTyping =  value;
    notifyListeners();
  }

  void setNoteSelected(Note note){
    _noteSelected = note;
    notifyListeners();
  }  

  void addNoteSelected(Note note) {
    _notesSelected.add(note);
    notifyListeners();
  }

  void removeNoteSelected(Note note) {
    int item = _notesSelected.indexWhere((element) => element.id == note.id);
    if (item >= 0) {
      _notesSelected.removeAt(item);
      notifyListeners();
    }
  }

  void deleteNoteSelected() {
    if (_notesSelected.isNotEmpty) {
      for (Note item in _notesSelected) {
        _notes.remove(item);
        BaseData().deleteNote(item.id!);
      }
      _notesSelected.clear();
      notifyListeners();
    }
  }

  void addNote(Note note) async {
    _notes.add(note);
    Note newNote = await BaseData().inerstNote(note);
    _notes.last = newNote;
    notifyListeners();
  }

  void editNote(Note note) async {
    int index = _notesSelected.indexWhere((element) => element.id == note.id);
    if(index >= 0){
      _notes[index] = note;
    }
    await BaseData().editNote(note);
    notifyListeners();
  }

  NotesProvide() {
    BaseData().getNotes().then((value) {
      _notes.addAll(value);
      notifyListeners();
    });
  }
}
