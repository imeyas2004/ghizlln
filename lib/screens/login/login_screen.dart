import 'package:flutter/material.dart';
import 'package:ghizlln/constants/colors.dart';
import 'package:ghizlln/constants/images.dart';
import 'package:ghizlln/constants/sizes.dart';
import 'package:ghizlln/constants/textes.dart';
import 'package:ghizlln/constants/spacing_style.dart';
import 'package:ghizlln/screens/signup_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo et titre
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      height: 150,
                      image: AssetImage(
                        dark
                            ? TImages.splash_screen_lightmode
                            : TImages.splash_screen_lightmode,
                      ),
                    ),
                    Text(
                      TTexts.loginTitle,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoetsenOne',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: TSizes.sm),
                    Text(
                      TTexts.loginSubTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // Formulaire
                Form(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.direct_right),
                            labelText: TTexts.email,
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.password_check),
                            labelText: TTexts.Password,
                            suffixIcon: Icon(Iconsax.eye_slash),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                ),
                                const Text(TTexts.rememberMe),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(TTexts.forgetPassword),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        /// 🔥 Bouton de connexion avec vérification d'email
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              try {
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: email, password: password);

                                if (!credential.user!.emailVerified) {
                                  await credential.user!.sendEmailVerification();
                                  await FirebaseAuth.instance.signOut();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Veuillez vérifier votre adresse e-mail. Un lien a été renvoyé."),
                                    ),
                                  );
                                  return;
                                }

                                // ✅ Connexion réussie
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Connecté avec succès : ${credential.user?.email}'),
                                  ),
                                );

                                // TODO : Naviguer vers HomeScreen ou dashboard ici
                              } on FirebaseAuthException catch (e) {
                                String message = '';
                                if (e.code == 'user-not-found') {
                                  message = 'Aucun utilisateur trouvé pour cet email.';
                                } else if (e.code == 'wrong-password') {
                                  message = 'Mot de passe incorrect.';
                                } else {
                                  message = 'Erreur : ${e.message}';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              }
                            },
                            child: const Text(TTexts.signIn),
                          ),
                        ),

                        const SizedBox(height: TSizes.spaceBtwItems),

                        /// 🔹 Bouton de création de compte
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.to(() => const SignupScreen());
                            },
                            child: const Text("Créer un compte"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                /// Divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: dark ? TColors.darkGrey : TColors.grey,
                        thickness: 0.5,
                        indent: 60,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      _capitalize(TTexts.orSignInWith),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Flexible(
                      child: Divider(
                        color: dark ? TColors.darkGrey : TColors.grey,
                        thickness: 0.5,
                        indent: 5,
                        endIndent: 60,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                /// Footer social login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.grey),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Image(
                          width: TSizes.iconMd,
                          image: AssetImage(TImages.google),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
