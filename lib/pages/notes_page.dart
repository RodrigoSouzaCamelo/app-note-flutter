import 'package:app_note_flutter/data/notes_database.dart';
import 'package:app_note_flutter/models/note.dart';
import 'package:app_note_flutter/pages/add_edit_note_page.dart';
import 'package:app_note_flutter/widgets/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  Widget buildNotes() => MasonryGridView.count(
    padding: const EdgeInsets.all(8),
    itemCount: notes.length,
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () async {

        },
        child: NoteCardWidget(note: note, index: index),
      );
    },
  );

  Widget buildBodyPage() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (notes.isEmpty) {
      return const Text(
        'No Notes',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      );
    }

    return buildNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: buildBodyPage(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage())
          );

          refreshNotes();
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
