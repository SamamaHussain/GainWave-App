import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MesocycleTracker extends HookWidget {
  const MesocycleTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the app's color scheme based on profile screen


    final mesocycles = useState<List<Map<String, dynamic>>>([]);
    final nameController = useTextEditingController();
    final weeksController = useTextEditingController();
    final goalController = useTextEditingController();
    final frequencyController = useTextEditingController();
    final isLoading = useState(true);

    // Firebase references
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final String userId = auth.currentUser?.uid ?? '';

    // Function to load mesocycles from Firebase
    Future<List<Map<String, dynamic>>> loadMesocyclesFromFirebase(String userId) async {
      try {
        final querySnapshot = await firestore
            .collection('user')
            .doc(userId)
            .collection('MesoCycles')
            .get();

        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'goal': data['goal'] ?? '',
            'frequency': data['frequency'] ?? 0,
            'totalWeeks': data['totalWeeks'] ?? 0,
            'currentWeek': data['currentWeek'] ?? 1,
            'isComplete': data['isComplete'] ?? false,
            'microcycles': (data['microcycles'] as List?)?.map((m) => Map<String, dynamic>.from(m)).toList() ??
                List.generate(data['totalWeeks'] ?? 0, (i) => {
                      'week': i + 1,
                      'sessions': [],
                    }),
          };
        }).toList();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
        return [];
      }
    }

    // Load mesocycles from Firebase on initial build
    useEffect(() {
      if (userId.isNotEmpty) {
        loadMesocyclesFromFirebase(userId).then((loadedMesocycles) {
          mesocycles.value = loadedMesocycles;
          isLoading.value = false;
        });
      } else {
        isLoading.value = false;
      }
      return null;
    }, []);

    // Function to save mesocycle to Firebase
    Future<void> saveMesocycleToFirebase(Map<String, dynamic> mesocycle) async {
      try {
        if (userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You need to be logged in to save data')),
          );
          return;
        }

        // Convert microcycles to a format that Firestore can handle
        final Map<String, dynamic> firestoreData = {
          'name': mesocycle['name'],
          'goal': mesocycle['goal'],
          'frequency': mesocycle['frequency'],
          'totalWeeks': mesocycle['totalWeeks'],
          'currentWeek': mesocycle['currentWeek'],
          'isComplete': mesocycle['isComplete'],
          'microcycles': mesocycle['microcycles'],
          'createdAt': FieldValue.serverTimestamp(),
        };

        if (mesocycle['id'].startsWith('temp_')) {
          // New mesocycle, create a new document
          final docRef = await firestore
              .collection('user')
              .doc(userId)
              .collection('MesoCycles')
              .add(firestoreData);
              
          // Update the local mesocycle id with the Firestore document id
          mesocycles.value = mesocycles.value.map((m) {
            if (m['id'] == mesocycle['id']) {
              return {...m, 'id': docRef.id};
            }
            return m;
          }).toList();
        } else {
          // Update existing mesocycle
          await firestore
              .collection('user')
              .doc(userId)
              .collection('MesoCycles')
              .doc(mesocycle['id'])
              .update(firestoreData);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }

    // Function to delete mesocycle from Firebase
    Future<void> deleteMesocycleFromFirebase(String id) async {
      try {
        if (userId.isEmpty || id.startsWith('temp_')) {
          return;
        }

        await firestore
            .collection('user')
            .doc(userId)
            .collection('MesoCycles')
            .doc(id)
            .delete();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting data: $e')),
        );
      }
    }

    void addMesocycle() {
      final name = nameController.text.trim();
      final totalWeeks = int.tryParse(weeksController.text) ?? 0;
      final goal = goalController.text.trim();
      final frequency = int.tryParse(frequencyController.text) ?? 0;

      if (name.isEmpty || totalWeeks <= 0 || goal.isEmpty || frequency <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields correctly!')),
        );
        return;
      }

      final newMesocycle = {
        'id': 'temp_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID until Firebase assigns one
        'name': name,
        'goal': goal,
        'frequency': frequency,
        'totalWeeks': totalWeeks,
        'currentWeek': 1,
        'isComplete': false,
        'microcycles': List.generate(totalWeeks, (i) => {
              'week': i + 1,
              'sessions': [],
            }),
      };

      mesocycles.value = [...mesocycles.value, newMesocycle];
      
      // Save to Firebase
      saveMesocycleToFirebase(newMesocycle);

      nameController.clear();
      weeksController.clear();
      goalController.clear();
      frequencyController.clear();
    }

    void deleteMesocycle(String id) {
      mesocycles.value = mesocycles.value.where((m) => m['id'] != id).toList();
      deleteMesocycleFromFirebase(id);
    }

    void logSession(String id, int week, String notes) {
      final updated = mesocycles.value.map((meso) {
        if (meso['id'] == id) {
          final updatedMicrocycles = List<Map<String, dynamic>>.from(meso['microcycles']);
          final index = updatedMicrocycles.indexWhere((m) => m['week'] == week);
          if (index != -1) {
            updatedMicrocycles[index]['sessions'] = [
              ...updatedMicrocycles[index]['sessions'],
              {
                'timestamp': DateTime.now(),
                'notes': notes,
              }
            ];
          }
          return {...meso, 'microcycles': updatedMicrocycles};
        }
        return meso;
      }).toList();
      
      mesocycles.value = updated;
      
      // Save the updated mesocycle to Firebase
      final mesocycle = mesocycles.value.firstWhere((m) => m['id'] == id);
      saveMesocycleToFirebase(mesocycle);
    }

    void showAddDialog() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: secondaryBG,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Add New Mesocycle', 
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name', accentMain),
                const SizedBox(height: 12),
                _buildTextField(weeksController, 'Weeks', accentMain, inputType: TextInputType.number),
                const SizedBox(height: 12),
                _buildTextField(goalController, 'Goal', accentMain),
                const SizedBox(height: 12),
                _buildFrequencyTextField(frequencyController, 'Workout Frequency (Days/week)', accentMain),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: GoogleFonts.roboto(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                addMesocycle();
                Navigator.of(context).pop();
              },
              child: Text(
                'ADD',
                style: GoogleFonts.roboto(color: accentMain, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    void showSessionLogDialog(String mesoId, int week, List<Map<String, dynamic>> sessions) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: secondaryBG,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Week $week Sessions (${sessions.length})',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: sessions.isEmpty
                  ? [Text('No sessions logged yet.', style: GoogleFonts.roboto(color: Colors.white70))]
                  : sessions.map((session) {
                      final time = DateFormat('yyyy-MM-dd – kk:mm').format(session['timestamp']);
                      return ListTile(
                        title: Text(
                          session['notes'] ?? '',
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                        subtitle: Text(
                          time,
                          style: GoogleFonts.roboto(color: Colors.white70, fontSize: 12),
                        ),
                      );
                    }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CLOSE',
                style: GoogleFonts.roboto(color: accentMain),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildMesocycleSummary(Map<String, dynamic> meso) {
      final totalWeeks = meso['totalWeeks'];
      final currentWeek = meso['currentWeek'];
      final percent = (currentWeek / totalWeeks).clamp(0, 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress: ${(percent * 100).toStringAsFixed(0)}%',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.grey.shade800,
              color: accentMain,
            ),
          ),
        ],
      );
    }

    Widget buildMesocycleCard(Map<String, dynamic> meso) {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: secondaryBG,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 41, 61, 23),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fitness_center, 
                      size: 30, 
                      color: accentMain
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      meso['name'],
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () => deleteMesocycle(meso['id']),
                  ),
                ],
              ),
              const Divider(
                color: Colors.white24,
                height: 30,
              ),
              // Information rows
              _infoRow(
                icon: Icons.track_changes_rounded,
                title: 'Goal',
                value: meso['goal'],
                accentColor: accentMain,
              ),
              _infoRow(
                icon: Icons.calendar_today_rounded,
                title: 'Week',
                value: '${meso['currentWeek']} of ${meso['totalWeeks']}',
                accentColor: accentMain,
              ),
              _infoRow(
                icon: Icons.repeat_rounded,
                title: 'Frequency',
                value: '${meso['frequency']} days/week',
                accentColor: accentMain,
              ),
              _infoRow(
                icon: Icons.check_circle_outline_rounded,
                title: 'Status',
                value: meso['isComplete'] ? 'Complete' : 'In Progress',
                accentColor: accentMain,
              ),
              const SizedBox(height: 16),
              buildMesocycleSummary(meso),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.white24,
                height: 10,
              ),
              // Mesocycle actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: Icons.note_add_rounded,
                    label: 'Log Session',
                    accentColor: accentMain,
                    onTap: () {
                      final notesController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: secondaryBG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            'Log a Training Session',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: TextField(
                            controller: notesController,
                            style: GoogleFonts.roboto(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Session notes',
                              hintStyle: GoogleFonts.roboto(color: Colors.white54),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: accentMain),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'CANCEL',
                                style: GoogleFonts.roboto(color: Colors.white70),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                logSession(meso['id'], meso['currentWeek'], notesController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'LOG',
                                style: GoogleFonts.roboto(color: accentMain),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _actionButton(
                    icon: Icons.visibility_rounded,
                    label: 'View Logs',
                    accentColor: accentMain,
                    onTap: () {
                      showSessionLogDialog(
                        meso['id'],
                        meso['currentWeek'],
                        List<Map<String, dynamic>>.from(
                            meso['microcycles'][meso['currentWeek'] - 1]['sessions']),
                      );
                    },
                  ),
                  _actionButton(
                    icon: Icons.refresh_rounded,
                    label: 'Reset',
                    accentColor: accentMain,
                    onTap: () {
                      final updatedMeso = {
                        ...meso,
                        'currentWeek': 1,
                        'isComplete': false,
                      };
                      
                      mesocycles.value = mesocycles.value.map((m) {
                        if (m['id'] == meso['id']) {
                          return updatedMeso;
                        }
                        return m;
                      }).toList();
                      
                      // Save updated mesocycle to Firebase
                      saveMesocycleToFirebase(updatedMeso);
                    },
                  ),
                  _actionButton(
                    icon: Icons.arrow_forward_rounded,
                    label: 'Next Week',
                    accentColor: accentMain,
                    onTap: meso['isComplete']
                      ? null
                      : () {
                          final nextWeek = meso['currentWeek'] + 1;
                          // Ensure week doesn't exceed total weeks
                          final actualNextWeek = nextWeek <= meso['totalWeeks'] ? nextWeek : meso['totalWeeks'];
                          final isComplete = actualNextWeek >= meso['totalWeeks'];
                          
                          final updatedMeso = {
                            ...meso,
                            'currentWeek': actualNextWeek,
                            'isComplete': isComplete,
                          };
                          
                          mesocycles.value = mesocycles.value.map((m) {
                            if (m['id'] == meso['id']) {
                              return updatedMeso;
                            }
                            return m;
                          }).toList();
                          
                          // Save updated mesocycle to Firebase
                          saveMesocycleToFirebase(updatedMeso);
                        },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryBG,
      appBar: AppBar(
        backgroundColor: primaryBG,
        elevation: 0,
        title: Text(
          'Mesocycles',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator(color: accentMain))
          : mesocycles.value.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 70, color: accentMain.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'No Mesocycles Added Yet',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first mesocycle',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mesocycles.value.length,
                  itemBuilder: (context, index) {
                    return buildMesocycleCard(mesocycles.value[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        backgroundColor: accentMain,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    Color accentColor,
    {TextInputType inputType = TextInputType.text}
  ) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: GoogleFonts.roboto(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
    );
  }

  Widget _buildFrequencyTextField(
    TextEditingController controller, 
    String label,
    Color accentColor,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.roboto(color: Colors.white),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1), // Limit input length to 1 character
      ],
      onChanged: (value) {
        if (value.isNotEmpty && (int.parse(value) < 1 || int.parse(value) > 7)) {
          controller.text = '1'; // or some other default value
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color accentColor,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon, 
                color: accentColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}