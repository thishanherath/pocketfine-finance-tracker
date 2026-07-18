import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/budget_service.dart';
import '../../transactions/data/transaction_repository.dart';
import 'package:go_router/go_router.dart';

class BudgetScreen extends ConsumerWidget {
  BudgetScreen({super.key});


  final BudgetService budgetService =
      BudgetService();




  double calculateSpent(
      String category,
      List<QueryDocumentSnapshot<Map<String,dynamic>>> transactions,
      ){

    double total = 0;


    for(var transaction in transactions){

      final data = transaction.data();


      if(
      data["type"] == "expense" &&
          data["category"] == category
      ){

        total +=
        (data["amount"] as num)
            .toDouble();

      }

    }


    return total;

  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Budgets",
        ),

      ),



      floatingActionButton:
      FloatingActionButton(

        onPressed: (){
          context.push('/add-budget');
        },


        child:
        const Icon(
          Icons.add,
        ),

      ),



      body:

      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(

        stream:
        budgetService.getBudgets(),


        builder:(context,budgetSnapshot){


          if(!budgetSnapshot.hasData){

            return const Center(

              child:
              CircularProgressIndicator(),

            );

          }


          final budgets =
              budgetSnapshot.data!.docs;



          return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(

            stream:
            ref.read(transactionRepositoryProvider).getTransactions(),


            builder:(context,transactionSnapshot){


              if(!transactionSnapshot.hasData){

                return const Center(

                  child:
                  CircularProgressIndicator(),

                );

              }



              final transactions =
                  transactionSnapshot.data!.docs;



              if(budgets.isEmpty){

                return const Center(

                  child:
                  Text(
                    "No budgets created",
                  ),

                );

              }



              return ListView.builder(

                padding:
                const EdgeInsets.all(20),


                itemCount:
                budgets.length,


                itemBuilder:(context,index){



                  final budget =
                  budgets[index].data();



                  final category =
                  budget["category"];



                  final limit =
                  (budget["limit"] as num)
                      .toDouble();



                  final spent =
                  calculateSpent(
                    category,
                    transactions,
                  );



                  final progress =
                  limit == 0
                      ? 0
                      :
                  spent / limit;



                  return Card(

                    child:
                    Padding(

                      padding:
                      const EdgeInsets.all(20),


                      child:
                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [



                          Text(

                            category,

                            style:
                            const TextStyle(

                              fontSize:20,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),



                          const SizedBox(height:10),



                          Text(
                            "Limit: Rs ${limit.toStringAsFixed(0)}",
                          ),


                          Text(
                            "Spent: Rs ${spent.toStringAsFixed(0)}",
                          ),



                          const SizedBox(height:10),



                          LinearProgressIndicator(

                            value: progress > 1
                                ? 1.0
                                : progress.toDouble(),

                          ),



                          const SizedBox(height:10),



                          Text(

                            "Remaining: Rs ${(limit-spent).toStringAsFixed(0)}",

                          ),



                          if(spent > limit)

                            const Text(

                              "⚠ Budget exceeded",

                              style:
                              TextStyle(

                                color:
                                Colors.red,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            )


                        ],

                      ),

                    ),

                  );


                },

              );



            },


          );


        },


      ),

    );

  }


}