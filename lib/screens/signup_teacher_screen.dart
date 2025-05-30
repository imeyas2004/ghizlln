import 'package:flutter/material.dart';
import 'package:ghizlln/constants/sizes.dart';
import 'package:ghizlln/constants/textes.dart';
import 'package:ghizlln/constants/images.dart';
import 'package:ghizlln/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class SignupTeacherScreen extends StatefulWidget {
  const SignupTeacherScreen({super.key});

  @override
  State<SignupTeacherScreen> createState() => _SignupTeacherScreenState();
}

class _SignupTeacherScreenState extends State<SignupTeacherScreen> {
  final List<String> subjects = [
    "Mathématiques", "Physique", "Histoire&geo", "Islamic", "Anglais", "Français"
  ];
  final List<String> selectedSubjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription Enseignant"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Diplôme ou niveau d'étude
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Diploma or level of education",
                  prefixIcon: Icon(Iconsax.teacher),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Matières enseignées
              const Text(
                "Subjects Taught",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              Column(
                children: subjects.map((subject) {
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
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Button (à adapter selon ton besoin)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Traiter l'envoi ici
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
      ),
    );
  }
}
