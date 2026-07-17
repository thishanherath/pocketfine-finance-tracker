import 'package:flutter/material.dart';
import '../data/auth_service.dart';


class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();

}



class _RegisterScreenState extends State<RegisterScreen> {


  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();


  final AuthService authService = AuthService();


  bool isLoading = false;



  Future<void> register() async {


    setState(() {

      isLoading = true;

    });


    try {


      await authService.registerUser(

        name: nameController.text.trim(),

        email: emailController.text.trim(),

        password: passwordController.text.trim(),

      );


      if(mounted){

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text("Account created successfully"),

          ),

        );


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

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:40),



            TextField(

              controller:nameController,

              decoration:
              const InputDecoration(

                labelText:"Name",

                border:
                OutlineInputBorder(),

              ),

            ),


            const SizedBox(height:15),



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

            )


          ],

        ),

      ),

    );

  }


}