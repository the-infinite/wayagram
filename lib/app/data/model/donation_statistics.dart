class DonationStatistics {
  DonationStatistics({
      this.totalDonates, 
      this.amountRaised,});

  DonationStatistics.fromJson(dynamic json) {
    totalDonates = json['totalDonates'];
    amountRaised = json['amountRaised'];
  }
  int? totalDonates;
  int? amountRaised;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalDonates'] = totalDonates;
    map['amountRaised'] = amountRaised;
    return map;
  }

}