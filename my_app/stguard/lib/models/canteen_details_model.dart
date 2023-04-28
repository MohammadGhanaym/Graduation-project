class CanteenDetailsModel {
   dynamic dailyRevenue;
   dynamic dailyTransactions;
   DateTime? updateTime;

  CanteenDetailsModel({
    required this.dailyRevenue,
    required this.dailyTransactions,
    required this.updateTime,
  });

  CanteenDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      if(json.containsKey('daily revenue'))
      {
        dailyRevenue = json['daily revenue'];
      }
      
if(json.containsKey('daily transactions'))
      {
        dailyTransactions = json['daily transactions'];
      }
      if(json.containsKey('updateTime'))
      {
        updateTime = json['updateTime'].toDate();
      }

    }
  }
}
