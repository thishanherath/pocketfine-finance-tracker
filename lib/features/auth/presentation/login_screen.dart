import 'package:flutter/material.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/presentation/dashboard_screen.dart';
import '../data/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();


  final AuthService authService =
      AuthService();


  bool isLoading = false;



  Future<void> login() async {


    setState(() {

      isLoading = true;

    });


    try {


      await authService.loginUser(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),

      );


      if(mounted){

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(

            builder: (_) => DashboardScreen(),

          ),

        );

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

                fontSize:32,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:40),



            TextField(

              controller:
              emailController,


              decoration:
              const InputDecoration(

                labelText:"Email",

                border:
                OutlineInputBorder(),

              ),

            ),



            const SizedBox(height:15),



            TextField(

              controller:
              passwordController,


              obscureText:true,


              decoration:
              const InputDecoration(

                labelText:"Password",

                border:
                OutlineInputBorder(),

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

            )

          ],

        ),

      ),

    );

  }

}