class BudgetModel {

  final String id;
  final String category;
  final double limit;


  BudgetModel({

    required this.id,

    required this.category,

    required this.limit,

  });



  factory BudgetModel.fromMap(
      Map<String,dynamic> map,
      String id
      ){

    return BudgetModel(

      id:id,

      category:map["category"],

      limit:
      (map["limit"] as num).toDouble(),

    );

  }



  Map<String,dynamic> toMap(){

    return {

      "category":category,

      "limit":limit,

    };

  }

}