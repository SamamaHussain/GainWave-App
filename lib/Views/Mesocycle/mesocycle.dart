// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MesocycleTracker extends HookWidget {
//   const MesocycleTracker({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final mesocycles = useState<List<Map<String, dynamic>>>([]);
//     final nameController = useTextEditingController();
//     final weeksController = useTextEditingController();
//     final goalController = useTextEditingController();
//     final frequencyController = useTextEditingController();
//     final isLoading = useState(true);

//     // Firebase references
//     final firestore = FirebaseFirestore.instance;
//     final auth = FirebaseAuth.instance;
//     final String userId = auth.currentUser?.uid ?? '';


//         // Function to load mesocycles from Firebase
//     Future<List<Map<String, dynamic>>> loadMesocyclesFromFirebase(String userId) async {
//       try {
//         final querySnapshot = await firestore
//             .collection('user')
//             .doc(userId)
//             .collection('MesoCycles')
//             .get();

//         return querySnapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['name'] ?? '',
//             'goal': data['goal'] ?? '',
//             'frequency': data['frequency'] ?? 0,
//             'totalWeeks': data['totalWeeks'] ?? 0,
//             'currentWeek': data['currentWeek'] ?? 1,
//             'isComplete': data['isComplete'] ?? false,
//             'microcycles': (data['microcycles'] as List?)?.map((m) => Map<String, dynamic>.from(m)).toList() ??
//                 List.generate(data['totalWeeks'] ?? 0, (i) => {
//                       'week': i + 1,
//                       'sessions': [],
//                     }),
//           };
//         }).toList();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading data: $e')),
//         );
//         return [];
//       }
//     }


//     // Load mesocycles from Firebase on initial build
//     useEffect(() {
//       if (userId.isNotEmpty) {
//         loadMesocyclesFromFirebase(userId).then((loadedMesocycles) {
//           mesocycles.value = loadedMesocycles;
//           isLoading.value = false;
//         });
//       } else {
//         isLoading.value = false;
//       }
//       return null;
//     }, []);


//     // Function to save mesocycle to Firebase
//     Future<void> saveMesocycleToFirebase(Map<String, dynamic> mesocycle) async {
//       try {
//         if (userId.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('You need to be logged in to save data')),
//           );
//           return;
//         }

//         // Convert microcycles to a format that Firestore can handle
//         final Map<String, dynamic> firestoreData = {
//           'name': mesocycle['name'],
//           'goal': mesocycle['goal'],
//           'frequency': mesocycle['frequency'],
//           'totalWeeks': mesocycle['totalWeeks'],
//           'currentWeek': mesocycle['currentWeek'],
//           'isComplete': mesocycle['isComplete'],
//           'microcycles': mesocycle['microcycles'],
//           'createdAt': FieldValue.serverTimestamp(),
//         };

//         if (mesocycle['id'].startsWith('temp_')) {
//           // New mesocycle, create a new document
//           final docRef = await firestore
//               .collection('user')
//               .doc(userId)
//               .collection('MesoCycles')
//               .add(firestoreData);
              
//           // Update the local mesocycle id with the Firestore document id
//           mesocycles.value = mesocycles.value.map((m) {
//             if (m['id'] == mesocycle['id']) {
//               return {...m, 'id': docRef.id};
//             }
//             return m;
//           }).toList();
//         } else {
//           // Update existing mesocycle
//           await firestore
//               .collection('user')
//               .doc(userId)
//               .collection('MesoCycles')
//               .doc(mesocycle['id'])
//               .update(firestoreData);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving data: $e')),
//         );
//       }
//     }

//     // Function to delete mesocycle from Firebase
//     Future<void> deleteMesocycleFromFirebase(String id) async {
//       try {
//         if (userId.isEmpty || id.startsWith('temp_')) {
//           return;
//         }

//         await firestore
//             .collection('user')
//             .doc(userId)
//             .collection('MesoCycles')
//             .doc(id)
//             .delete();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error deleting data: $e')),
//         );
//       }
//     }

//     void addMesocycle() {
//       final name = nameController.text.trim();
//       final totalWeeks = int.tryParse(weeksController.text) ?? 0;
//       final goal = goalController.text.trim();
//       final frequency = int.tryParse(frequencyController.text) ?? 0;

//       if (name.isEmpty || totalWeeks <= 0 || goal.isEmpty || frequency <= 0) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill all fields correctly!')),
//         );
//         return;
//       }

//       final newMesocycle = {
//         'id': 'temp_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID until Firebase assigns one
//         'name': name,
//         'goal': goal,
//         'frequency': frequency,
//         'totalWeeks': totalWeeks,
//         'currentWeek': 1,
//         'isComplete': false,
//         'microcycles': List.generate(totalWeeks, (i) => {
//               'week': i + 1,
//               'sessions': [],
//             }),
//       };

//       mesocycles.value = [...mesocycles.value, newMesocycle];
      
//       // Save to Firebase
//       saveMesocycleToFirebase(newMesocycle);

//       nameController.clear();
//       weeksController.clear();
//       goalController.clear();
//       frequencyController.clear();
//     }

//     void deleteMesocycle(String id) {
//       mesocycles.value = mesocycles.value.where((m) => m['id'] != id).toList();
//       deleteMesocycleFromFirebase(id);
//     }

//     void logSession(String id, int week, String notes) {
//       final updated = mesocycles.value.map((meso) {
//         if (meso['id'] == id) {
//           final updatedMicrocycles = List<Map<String, dynamic>>.from(meso['microcycles']);
//           final index = updatedMicrocycles.indexWhere((m) => m['week'] == week);
//           if (index != -1) {
//             updatedMicrocycles[index]['sessions'] = [
//               ...updatedMicrocycles[index]['sessions'],
//               {
//                 'timestamp': DateTime.now(),
//                 'notes': notes,
//               }
//             ];
//           }
//           return {...meso, 'microcycles': updatedMicrocycles};
//         }
//         return meso;
//       }).toList();
      
//       mesocycles.value = updated;
      
//       // Save the updated mesocycle to Firebase
//       final mesocycle = mesocycles.value.firstWhere((m) => m['id'] == id);
//       saveMesocycleToFirebase(mesocycle);
//     }

//     void showAddDialog() {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Add New Mesocycle'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildTextField(nameController, 'Name'),
//                 const SizedBox(height: 8),
//                 _buildTextField(weeksController, 'Weeks', inputType: TextInputType.number),
//                 const SizedBox(height: 8),
//                 _buildTextField(goalController, 'Goal'),
//                 const SizedBox(height: 8),
//                 _buildFrequencyTextField(frequencyController, 'Workout Frequency (Days/week)', 
//                    ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 addMesocycle();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//       );
//     }

//     void showSessionLogDialog(String mesoId, int week, List<Map<String, dynamic>> sessions) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Week $week Sessions (${sessions.length})'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView(
//               shrinkWrap: true,
//               children: sessions.isEmpty
//                   ? [const Text('No sessions logged yet.')]
//                   : sessions.map((session) {
//                       final time = DateFormat('yyyy-MM-dd – kk:mm').format(session['timestamp']);
//                       return ListTile(
//                         title: Text(session['notes'] ?? ''),
//                         subtitle: Text(time),
//                       );
//                     }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Close'),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget buildSummary(Map<String, dynamic> meso) {
//       final totalWeeks = meso['totalWeeks'];
//       final currentWeek = meso['currentWeek'];
//       final percent = (currentWeek / totalWeeks).clamp(0, 1.0);

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Progress: ${(percent * 100).toStringAsFixed(0)}%'),
//           const SizedBox(height: 6),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: percent,
//               minHeight: 10,
//               backgroundColor: Colors.grey.shade300,
//               color: Colors.deepPurple,
//             ),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('GainWave - Mesocycles'),
//       ),
//       body: isLoading.value
//           ? const Center(child: CircularProgressIndicator())
//           : mesocycles.value.isEmpty
//               ? const Center(child: Text('No Mesocycles Added Yet.'))
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: mesocycles.value.length,
//                   itemBuilder: (context, index) {
//                     final meso = mesocycles.value[index];

//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       elevation: 8,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               contentPadding: EdgeInsets.zero,
//                               title: Text(
//                                 meso['name'],
//                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 4),
//                                   Text('Goal: ${meso['goal']}'),
//                                   Text('Workout Frequency: ${meso['frequency']} days/week'),
//                                   Text('Week ${meso['currentWeek']} of ${meso['totalWeeks']}'),
//                                   Text('Status: ${meso['isComplete'] ? 'Complete' : 'In Progress'}'),
//                                 ],
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () => deleteMesocycle(meso['id']),
//                               ),
//                               onTap: () {
//                                 final notesController = TextEditingController();
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: const Text('Log a Training Session'),
//                                     content: TextField(
//                                       controller: notesController,
//                                       decoration: const InputDecoration(hintText: 'Session notes'),
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () => Navigator.of(context).pop(),
//                                         child: const Text('Cancel'),
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           logSession(meso['id'], meso['currentWeek'], notesController.text);
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: const Text('Log'),
//                                       ),
//                                       OutlinedButton(
//                                         onPressed: () {
//                                           showSessionLogDialog(
//                                             meso['id'],
//                                             meso['currentWeek'],
//                                             List<Map<String, dynamic>>.from(
//                                                 meso['microcycles'][meso['currentWeek'] - 1]['sessions']),
//                                           );
//                                         },
//                                         child: const Text('View Logs'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             buildSummary(meso),
//                             const SizedBox(height: 10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 TextButton.icon(
//                                   onPressed: () {
//                                     final updatedMeso = {
//                                       ...meso,
//                                       'currentWeek': 1,
//                                       'isComplete': false,
//                                     };
                                    
//                                     mesocycles.value = mesocycles.value.map((m) {
//                                       if (m['id'] == meso['id']) {
//                                         return updatedMeso;
//                                       }
//                                       return m;
//                                     }).toList();
                                    
//                                     // Save updated mesocycle to Firebase
//                                     saveMesocycleToFirebase(updatedMeso);
//                                   },
//                                   icon: const Icon(Icons.refresh),
//                                   label: const Text('Reset'),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 ElevatedButton.icon(
//                                   onPressed: meso['isComplete']
//                                       ? null
//                                       : () {
//                                           final nextWeek = meso['currentWeek'] + 1;
//                                           final isComplete = nextWeek > meso['totalWeeks'];
                                          
//                                           final updatedMeso = {
//                                             ...meso,
//                                             'currentWeek': nextWeek,
//                                             'isComplete': isComplete,
//                                           };
                                          
//                                           mesocycles.value = mesocycles.value.map((m) {
//                                             if (m['id'] == meso['id']) {
//                                               return updatedMeso;
//                                             }
//                                             return m;
//                                           }).toList();
                                          
//                                           // Save updated mesocycle to Firebase
//                                           saveMesocycleToFirebase(updatedMeso);
//                                         },
//                                   icon: const Icon(Icons.arrow_forward),
//                                   label: const Text('Next Week'),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showAddDialog,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label,
//       {TextInputType inputType = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: inputType,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//     Widget _buildFrequencyTextField(TextEditingController controller, String label) {
//   return TextField(
//     controller: controller,
//     keyboardType: TextInputType.number,
//     inputFormatters: [
//       FilteringTextInputFormatter.digitsOnly,
//       LengthLimitingTextInputFormatter(1), // Limit input length to 1 character
//     ],
//     onChanged: (value) {
//       if (value.isNotEmpty && (int.parse(value) < 1 || int.parse(value) > 7)) {
//         controller.text = '1'; // or some other default value
//       }
//     },
//     decoration: InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//     ),
//   );
// }

// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MesocycleTracker extends HookWidget {
  const MesocycleTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Add New Mesocycle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                const SizedBox(height: 8),
                _buildTextField(weeksController, 'Weeks', inputType: TextInputType.number),
                const SizedBox(height: 8),
                _buildTextField(goalController, 'Goal'),
                const SizedBox(height: 8),
                _buildFrequencyTextField(frequencyController, 'Workout Frequency (Days/week)', ),
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

    void showSessionLogDialog(String mesoId, int week, List<Map<String, dynamic>> sessions) {
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
                      final time = DateFormat('yyyy-MM-dd – kk:mm').format(session['timestamp']);
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
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : mesocycles.value.isEmpty
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('Goal: ${meso['goal']}'),
                                  Text('Workout Frequency: ${meso['frequency']} days/week'),
                                  Text('Week ${meso['currentWeek']} of ${meso['totalWeeks']}'),
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
                                      decoration: const InputDecoration(hintText: 'Session notes'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          logSession(meso['id'], meso['currentWeek'], notesController.text);
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
                                                meso['microcycles'][meso['currentWeek'] - 1]['sessions']),
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
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reset'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: meso['isComplete']
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

      Widget _buildFrequencyTextField(TextEditingController controller, String label) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

}