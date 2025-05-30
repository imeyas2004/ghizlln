import 'package:flutter/material.dart';
import 'package:ghizlln/constants/colors.dart';
import 'package:ghizlln/constants/images.dart';
import 'package:ghizlln/constants/sizes.dart';
import 'package:ghizlln/constants/textes.dart';
import 'package:ghizlln/constants/spacing_style.dart';
import 'package:ghizlln/screens/signup_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

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
              /// Logo and Titles
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage(
                      dark ? TImages.splash_screen_lightmode : TImages.splash_screen_lightmode,
                    ),
                  ),
                  Text(
                    TTexts.loginTitle,
                    style: const TextStyle(
                      fontSize: 30, // Taille personnalisée
                      fontWeight: FontWeight.bold, // Gras
                      fontFamily: 'PoetsenOne', // 👈 Applique la police
                      color: Colors.black, // Couleur noire
                  ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    TTexts.loginSubTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              /// Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TSizes.spaceBtwSections,
                  ),
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: TTexts.email,
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Password
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.password_check),
                          labelText: TTexts.Password, // corrected here
                          suffixIcon: Icon(Iconsax.eye_slash),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields / 2),

                      /// Remember Me & Forget Password
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

                      /// Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(TTexts.signIn),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Create Account Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.to(() => const SignupScreen());},
                          child: Text("Create Account"),
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
                    _capitalize(TTexts.orSignInWith), // use custom function
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

              /// Social Footer
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
