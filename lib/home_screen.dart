import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() async {
    final data = await _dbHelper.allNotes();
    setState(() {
      _notes = data;
    });
  }

  void _deleteNote(int id) async {
    await _dbHelper.delete(id);
    _refreshNotes();
  }

  void _showNoteScreen([Map<String, dynamic>? note]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteScreen(note: note),
      ),
    );
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
          'Notes App',
        ),
        centerTitle: true,
      ),
      body: _notes.isEmpty
          ? Center(child: Text('No Notes'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index]['title']),
                  subtitle: Text(_notes[index]['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showNoteScreen(_notes[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(_notes[index]['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        onPressed: () => _showNoteScreen(),
        child: Icon(Icons.add),
      ),
    );
  }
}
