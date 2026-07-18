import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class ExpenseChart extends StatelessWidget {

  final double food;
  final double transport;
  final double shopping;
  final double bills;
  final double other;


  const ExpenseChart({

    super.key,

    required this.food,
    required this.transport,
    required this.shopping,
    required this.bills,
    required this.other,

  });



  @override
  Widget build(BuildContext context) {


    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,


      children: [


        const Text(

          "Expense Analytics",

          style: TextStyle(

            fontSize:22,

            fontWeight:
            FontWeight.bold,

          ),

        ),


        const SizedBox(height:20),



        SizedBox(

          height:250,


          child: PieChart(

            PieChartData(

              sectionsSpace: 3,


              centerSpaceRadius:40,


              sections: [

                _section(
                  food,
                  "Food",
                ),


                _section(
                  transport,
                  "Transport",
                ),


                _section(
                  shopping,
                  "Shopping",
                ),


                _section(
                  bills,
                  "Bills",
                ),


                _section(
                  other,
                  "Other",
                ),

              ],


            ),

          ),

        ),

      ],

    );

  }





  PieChartSectionData _section(

      double value,

      String title,

      ){


    return PieChartSectionData(

      value:value,

      title:
      title,


      radius:80,


      titleStyle:
      const TextStyle(

        fontSize:12,

        fontWeight:
        FontWeight.bold,

      ),

    );

  }


}