import 'package:flutter/material.dart';
import 'package:ghizlln/constants/sizes.dart';
import 'package:ghizlln/constants/textes.dart';
import 'package:ghizlln/constants/images.dart';
import 'package:ghizlln/constants/colors.dart';


import 'package:iconsax/iconsax.dart';
import 'signup_student_screen.dart';
import 'signup_teacher_screen.dart';
///import 'dart:io';
///import 'package:image_picker/image_picker.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();

}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Title
              Text(
                TTexts.create_Account,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                  /// Firstname and Lastname
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText:"firstname",
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "lastname",
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Username
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Username",

                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Email
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Iconsax.direct),
    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un email';
                      }
                   if (!value.contains('@')) {
                        return 'Email invalide';
                             }
                       return null;
  },
                    ),

                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Password
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// phone number
                  TextFormField(
                    obscureText: false ,
                    decoration: const InputDecoration(
                      labelText: "PhoneNumber",
                      prefixIcon: Icon(Iconsax.microphone),

                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwInputFields),



                
                /// Profile picture



                  const SizedBox(height: TSizes.spaceBtwSections),






                  /// Create Account Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {  if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupStudentScreen()),
                          );
                      }
                      },
                      child: const Text("Create Account"),
                    ),
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
            ],

          ),
        ),
      ),
    );
  }
}
