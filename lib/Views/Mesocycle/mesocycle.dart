import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class MesocycleTracker extends HookWidget {
  const MesocycleTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mesocycles = useState<List<Map<String, dynamic>>>([]);
    final nameController = useTextEditingController();
    final weeksController = useTextEditingController();
    final goalController = useTextEditingController();
    final repsController = useTextEditingController();

    void addMesocycle() {
      final name = nameController.text.trim();
      final totalWeeks = int.tryParse(weeksController.text) ?? 0;
      final goal = goalController.text.trim();
      final reps = int.tryParse(repsController.text) ?? 0;

      if (name.isEmpty || totalWeeks <= 0 || goal.isEmpty || reps <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields correctly!')),
        );
        return;
      }

      mesocycles.value = [
        ...mesocycles.value,
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'goal': goal,
          'reps': reps,
          'totalWeeks': totalWeeks,
          'currentWeek': 1,
          'isComplete': false,
          'microcycles': List.generate(totalWeeks, (i) => {
                'week': i + 1,
                'sessions': [],
              }),
        },
      ];

      nameController.clear();
      weeksController.clear();
      goalController.clear();
      repsController.clear();
    }

    void deleteMesocycle(String id) {
      mesocycles.value = mesocycles.value.where((m) => m['id'] != id).toList();
    }

    void logSession(String id, int week, String notes) {
      final updated = mesocycles.value.map((meso) {
        if (meso['id'] == id) {
          final updatedMicrocycles =
              List<Map<String, dynamic>>.from(meso['microcycles']);
          final index = updatedMicrocycles.indexWhere((m) => m['week'] == week);
          if (index != -1) {
            updatedMicrocycles[index]['sessions'].add({
              'timestamp': DateTime.now(),
              'notes': notes,
            });
          }
          return {...meso, 'microcycles': updatedMicrocycles};
        }
        return meso;
      }).toList();
      mesocycles.value = updated;
    }

    void showAddDialog() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add New Mesocycle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                const SizedBox(height: 8),
                _buildTextField(weeksController, 'Weeks',
                    inputType: TextInputType.number),
                const SizedBox(height: 8),
                _buildTextField(goalController, 'Goal'),
                const SizedBox(height: 8),
                _buildTextField(repsController, 'Reps',
                    inputType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addMesocycle();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    void showSessionLogDialog(
        String mesoId, int week, List<Map<String, dynamic>> sessions) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Week $week Sessions (${sessions.length})'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: sessions.isEmpty
                  ? [const Text('No sessions logged yet.')]
                  : sessions.map((session) {
                      final time = DateFormat('yyyy-MM-dd – kk:mm')
                          .format(session['timestamp']);
                      return ListTile(
                        title: Text(session['notes'] ?? ''),
                        subtitle: Text(time),
                      );
                    }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }

    Widget buildSummary(Map<String, dynamic> meso) {
      final totalWeeks = meso['totalWeeks'];
      final currentWeek = meso['currentWeek'];
      final percent = (currentWeek / totalWeeks).clamp(0, 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress: ${(percent * 100).toStringAsFixed(0)}%'),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.deepPurple,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GainWave - Mesocycles'),
      ),
      body: mesocycles.value.isEmpty
          ? const Center(child: Text('No Mesocycles Added Yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: mesocycles.value.length,
              itemBuilder: (context, index) {
                final meso = mesocycles.value[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            meso['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Goal: ${meso['goal']}'),
                              Text('Reps: ${meso['reps']}'),
                              Text(
                                  'Week ${meso['currentWeek']} of ${meso['totalWeeks']}'),
                              Text('Status: ${meso['isComplete'] ? 'Complete' : 'In Progress'}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteMesocycle(meso['id']),
                          ),
                          onTap: () {
                            final notesController = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Log a Training Session'),
                                content: TextField(
                                  controller: notesController,
                                  decoration: const InputDecoration(
                                      hintText: 'Session notes'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      logSession(meso['id'], meso['currentWeek'],
                                          notesController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Log'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      showSessionLogDialog(
                                        meso['id'],
                                        meso['currentWeek'],
                                        List<Map<String, dynamic>>.from(
                                            meso['microcycles']
                                                [meso['currentWeek'] - 1]['sessions']),
                                      );
                                    },
                                    child: const Text('View Logs'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        buildSummary(meso),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                mesocycles.value = mesocycles.value.map((m) {
                                  if (m['id'] == meso['id']) {
                                    return {
                                      ...m,
                                      'currentWeek': 1,
                                      'isComplete': false,
                                    };
                                  }
                                  return m;
                                }).toList();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: meso['isComplete']
                                  ? null
                                  : () {
                                      mesocycles.value = mesocycles.value.map((m) {
                                        if (m['id'] == meso['id']) {
                                          final nextWeek = m['currentWeek'] + 1;
                                          return {
                                            ...m,
                                            'currentWeek': nextWeek,
                                            'isComplete': nextWeek > m['totalWeeks'],
                                          };
                                        }
                                        return m;
                                      }).toList();
                                    },
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Next Week'),
                            ),
                          ],
                        )
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

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}