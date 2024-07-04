import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/notes_controller.dart';
import '../../models/notes.dart';
import '../../services/local_notification_service.dart';
import '../widgets/custom_bottom_sheet.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _notesController = NotesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Eslatmalar"),
        leading: TextButton(
          onPressed: () async {
            await LocalNotificationsService.showPeriodicNotification();
            await LocalNotificationsService.scheduleDailyQuoteNotification();
          },
          child: const Text("M"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: _notesController.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("Eslatmalar mavjud emas"),
              );
            }
            final data = snapshot.data!.docs;
            return data.isEmpty
                ? const Center(
                    child: Text("Eslatmalar mavjud emas"),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final note = Note.fromJson(data[index]);
                      DateTime dateTime = note.date.toDate();
                      String formattedDate =
                          DateFormat("dd-MMMM-yyyy hh:mm").format(dateTime);

                      // Schedule a notification for 5 minutes before the note's time
                      scheduleNotification(note, dateTime);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.amber),
                        ),
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              _notesController.updateNote(
                                note.id,
                                !note.isDone,
                                date: note.date,
                                title: note.title,
                              );
                            },
                            icon: note.isDone
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.circle_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                          title: Text(
                            note.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: note.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(formattedDate),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {

                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  _notesController.deleteNote(note.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => AddNoteBottomSheet(
              onAddNote: (title, date) {
                _notesController.updateNote(
                  UniqueKey().toString(),
                  false,
                  title: title,
                  date: date,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void scheduleNotification(Note note, DateTime dateTime) {
    // Calculate the time for the notification (5 minutes before the note's time)
    DateTime notificationTime = dateTime.subtract(const Duration(minutes: 5));
    if (notificationTime.isAfter(DateTime.now())) {
      LocalNotificationsService.showScheduledNotification(
        id: note.id.hashCode,
        title: "Xabar",
        body: "${note.title} nomli eslatmaga 5 daqiqa qoldi.",
        scheduledTime: notificationTime,
      );
    }
  }
}
