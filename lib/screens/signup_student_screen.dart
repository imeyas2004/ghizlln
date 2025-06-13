import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:studium/constants/sizes.dart';

class SignupStudentScreen extends StatefulWidget {
  const SignupStudentScreen({super.key});

  @override
  State<SignupStudentScreen> createState() => _SignupStudentScreenState();
}

class _SignupStudentScreenState extends State<SignupStudentScreen> {
  final List<String> levels = ['Primaire', 'Collège', 'Lycée'];

  final Map<String, List<String>> levelYears = {
    'Primaire': ['1ère année', '2ème année', '3ème année', '4ème année', '5ème année'],
    'Collège': ['1ère années', '2ème années', '3ème années', '4ème années'],
    'Lycée': ['1ère secondaire', '2ème secondaire', '3ème secondaire'],
  };

  final Map<String, List<String>> branchesByYear = {
    '1ère secondaire': ['Scientifique', 'Littéraire'],
    '2ème secondaire': [
      'Scientifique',
      'Mathélème',
      'Gestion Économique',
      'Technique Math Électrique',
      'Technique Math Mécanique',
      'Technique Math Génie Civil',
      'Lettre',
      'Langue',
    ],
    '3ème secondaire': [
      'Scientifique',
      'Mathélème',
      'Gestion Économique',
      'Technique Math Électrique',
      'Technique Math Mécanique',
      'Technique Math Génie Civil',
      'Lettre',
      'Langue',
    ],
  };

  final Map<String, List<String>> yearSubjects = {
    '1ère année': ['Lecture', 'Mathématiques'],
    '2ème année': ['Lecture', 'Mathématiques', 'Sciences'],
    '3ème année': ['Lecture', 'Mathématiques', 'Sciences', 'Éducation civique'],
    '4ème année': ['Lecture', 'Mathématiques', 'Histoire'],
    '5ème année': ['Mathématiques', 'Sciences', 'Français'],
    '1ème années': ['Mathématiques', 'Arabe', 'Français','Anglais'],
    '2ème années': ['Physique', 'Mathématiques', 'Arabe'],
    '3ème années': ['Sciences', 'Mathématiques', 'Physique'],
    '4ème années': ['Physique', 'Mathématiques', 'Sciences','Arabe','Anglais','Français'],
  };

  final Map<String, Map<String, List<String>>> yearSubjectsByBranch = {
    '1ère secondaire': {
      'Scientifique': ['Mathématiques', 'Physique', 'Sciences'],
      'Littéraire': ['Arabe', 'Mathématiques'],
    },
    '2ème secondaire': {
      'Scientifique': ['Mathématiques', 'Physique', 'Sciences','Arabe'],
      'Mathélème': ['Mathématiques', 'Physique', 'Sciences','Arabe'],
      'Gestion Économique': ['Comptabilité', 'Économie', 'Mathématiques'],
      'Technique Math Électrique': ['Électricité', 'Mathématiques', 'Physique'],
      'Technique Math Mécanique': ['Mécanique', 'Mathématiques', 'Physique'],
      'Technique Math Génie Civil': ['Génie Civil',  'Mathématiques', 'Physique'],
      'Lettre': ['Philosophie', 'Français', 'Arabe','Mathématiques'],
      'Langue': ['Mathématiques','Français', 'Anglais', 'Espagnol','Italien','Allemand'],
    },
    '3ème secondaire': {
      'Scientifique': ['Mathématiques', 'Sciences', 'Physique','Histoire & Geo','Islamique','Philosophie','Arabe','Anglais','Français'],
      'Mathélème': ['Mathématiques', 'Sciences', 'Physique','Histoire & Geo','Islamique','Philosophie','Arabe','Anglais','Français'],
      'Gestion Économique': ['Comptabilité', 'Gestion', 'Économie'],
      'Technique Math Électrique': ['Électronique','Mathématiques','Physique','Histoire & Geo','Islamique','Philosophie','Arabe','Anglais','Français'],
      'Technique Math Mécanique': ['Mécanique', 'Mathématiques','Physique','Histoire & Geo','Islamique','Philosophie','Arabe','Anglais','Français'],
      'Technique Math Génie Civil': ['Génie Civil','Mathématiques','Physique','Histoire & Geo','Islamique','Philosophie','Arabe','Anglais','Français'],
      'Lettre': ['Français', 'Philosophie', 'Histoire'],
      'Langue': ['Français', 'Anglais', 'Allemand'],
    },
  };


  String? selectedLevel;
  String? selectedYear;
  String? selectedBranch;
  List<String> selectedSubjects = [];

  @override
  Widget build(BuildContext context) {
    final yearsForLevel = selectedLevel != null ? levelYears[selectedLevel!] ?? [] : [];
    List<String> subjectsForYear = [];

    if (selectedYear != null) {
      if (['1ère secondaire', '2ème secondaire', '3ème secondaire'].contains(selectedYear)) {
        if (selectedBranch != null) {
          subjectsForYear = yearSubjectsByBranch[selectedYear!]?[selectedBranch!] ?? [];
        }
      } else {
        subjectsForYear = yearSubjects[selectedYear!] ?? [];
      }
    }

    final branchesForYear = selectedYear != null ? branchesByYear[selectedYear!] ?? [] : [];

    bool isFormValid = selectedLevel != null && selectedYear != null && selectedSubjects.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Registration "),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Choix du niveau
            const Text("Level", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              hint: const Text("Select a level"),
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
                  selectedBranch = null;
                  selectedSubjects = [];
                });
              },
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Choix de l’année
            if (selectedLevel != null) ...[
              const Text("Year", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedYear,
                hint: const Text("Select a Year"),
                items: yearsForLevel.map<DropdownMenuItem<String>>((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                    selectedBranch = null;
                    selectedSubjects = [];
                  });
                },
              ),
            ],

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Branche si applicable
            if (branchesForYear.isNotEmpty) ...[
              const Text("Track", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedBranch,
                hint: const Text("Select a Track"),
                items: branchesForYear.map<DropdownMenuItem<String>>((branch) {
                  return DropdownMenuItem(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBranch = value;
                  });
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
            ],

            /// Filière ou Option
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Major or Option",
                prefixIcon: Icon(Iconsax.teacher),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Matières étudiées
            if (selectedYear != null) ...[
              const Text("Subjects", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                onPressed: isFormValid
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You have selected : ${selectedSubjects.first}")),
                  );
                }
                    : null, // désactive le bouton si le formulaire est incomplet
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
