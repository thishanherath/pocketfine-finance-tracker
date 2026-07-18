import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/budget_service.dart';


class AddBudgetScreen extends StatefulWidget {

  const AddBudgetScreen({super.key});


  @override
  State<AddBudgetScreen> createState() =>
      _AddBudgetScreenState();

}



class _AddBudgetScreenState
    extends State<AddBudgetScreen> {


  final BudgetService budgetService =
      BudgetService();


  final limitController =
      TextEditingController();


  String selectedCategory = "Food";


  bool loading = false;



  final categories = [

    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Education",
    "Health",
    "Entertainment",
    "Other"

  ];



  Future<void> saveBudget() async {


    if(limitController.text.isEmpty){
      return;
    }


    setState(() {

      loading = true;

    });



    await budgetService.addBudget(

      category: selectedCategory,

      limit: double.parse(
        limitController.text,
      ),

    );


    if(!mounted) return;


    context.pop();



  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Add Budget",
        ),

      ),


      body: Padding(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          children: [


            DropdownButtonFormField<String>(

              value:selectedCategory,


              decoration:
              const InputDecoration(

                labelText:"Category",

                border:
                OutlineInputBorder(),

              ),


              items:
              categories.map(

                (category){

                  return DropdownMenuItem(

                    value:category,

                    child:
                    Text(category),

                  );

                },

              ).toList(),


              onChanged:(value){

                setState(() {

                  selectedCategory =
                      value!;

                });

              },

            ),


            const SizedBox(height:20),



            TextField(

              controller:
              limitController,


              keyboardType:
              TextInputType.number,


              decoration:
              const InputDecoration(

                labelText:
                "Budget Limit",

                prefixText:
                "Rs ",

                border:
                OutlineInputBorder(),

              ),

            ),



            const SizedBox(height:30),



            SizedBox(

              width:
              double.infinity,


              height:50,


              child:
              ElevatedButton(

                onPressed:
                loading
                    ? null
                    : saveBudget,


                child:
                loading

                    ? const CircularProgressIndicator()

                    : const Text(
                  "Save Budget",
                ),

              ),

            )


          ],

        ),

      ),

    );

  }

}