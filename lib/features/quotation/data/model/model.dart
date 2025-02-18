class Category {
  final String id;
  final String category;

  Category({required this.id, required this.category});
}

class State {
  final String id;
  final String state;

  State({required this.id, required this.state});
}

class ProductCondition {
  final String id;
  final String productCondition;

  ProductCondition({required this.id, required this.productCondition});
}

class Lga {
  final String id;
  final String lga;

  Lga({required this.id, required this.lga});
}

class BidTime {
  final String id;
  final String bidTime;

  BidTime({required this.id, required this.bidTime});
}

List<BidTime> bidTimes = [
  BidTime(id: 'Start now', bidTime: 'Start now'),
  BidTime(id: 'Start later', bidTime: 'Start later'),
  /* BidTime(id: '3 hours', bidTime: '3 hours'),
  BidTime(id: '4 hours', bidTime: '4 hours'),
  BidTime(id: '5 hours', bidTime: '5 hours'),
  BidTime(id: '6 hours', bidTime: '6 hours'),
  BidTime(id: '7 hours', bidTime: '7 hours'),
  BidTime(id: '8 hours', bidTime: '8 hours'),
  BidTime(id: '9 hours', bidTime: '9 hours'),
  BidTime(id: '10 hours', bidTime: '10 hours'),
  BidTime(id: '11 hours', bidTime: '11 hours'),
  BidTime(id: '12 hours', bidTime: '12 hours'),*/
];

class PaymentType {
  final int id;
  final String paymentType;

  PaymentType({required this.id, required this.paymentType});
}

class DurationType {
  final int id;
  final String durationType;

  DurationType({required this.id, required this.durationType});
}

class MultipleStage {
  final int id;
  final String multipleStage;

  MultipleStage({required this.id, required this.multipleStage});
}

class CurrentStage {
  final int id;
  final String currentStage;

  CurrentStage({required this.id, required this.currentStage});
}

class WinnerPrize {
  final int id;
  final String winnerPrize;

  WinnerPrize({required this.id, required this.winnerPrize});
}

class RequirementType {
  final int id;
  final String requirementType;

  RequirementType({required this.id, required this.requirementType});
}

class UgtCategoryState {
  final int id;
  final String ugtCategoryState;

  UgtCategoryState({required this.id, required this.ugtCategoryState});
}

List<Category> categories = [
  Category(id: 'Furniture', category: 'Furniture'),
  Category(id: 'Fashion', category: 'Fashion'),
  Category(id: 'Gaming', category: 'Gaming'),
  Category(id: 'Gadgets', category: 'Gadgets'),
  Category(id: 'Electronics', category: 'Electronics'),
  Category(id: 'Jewelleries', category: 'Jewelleries'),
  Category(id: 'Food', category: 'Food'),
];

List<ProductCondition> productConditions = [
  ProductCondition(id: 'New', productCondition: 'New'),
  //ProductCondition(id: 'Fairly used', productCondition: 'Fairly used'),
];

List<State> states = [
  State(id: "1", state: 'All States'),
  State(id: "2", state: 'Lagos'),
  State(id: "3", state: 'Abuja'),
  State(id: "4", state: 'Ebonyi'),
  State(id: "5", state: 'Anambra'),
  State(id: "6", state: 'Ondo'),
];

List<UgtCategoryState> ugtCategoryStates = [
  UgtCategoryState(id: 1, ugtCategoryState: 'America  talent'),
  UgtCategoryState(id: 2, ugtCategoryState: 'America  talent'),
  UgtCategoryState(id: 3, ugtCategoryState: 'New talent'),
  UgtCategoryState(id: 4, ugtCategoryState: 'Nigeria talent'),
  UgtCategoryState(id: 5, ugtCategoryState: 'Nigeria talent'),
];

List<PaymentType> paymentTypes = [
  PaymentType(id: 1, paymentType: 'Free'),
  PaymentType(id: 2, paymentType: 'Paid'),
];

List<RequirementType> requirementTypes = [
  RequirementType(id: 1, requirementType: 'TEXT'),
  RequirementType(id: 2, requirementType: 'Document'),
];

List<DurationType> durationTypes = [
  DurationType(id: 1, durationType: 'Weeks'),
  DurationType(id: 2, durationType: 'Months'),
];

List<MultipleStage> multipleStages = [
  MultipleStage(id: 1, multipleStage: 'Yes'),
  MultipleStage(id: 2, multipleStage: 'No'),
];

List<CurrentStage> currentStages = [
  CurrentStage(id: 1, currentStage: 'Stage 1'),
  CurrentStage(id: 2, currentStage: 'null'),
];

List<WinnerPrize> winnerPrizes = [
  WinnerPrize(id: 1, winnerPrize: 'Yes'),
  WinnerPrize(id: 2, winnerPrize: 'No'),
];

List<Lga> lgas = [
  Lga(id: 'Badagry', lga: 'Badagry'),
  Lga(id: 'Surulere', lga: 'Surulere'),
  Lga(id: 'Agege', lga: 'Agege'),
  Lga(id: 'Ikeja', lga: 'Ikeja'),
];
