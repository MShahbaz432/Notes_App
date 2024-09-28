import 'package:flutter/material.dart';
import 'db_helper.dart';

class NoteScreen extends StatefulWidget {
  final Map<String, dynamic>? note;
  const NoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _descriptionController.text = widget.note!['description'];
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> note = {
        'title': _titleController.text,
        'description': _descriptionController.text,
      };

      if (widget.note == null) {
        await _dbHelper.insert(note);
      } else {
        note['id'] = widget.note!['id'];
        await _dbHelper.update(note);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    label: Text('Title'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter title' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  maxLines: null,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    label: Text('Description'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter description' : null,
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        onPressed: () {
                          _saveNote();
                        },
                        child: Text(widget.note == null ? 'Add' : 'Update'),
                      ),
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
