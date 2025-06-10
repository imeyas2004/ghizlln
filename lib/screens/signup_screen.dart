import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ghizlln/constants/sizes.dart';
import 'package:ghizlln/constants/textes.dart';
import 'package:ghizlln/constants/images.dart';
import 'package:ghizlln/constants/colors.dart';
import 'signup_student_screen.dart';
import 'signup_teacher_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';


Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null; // Annulé par l'utilisateur

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print("Erreur Google Sign-In: $e");
    return null;
  }
}


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> signUpWithFirebase() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Un lien de vérification a été envoyé à votre e-mail."),
          ),
        );
      }

      print('Utilisateur créé : ${user?.email}');

      if (selectedRole == "prof") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupTeacherScreen()),
        );
      } else if (selectedRole == "etud") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupStudentScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = "Cet e-mail est déjà utilisé.";
      } else if (e.code == 'weak-password') {
        message = "Mot de passe trop faible.";
      } else {
        message = e.message ?? 'Une erreur est survenue.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
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
            Text(
              TTexts.create_Account,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Firstname + Lastname
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: "Firstname",
                            prefixIcon: Icon(Iconsax.user),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "Entrez votre prénom" : null,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: "Lastname",
                            prefixIcon: Icon(Iconsax.user),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "Entrez votre nom" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Entrez un nom d'utilisateur" : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Iconsax.direct),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Veuillez entrer un email';
                      if (!value.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                    validator: (value) =>
                    value != null && value.length < 6 ? "Au moins 6 caractères" : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Phone number
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone number",
                      prefixIcon: Icon(Iconsax.call),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Entrez un numéro de téléphone" : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Role selection
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Rôle",
                      prefixIcon: Icon(Iconsax.user_tag),
                    ),
                    value: selectedRole,
                    items: const [
                      DropdownMenuItem(value: "etud", child: Text("Étudiant")),
                      DropdownMenuItem(value: "prof", child: Text("Professeur")),
                    ],
                    onChanged: (value) => setState(() => selectedRole = value),
                    validator: (value) =>
                    value == null ? "Veuillez choisir un rôle" : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Create account button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUpWithFirebase();
                        }
                      },
                      child: const Text("Créer un compte"),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Social sign in
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {signInWithGoogle();},
                      icon: const Image(
                        width: TSizes.iconMd,
                        image: AssetImage(TImages.google),
                      ),
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
