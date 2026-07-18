import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class MonthlyChart extends StatelessWidget {

  final double income;
  final double expense;


  const MonthlyChart({

    super.key,

    required this.income,

    required this.expense,

  });



  @override
  Widget build(BuildContext context) {


    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,


      children: [


        const Text(

          "Monthly Overview",

          style: TextStyle(

            fontSize:22,

            fontWeight:
            FontWeight.bold,

          ),

        ),


        const SizedBox(height:20),


        SizedBox(

          height:250,


          child: BarChart(

            BarChartData(

              alignment:
              BarChartAlignment.spaceAround,


              maxY:
              income > expense
                  ? income
                  : expense,


              barGroups: [


                BarChartGroupData(

                  x:0,

                  barRods: [

                    BarChartRodData(

                      toY: income,

                      width:25,

                    ),

                  ],

                ),



                BarChartGroupData(

                  x:1,

                  barRods: [

                    BarChartRodData(

                      toY: expense,

                      width:25,

                    ),

                  ],

                ),

              ],



              titlesData:
              FlTitlesData(

                bottomTitles:

                AxisTitles(

                  sideTitles:

                  SideTitles(

                    showTitles:true,


                    getTitlesWidget:
                    (value, meta){

                      if(value==0){

                        return const Text(
                          "Income",
                        );

                      }


                      return const Text(
                        "Expense",
                      );

                    },

                  ),

                ),

              ),


            ),

          ),

        ),


      ],

    );

  }

}