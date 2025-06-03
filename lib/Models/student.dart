class Student {
  String id;
  String name;
  String contactNo;
  String classNo;
  Map<String, bool> subjects;
  int feePerSubject;
  int totalFees;
  bool? isPresent;

  Student(
      {required this.id,
      required this.name,
      required this.contactNo,
      required this.classNo,
      required this.subjects,
      required this.feePerSubject,
      required this.totalFees,
      this.isPresent});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'] ?? '',
      contactNo: json['contactNo'] ?? '',
      classNo: json['classNo'] ?? '',
      subjects: (json['subjects'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, value as bool)),
      feePerSubject: json['feePerSubject'] ?? 0,
      totalFees: json['totalFees'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactNo': contactNo,
      'classNo': classNo,
      'subjects': subjects,
      'feePerSubject': feePerSubject,
      'totalFees': totalFees,
    };
  }
}
