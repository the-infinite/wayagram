
class Category {
  final int id;
  final String category;

  Category({required this.id, required this.category});
}

class State {
  final int id;
  final String state;

  State({required this.id, required this.state});
}

class Lga {
  final int id;
  final String lga;

  Lga({required this.id, required this.lga});
}


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

class  MultipleStage{
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
  Category(id: 1, category: 'All Categories'),
  Category(id: 2, category: 'Fashion'),
  Category(id: 3, category: 'Gaming'),
  Category(id: 4, category: 'Gadgets'),
  Category(id: 5, category: 'Electronics'),
  Category(id: 6, category: 'Jwelleries'),
  Category(id: 7, category: 'Food'),
];

List<State> states = [
  State(id: 1, state: 'All States'),
  State(id: 2, state: 'Lagos'),
  State(id: 3, state: 'Abuja'),
  State(id: 4, state: 'Ebonyi'),
  State(id: 5, state: 'Anambra'),
  State(id: 6, state: 'Ondo'),
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
  RequirementType(id: 2, requirementType: 'FILE'),

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
  Lga(id: 1, lga: 'All Lgas'),
  Lga(id: 1, lga: 'Surulere'),
  Lga(id: 1, lga: 'Agege'),
  Lga(id: 1, lga: 'Ikeja'),
  Lga(id: 1, lga: 'Badagry'),
];
