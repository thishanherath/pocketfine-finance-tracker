import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();



  bool isLoading = false;



  Future<void> login() async {


    setState(() {

      isLoading = true;

    });


    try {


      await ref.read(authRepositoryProvider).loginUser(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),

      );


      if(mounted){

        context.go('/dashboard');

      }


    } catch(e){


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
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign in to continue managing your finances",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),



            const SizedBox(height:40),



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


              child: ElevatedButton(


                onPressed:
                isLoading
                    ? null
                    : login,


                child:

                isLoading

                    ?

                const CircularProgressIndicator()

                    :

                const Text(
                  "Login"
                ),


              ),

            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.push('/register');
              },
              child: const Text(
                "Don't have an account? Register",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],

        ),

      ),

    );

  }

}