import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:studium/constants/sizes.dart';

class SignupTeacherScreen extends StatefulWidget {
  const SignupTeacherScreen({super.key});

  @override
  State<SignupTeacherScreen> createState() => _SignupTeacherScreenState();
}

class _SignupTeacherScreenState extends State<SignupTeacherScreen> {
  final List<String> levels = ['Primaire', 'Collège', 'Lycée'];

  final Map<String, List<String>> levelYears = {
    'Primaire': ['1ère année', '2ème année', '3ème année', '4ème année', '5ème année'],
    'Collège': ['1ère années', '2ème années', '3ème années', '4ème années'],
    'Lycée': ['1ère secondaire', '2ème secondaire', '3ème secondaire'],
  };

  final Map<String, List<String>> yearSubjects = {
    '1ère année': ['Lecture', 'Mathématiques'],
    '2ème année': ['Lecture', 'Mathématiques', 'Sciences'],
    '3ème année': ['Lecture', 'Mathématiques', 'Sciences', 'Éducation civique'],
    '4ème année': ['Lecture', 'Mathématiques', 'Histoire'],
    '5ème année': ['Mathématiques', 'Sciences', 'Français'],
    '1ème années': ['Mathématiques', 'Arabe', 'Français'],
    '2ème années': ['Physique', 'Mathématiques', 'Anglais'],
    '3ème années': ['Sciences', 'Histoire', 'Français'],
    '4ème années': ['Physique', 'Mathématiques', 'Islamic'],
    '1ère secondaire': ['Physique', 'Mathématiques', 'Philosophie'],
    '2ème secondaire': ['Mathématiques', 'SVT', 'Histoire'],
    '3ème secondaire': ['Mathématiques', 'Anglais', 'Physique'],
  };

  String? selectedLevel;
  String? selectedYear;
  List<String> selectedSubjects = [];

  @override
  Widget build(BuildContext context) {
    final yearsForLevel = selectedLevel != null ? levelYears[selectedLevel!] ?? [] : [];
    final subjectsForYear = selectedYear != null ? yearSubjects[selectedYear!] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription Enseignant"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Choix du niveau
            const Text("Niveau", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              hint: const Text("Choisir un niveau"),
              items: levels.map<DropdownMenuItem<String>>((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedLevel = value;
                  selectedYear = null;
                  selectedSubjects = [];
                });
              },
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Choix de l’année
            if (selectedLevel != null) ...[
              const Text("Année", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedYear,
                hint: const Text("Choisir une année"),
                items: yearsForLevel.map<DropdownMenuItem<String>>((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                    selectedSubjects = [];
                  });
                },
              ),
            ],

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Diplôme ou niveau d'étude
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Diplôme ou niveau d'étude",
                prefixIcon: Icon(Iconsax.teacher),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Matières enseignées
            if (selectedYear != null) ...[
              const Text("Matières enseignées", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Column(
                children: subjectsForYear.map((subject) {
                  return CheckboxListTile(
                    title: Text(subject),
                    value: selectedSubjects.contains(subject),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedSubjects.add(subject);
                        } else {
                          selectedSubjects.remove(subject);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedLevel == null || selectedYear == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez choisir un niveau et une année")),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enregistré avec succès")),
                  );
                },
                child: const Text("Valider"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
