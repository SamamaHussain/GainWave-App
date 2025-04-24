import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MesocycleTracker extends HookWidget {
  const MesocycleTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final mesocyclesStream = useStream(
      FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('mesocycles')
          .snapshots(),
    );

    final nameController = useTextEditingController();
    final weeksController = useTextEditingController();

    void addMesocycle() async {
      final name = nameController.text.trim();
      final totalWeeks = int.tryParse(weeksController.text) ?? 0;
      if (name.isEmpty || totalWeeks <= 0) return;

      final mesocycleRef = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('mesocycles')
          .add({
        'name': name,
        'totalWeeks': totalWeeks,
        'currentWeek': 1,
        'isComplete': false,
      });

      for (int i = 1; i <= totalWeeks; i++) {
        await mesocycleRef.collection('microcycles').add({
          'week': i,
          'sessions': [],
        });
      }

      nameController.clear();
      weeksController.clear();
    }

    void logSession(String mesocycleId, int week, String notes) async {
      final microcycleQuery = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('mesocycles')
          .doc(mesocycleId)
          .collection('microcycles')
          .where('week', isEqualTo: week)
          .limit(1)
          .get();

      if (microcycleQuery.docs.isNotEmpty) {
        final docRef = microcycleQuery.docs.first.reference;
        await docRef.update({
          'sessions': FieldValue.arrayUnion([{'timestamp': Timestamp.now(), 'notes': notes}]),
        });
      }
    }

    void showAddDialog() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add Mesocycle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: weeksController,
                decoration: const InputDecoration(labelText: 'Weeks'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  addMesocycle();
                  Navigator.of(context).pop();
                },
                child: const Text('Add')),
          ],
        ),
      );
    }

    if (mesocyclesStream.connectionState != ConnectionState.active) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final docs = mesocyclesStream.data?.docs ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gain Wave - Mesocycles'),
      ),
      body: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final doc = docs[index];
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'] ?? '';
          final totalWeeks = data['totalWeeks'] ?? 0;
          final currentWeek = data['currentWeek'] ?? 1;
          final isComplete = data['isComplete'] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(name),
              subtitle: Text(
                'Week $currentWeek of $totalWeeks - ${isComplete ? 'Complete' : 'In Progress'}',
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    final sessionNotesController = TextEditingController();
                    return AlertDialog(
                      title: const Text('Log Training Session'),
                      content: TextField(
                        controller: sessionNotesController,
                        decoration: const InputDecoration(hintText: 'Session Notes'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            logSession(doc.id, currentWeek, sessionNotesController.text);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Log'),
                        )
                      ],
                    );
                  },
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset',
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(userId)
                          .collection('mesocycles')
                          .doc(doc.id)
                          .update({
                        'currentWeek': 1,
                        'isComplete': false,
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    tooltip: 'Advance Week',
                    onPressed: isComplete
                        ? null
                        : () async {
                            final nextWeek = currentWeek + 1;
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(userId)
                                .collection('mesocycles')
                                .doc(doc.id)
                                .update({
                              'currentWeek': nextWeek,
                              'isComplete': nextWeek >= totalWeeks,
                            });
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}