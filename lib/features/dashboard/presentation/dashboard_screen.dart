import 'package:flutter/material.dart';
import 'package:pocketfine_finance_tracker/features/transactions/presentation/add_transaction_screen.dart';


class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "PockeFine",
        ),

        actions: [

          IconButton(

            icon:
            const Icon(Icons.logout),

            onPressed: () {},

          )

        ],

      ),


      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            const Text(

              "Good Morning 👋",

              style:
              TextStyle(

                fontSize:26,

                fontWeight:
                FontWeight.bold,

              ),

            ),


            const SizedBox(height:20),



            _balanceCard(),



            const SizedBox(height:20),



            Row(

              children: [

                Expanded(

                  child:
                  _moneyCard(

                    title:"Income",

                    amount:"+ Rs 200,000",

                    icon:
                    Icons.arrow_downward,

                  ),

                ),


                const SizedBox(width:15),


                Expanded(

                  child:
                  _moneyCard(

                    title:"Expense",

                    amount:"- Rs 50,000",

                    icon:
                    Icons.arrow_upward,

                  ),

                ),

              ],

            ),



            const SizedBox(height:30),



            const Text(

              "Recent Transactions",

              style:
              TextStyle(

                fontSize:22,

                fontWeight:
                FontWeight.bold,

              ),

            ),


            const SizedBox(height:15),



            _transactionTile(
                "Salary",
                "+ Rs 150,000",
                Icons.work),


            _transactionTile(
                "Food",
                "- Rs 2,500",
                Icons.restaurant),


            _transactionTile(
                "Transport",
                "- Rs 1,000",
                Icons.directions_car),


          ],

        ),

      ),



      floatingActionButton:

      FloatingActionButton(

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                const AddTransactionScreen(),
      ),
    );
        },

        child:
        const Icon(Icons.add),

      ),

    );

  }





  Widget _balanceCard(){

    return Container(

      width:
      double.infinity,


      padding:
      const EdgeInsets.all(25),


      decoration:
      BoxDecoration(

        color:
        Colors.green,


        borderRadius:
        BorderRadius.circular(20),

      ),


      child:
      const Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [

          Text(

            "Current Balance",

            style:
            TextStyle(

              color:
              Colors.white,

            ),

          ),


          SizedBox(height:10),


          Text(

            "Rs 150,000",

            style:
            TextStyle(

              color:
              Colors.white,

              fontSize:32,

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }




  Widget _moneyCard({

    required String title,

    required String amount,

    required IconData icon,

  }){


    return Container(

      padding:
      const EdgeInsets.all(18),


      decoration:
      BoxDecoration(

        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(15),

      ),


      child:
      Column(

        children: [


          Icon(icon),


          const SizedBox(height:10),


          Text(title),


          const SizedBox(height:5),


          Text(

            amount,

            style:
            const TextStyle(

              fontWeight:
              FontWeight.bold,

            ),

          )

        ],

      ),

    );

  }




  Widget _transactionTile(

      String title,

      String amount,

      IconData icon

      ){


    return Card(

      child:
      ListTile(

        leading:
        CircleAvatar(

          child:
          Icon(icon),

        ),


        title:
        Text(title),


        trailing:
        Text(

          amount,

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),

    );

  }


}