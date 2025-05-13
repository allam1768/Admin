class ClientModel {
  final int id;
  final String name;
  final String? company;
  final String? image;

  ClientModel({
    required this.id,
    required this.name,
    this.company,
    this.image,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'] ?? '-',
      company: json['name_company'],
      image: json['image'],
    );
  }
}
