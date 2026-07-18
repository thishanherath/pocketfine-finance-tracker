import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {


  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();


  bool isLoading = false;



  Future<void> register() async {


    setState(() {

      isLoading = true;

    });


    try {

      await ref.read(authRepositoryProvider).registerUser(

        name: nameController.text.trim(),

        email: emailController.text.trim(),

        password: passwordController.text.trim(),

      );


      if(mounted){
        context.go('/dashboard');
      }



    }catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(e.toString()),

        ),

      );


    }


    setState(() {

      isLoading = false;

    });


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Padding(

        padding:
        const EdgeInsets.all(24),


        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [


            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign up to start tracking your expenses",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),



            const SizedBox(height:40),



            TextField(

              controller:nameController,

              decoration: const InputDecoration(
                labelText:"Name",
              ),

            ),


            const SizedBox(height:15),



            TextField(

              controller:
              emailController,


              decoration: const InputDecoration(
                labelText:"Email",
              ),

            ),



            const SizedBox(height:15),



            TextField(

              controller:
              passwordController,


              obscureText:true,


              decoration: const InputDecoration(
                labelText:"Password",
              ),

            ),



            const SizedBox(height:25),



            SizedBox(

              width:
              double.infinity,


              height:50,


              child:
              ElevatedButton(


                onPressed:
                isLoading
                    ? null
                    : register,


                child:
                isLoading

                    ?

                const CircularProgressIndicator()

                    :

                const Text(
                  "Register",
                ),


              ),

            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],

        ),

      ),

    );

  }


}