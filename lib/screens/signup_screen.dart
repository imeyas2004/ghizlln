import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studium/constants/colors.dart';
import 'package:studium/constants/images.dart';
import 'package:studium/constants/sizes.dart';
import 'package:studium/constants/textes.dart';
import 'package:studium/screens/signup_student_screen.dart';
import 'package:studium/screens/signup_teacher_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;
  String? selectedWilaya;
  File? _profileImage;

  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<String> wilayas = [
    'Adrar', 'Chlef', 'Laghouat', 'Oum El Bouaghi', 'Batna', 'Béjaïa',
    'Biskra', 'Béchar', 'Blida', 'Bouira', 'Tamanrasset', 'Tébessa',
    'Tlemcen', 'Tiaret', 'Tizi Ouzou', 'Alger', 'Djelfa', 'Jijel',
    'Sétif', 'Saïda', 'Skikda', 'Sidi Bel Abbès', 'Annaba', 'Guelma',
    'Constantine', 'Médéa', 'Mostaganem', 'M’Sila', 'Mascara', 'Ouargla',
    'Oran', 'El Bayadh', 'Illizi', 'Bordj Bou Arréridj', 'Boumerdès',
    'El Tarf', 'Tindouf', 'Tissemsilt', 'El Oued', 'Khenchela',
    'Souk Ahras', 'Tipaza', 'Mila', 'Aïn Defla', 'Naâma',
    'Aïn Témouchent', 'Ghardaïa', 'Relizane', 'Timimoun',
    'Bordj Badji Mokhtar', 'Ouled Djellal', 'Béni Abbès',
    'In Salah', 'In Guezzam', 'Touggourt', 'Djanet',
    'El M’Ghair', 'El Meniaa',
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> enregistrerUtilisateur() async {
    try {
      final String collection = selectedRole == 'student' ? 'etudiants' : 'enseignants';

      await FirebaseFirestore.instance.collection(collection).add({
        'prenom': _prenomController.text.trim(),
        'nom': _nomController.text.trim(),
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'telephone': _phoneController.text.trim(),
        'wilaya': selectedWilaya,
        'role': selectedRole,
        'date_inscription': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enregistré avec succès ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            Text(TTexts.create_Account, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: TColors.primary,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Iconsax.camera, color: Colors.white, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _prenomController,
                          decoration: const InputDecoration(
                            labelText: "firstname",
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: _nomController,
                          decoration: const InputDecoration(
                            labelText: "lastname",
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Iconsax.direct),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Entrez un email';
                      if (!value.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "PhoneNumber",
                      prefixIcon: Icon(Iconsax.microphone),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  DropdownButtonFormField<String>(
                    value: selectedWilaya,
                    hint: const Text("Wilaya de résidence"),
                    items: wilayas.map((wilaya) => DropdownMenuItem(value: wilaya, child: Text(wilaya))).toList(),
                    onChanged: (value) => setState(() => selectedWilaya = value),
                    validator: (value) => value == null ? 'Choisissez votre wilaya' : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    hint: const Text("Vous êtes ?"),
                    items: const [
                      DropdownMenuItem(value: 'student', child: Text('Étudiant')),
                      DropdownMenuItem(value: 'teacher', child: Text('Enseignant')),
                    ],
                    onChanged: (value) => setState(() => selectedRole = value),
                    validator: (value) => value == null ? 'Choisissez un rôle' : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedRole == 'student') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupStudentScreen(
                                  prenom: _prenomController.text.trim(),
                                  nom: _nomController.text.trim(),
                                  username: _usernameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  telephone: _phoneController.text.trim(),
                                  wilaya: selectedWilaya ?? '',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SignupTeacherScreen(
                                  prenom: _prenomController.text.trim(),
                                  nom: _nomController.text.trim(),
                                  username: _usernameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  telephone: _phoneController.text.trim(),
                                  wilaya: selectedWilaya ?? '',
                                ),
                              ),
                            );
                          }
                        }
                      }
                      child: const Text("Create Account"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
