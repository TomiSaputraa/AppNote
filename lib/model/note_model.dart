// nama table database
const String tableNotes = 'notes';

// kolom database
class NoteField {
  static final List<String> values = [
    /// menambahkan semua field
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

// note model
class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteField.id] as int?,
        isImportant: json[NoteField.isImportant] == 1,
        number: json[NoteField.number] as int,
        title: json[NoteField.title] as String,
        description: json[NoteField.description] as String,
        createdTime: DateTime.parse(json[NoteField.time] as String),
      );

  Map<String, Object?> toJson() => {
        NoteField.id: id,
        NoteField.title: title,
        NoteField.isImportant: isImportant ? 1 : 0, // 1 : benar, 0 : salah
        NoteField.number: number,
        NoteField.description: description,
        NoteField.time: createdTime.toIso8601String()
      };
}
