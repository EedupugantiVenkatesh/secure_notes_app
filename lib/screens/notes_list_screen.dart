import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/notes_provider.dart';
import '../models/note.dart';
import '../constants/app_constants.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  void initState() {
    super.initState();
    // Load notes when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotesProvider>().loadNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.myNotesLabel),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<NotesProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<NotesProvider>().toggleDarkMode();
            },
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final notes = notesProvider.notes;
          
          if (notes.isEmpty) {
            return const Center(
              child: Text(AppConstants.emptyNotesMessage),
            );
          }

          return RefreshIndicator(
            onRefresh: () => notesProvider.loadNotes(),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => _editNote(context, note),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: AppConstants.editAction,
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.contentPadding),
                      ),
                      SlidableAction(
                        onPressed: (context) => _deleteNote(context, note),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: AppConstants.deleteAction,
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.contentPadding),
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.cardHorizontalMargin,
                      vertical: AppConstants.cardVerticalMargin,
                    ),
                    elevation: AppConstants.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppConstants.contentPadding),
                      title: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstants.titleFontSize,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppConstants.spacingSmall),
                          Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: AppConstants.contentFontSize,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingSmall),
                          Text(
                            '${AppConstants.lastUpdatedLabel} ${note.formattedUpdatedAt}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _editNote(context, note),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editNote(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editNote(BuildContext context, Note? note) async {
    if (!mounted) return;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(note: note),
      ),
    );
    
    if (mounted) {
      context.read<NotesProvider>().loadNotes();
    }
  }

  Future<void> _deleteNote(BuildContext context, Note note) async {
    if (!mounted) return;
    
    final notesProvider = context.read<NotesProvider>();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.deleteNoteLabel),
        content: const Text(AppConstants.deleteNoteConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppConstants.cancelAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppConstants.deleteAction),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await notesProvider.deleteNote(note.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppConstants.noteDeletedMessage),
              duration: Duration(seconds: AppConstants.snackbarDurationShort),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppConstants.errorMessage}$e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: AppConstants.snackbarDurationLong),
            ),
          );
        }
      }
    }
  }
}
