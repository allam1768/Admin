class WorkerModel {
  final int id;
  final String name;
  final String? email;
  final String role;
  final String? phoneNumber;
  final String? image;
  final String? rememberToken;
  final String createdAt;
  final String updatedAt;

  WorkerModel({
    required this.id,
    required this.name,
    this.email,
    required this.role,
    this.phoneNumber,
    this.image,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    // Debug logging untuk melihat data yang masuk
    print('=== PARSING WORKER MODEL ===');
    print('Raw JSON: $json');
    print('Email field: ${json['email']}');
    print('Email type: ${json['email'].runtimeType}');
    print('Email is null: ${json['email'] == null}');
    print('Email toString: "${json['email'].toString()}"');

    // PERBAIKAN: Parsing email dengan lebih robust
    String? emailValue;
    final emailFromJson = json['email'];

    if (emailFromJson != null) {
      String emailString = emailFromJson.toString().trim();
      if (emailString.isNotEmpty && emailString != 'null') {
        emailValue = emailString;
      }
    }

    // PERBAIKAN: Parsing phone number dengan lebih robust
    String? phoneValue;
    final phoneFromJson = json['phone_number'];

    if (phoneFromJson != null) {
      String phoneString = phoneFromJson.toString().trim();
      if (phoneString.isNotEmpty && phoneString != 'null') {
        phoneValue = phoneString;
      }
    }

    // PERBAIKAN: Parsing image dengan lebih robust
    String? imageValue;
    final imageFromJson = json['image'];

    if (imageFromJson != null) {
      String imageString = imageFromJson.toString().trim();
      if (imageString.isNotEmpty && imageString != 'null') {
        imageValue = imageString;
      }
    }

    print('Parsed email value: "$emailValue"');
    print('Parsed phone value: "$phoneValue"');
    print('Parsed image value: "$imageValue"');
    print('===============================');

    return WorkerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: emailValue, // Gunakan emailValue yang sudah di-parse
      role: json['role'] ?? 'worker',
      phoneNumber: phoneValue, // Gunakan phoneValue yang sudah di-parse
      image: imageValue, // Gunakan imageValue yang sudah di-parse
      rememberToken: json['remember_token']?.toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'image': image,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper method untuk mendapatkan email dengan fallback
  String get displayEmail {
    // Tambahkan debug print untuk melihat nilai email
    print('Email in displayEmail getter: "$email"');
    
    if (email != null && email!.isNotEmpty) {
      return email!;
    }
    return 'Email tidak tersedia';
  }

  // Helper method untuk check apakah email valid
  bool get hasValidEmail {
    return email != null && email!.isNotEmpty && email!.contains('@');
  }

  // TAMBAHAN: Helper method untuk mendapatkan phone number dengan fallback
  String get displayPhoneNumber {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      return phoneNumber!;
    }
    return 'Phone tidak tersedia';
  }

  // TAMBAHAN: Helper method untuk check apakah phone number valid
  bool get hasValidPhoneNumber {
    return phoneNumber != null && phoneNumber!.isNotEmpty;
  }

  // TAMBAHAN: Helper method untuk mendapatkan image URL lengkap
  String? get fullImageUrl {
    if (image != null && image!.isNotEmpty) {
      if (image!.startsWith('http')) {
        return image;
      } else {
        return 'https://hamatech.rplrus.com/storage/$image';
      }
    }
    return null;
  }

  // TAMBAHAN: Helper method untuk copy dengan perubahan
  WorkerModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
    String? image,
    String? rememberToken,
    String? createdAt,
    String? updatedAt,
  }) {
    return WorkerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      rememberToken: rememberToken ?? this.rememberToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'WorkerModel(id: $id, name: $name, email: $email, role: $role, phoneNumber: $phoneNumber, image: $image)';
  }
}