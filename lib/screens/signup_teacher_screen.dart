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

  final Map<String, dynamic> yearSubjects = {
    // Primaire
    '1ère année': ['Lecture', 'Mathématiques'],
    '2ème année': ['Lecture', 'Mathématiques', 'Arabe'],
    '3ème année': ['Lecture', 'Mathématiques', 'Sciences', 'Éducation civique'],
    '4ème année': ['Lecture', 'Mathématiques', 'Histoire'],
    '5ème année': ['Mathématiques', 'Anglais', 'Français','Arabe'],

    // Collège
    '1ème années': ['Mathématiques', 'Arabe', 'Français','Anglais'],
    '2ème années': ['Mathématiques', 'Arabe', 'Français','Anglais'],
    '3ème années': ['Sciences', 'Mathématiques', 'Arabe', 'Français','Anglais'],
    '4ème années': ['Physique', 'Sciences', 'Mathématiques', 'Arabe', 'Français','Anglais'],

    // Lycée (avec branches)
    '1ère secondaire': {
      'Scientifique': ['Mathématiques', 'Physique', 'Sciences'],
      'Littéraire': ['Arabe', 'Anglais', 'Français']
    },
    '2ème secondaire': {
      'Scientifique': ['Mathématiques', 'Physique', 'Chimie'],
      'Littéraire': ['Arabe', 'Philosophie', 'Français','Anglais','Espagnol','Allemend','Italien']
    },
    '3ème secondaire': {
      'Scientifique': ['Mathématiques', 'Physique', 'Sciences','Électrique','Mécanique','Génie Civil'],
      'Littéraire': ['Arabe', 'Philosophie', 'Français','Anglais','Histoire & Geo','Islamique','Espagnol','Allemend','Italien']
    },
  };


  String? selectedLevel;
  String? selectedYear;
  String? selectedBranch;
  List<String> selectedSubjects = [];
  String? generatedCode;
  bool isVerifying = false;
  final TextEditingController codeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final yearsForLevel = selectedLevel != null ? levelYears[selectedLevel!] ?? [] : [];
    dynamic subjectsForYear;
    if (selectedYear != null) {
      final data = yearSubjects[selectedYear!];
      if (data is Map && selectedBranch != null) {
        subjectsForYear = data[selectedBranch];
      } else if (data is List) {
        subjectsForYear = data;
      } else {
        subjectsForYear = [];
      }
    }

    bool isFormValid = selectedLevel != null && selectedYear != null && selectedSubjects.isNotEmpty;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Registration"),
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
              hint: const Text("Select a Level"),
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
              const Text("Year", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedYear,
                hint: const Text("Select a year"),
                items: yearsForLevel.map<DropdownMenuItem<String>>((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                    selectedBranch = null; // reset branch
                    selectedSubjects = [];
                  });
                },
              ),
              if (selectedLevel == 'Lycée' &&
                  selectedYear != null &&
                  yearSubjects[selectedYear!] is Map) ...[
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const Text("Track", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedBranch,
                  hint: const Text("Select a Track"),
                  items: ['Scientifique', 'Littéraire'].map((branch) {
                    return DropdownMenuItem(
                      value: branch,
                      child: Text(branch),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBranch = value;
                      selectedSubjects = [];
                    });
                  },
                ),
              ],


            ],


            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Diplôme ou niveau d'étude
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Degree or Level of Education",
                prefixIcon: Icon(Iconsax.teacher),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Matières enseignées
            if (selectedYear != null &&
                ((yearSubjects[selectedYear!] is List) ||
                    (yearSubjects[selectedYear!] is Map && selectedBranch != null))) ...[
              const Text("Subjects Taught", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Column(
                children: (
                    yearSubjects[selectedYear!] is List
                        ? yearSubjects[selectedYear!] as List<String>
                        : (yearSubjects[selectedYear!] as Map<String, List<String>>)[selectedBranch!] ?? []
                ).map((subject) {
                  return RadioListTile<String>(
                    title: Text(subject),
                    value: subject,
                    groupValue: selectedSubjects.isNotEmpty ? selectedSubjects.first : null,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSubjects = [value!]; // remplace la liste par un seul élément
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
                  // Génération d’un code de vérification simple
                  generatedCode = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

                  // Affiche le code (simulation d'envoi SMS/email)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Verification code sent: $generatedCode")),
                  );

                  setState(() {
                    isVerifying = true;
                  });
                }
                    : null, // Désactive le bouton si formulaire incomplet
                child: const Text("Submit"),
              ),
            ),

            if (isVerifying) ...[
              const SizedBox(height: TSizes.spaceBtwInputFields),
              const Text("Enter the verification code", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: "Verification Code",
                  prefixIcon: Icon(Iconsax.security_user),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (codeController.text == generatedCode) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Verification successful!")),
                      );
                      // Action après vérification réussie (ex : navigation)
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Incorrect verification code")),
                      );
                    }
                  },
                  child: const Text("Verify"),
                ),
              ),
            ],


          ],
        ),
      ),
    );
  }
}
