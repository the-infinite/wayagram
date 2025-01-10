
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
  State(id: 1, state: 'Lagos'),
  State(id: 1, state: 'Abuja'),
  State(id: 1, state: 'Ebonyi'),
  State(id: 1, state: 'Anambra'),
  State(id: 1, state: 'Ondo'),
];

List<Lga> lgas = [
  Lga(id: 1, lga: 'All Lgas'),
  Lga(id: 1, lga: 'Surulere'),
  Lga(id: 1, lga: 'Agege'),
  Lga(id: 1, lga: 'Ikeja'),
  Lga(id: 1, lga: 'Badagry'),
];
