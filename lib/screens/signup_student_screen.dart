import 'package:flutter/material.dart';
import 'package:ghizlln/constants/sizes.dart';
import 'package:ghizlln/constants/textes.dart';
import 'package:ghizlln/constants/images.dart';
import 'package:ghizlln/constants/colors.dart';


import 'package:iconsax/iconsax.dart';



class SignupStudentScreen extends StatefulWidget {
  const SignupStudentScreen({super.key});

  @override

  State<SignupStudentScreen> createState() => _SignupStudentScreenState();
 }

class _SignupStudentScreenState extends State<SignupStudentScreen> {
  final TextEditingController _experienceController = TextEditingController();

  final List<String> subjects = [
    "Mathématiques", "Physique", "Histoire&geo", "islamic", "Anglais", "Français"
  ];
  final List<String> selectedSubjects = [];
  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                TTexts.just_student,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Formulaire
              Column(
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
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Années d'expérience
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _experienceController,
                    decoration: InputDecoration(
                      labelText: "Years of experience",
                      prefixIcon: Icon(Iconsax.calendar),
                      suffixText: _experienceController.text.isEmpty
                          ? null
                          : int.tryParse(_experienceController.text) == 1
                          ? "year"
                          : "years",
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}


