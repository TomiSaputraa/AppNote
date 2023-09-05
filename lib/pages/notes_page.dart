import 'package:flutter/material.dart';
import 'package:note_app/db/notes_db.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/pages/edit_note.dart';

import '../model/note_model.dart';
import '../widget/noteCard_widget.dart';
import 'note_detail.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController textController = TextEditingController();
  List<Note> _result = [];
  late List<Note> notes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.notes = await NoteDatabase.instance.readAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  void _serchData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          AnimSearchBar(
            color: Colors.amber,
            textFieldColor: Colors.grey,
            autoFocus: true,
            width: MediaQuery.of(context).size.width * 0.7,
            textController: textController,
            onSuffixTap: () {
              setState(() {
                textController.clear();
              });
            },
            onSubmitted: (String) {},
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    'No notes',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),

      // Add note button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );
          refreshNote();
        },
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ),
              );
              refreshNote();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
