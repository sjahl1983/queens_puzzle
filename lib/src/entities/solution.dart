class Solution {
  int id;
  int size;
  DateTime createdDate;

  Solution({this.id, this.size, this.createdDate}) {
    if (createdDate == null) {
      createdDate = DateTime.now();
    }
  }

  Map<String, dynamic> toMap() =>
      {'id': id, 'size': size, 'createdDate': createdDate.toIso8601String()};

  factory Solution.fromMap(Map<String, dynamic> json) => new Solution(
      id: json['id'],
      size: json['size'],
      createdDate: DateTime.parse(json['createdDate']));
}
