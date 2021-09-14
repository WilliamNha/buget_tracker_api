class BudgetItem {
  List<Item>? itemList;
  BudgetItem({this.itemList});

  BudgetItem.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      itemList = <Item>[];
      json['results'].forEach((v) {
        itemList!.add(Item.fromMap(v));
      });
    } else {
      itemList = <Item>[];
    }
  }
}

class Item {
  final String? name;
  final String? category;
  final double? price;
  final DateTime? date;

  const Item({this.name, this.category, this.price, this.date});

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateStr = properties['Date']?['date']?['start'];
    return Item(
      name: properties['Name']?['title']?[0]?['plain_text'] ?? '?',
      category: properties['Category']?['select']?['name'] ?? 'Any',
      price: (properties['Price']?['number'] ?? 0).toDouble(),
      date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
    );
  }
}
