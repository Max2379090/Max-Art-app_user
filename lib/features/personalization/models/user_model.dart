import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/formatters/formatter.dart';
import '../../shop/models/cart_model.dart';
import 'address_model.dart';

/// Model class representing user data.
class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;
  String usergender;
  String dateOfBirth;
  String profilePicture;
  String city; // Added City field
  final CartModel? cart;
  final List<AddressModel>? addresses;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.usergender,
    required this.profilePicture,
    required this.dateOfBirth,
    required this.city, // Added city to constructor
    this.cart,
    this.addresses,
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(String fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    return "Max_$firstName$lastName"; // Add "Max_" prefix
  }

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    phoneNumber: '',
    profilePicture: '',
    usergender: '',
    dateOfBirth: '',
    city: '', // Added empty city field
  );

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'UserGender': usergender, // Fixed field name
      'PhoneNumber': phoneNumber,
      'DateOfBirth': dateOfBirth,
      'ProfilePicture': profilePicture,
      'City': city, // Added city to Firebase
      'Role': role.name, // Ensure role is stored as a string
      'CreatedAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'UpdatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        usergender: data['UserGender'] ?? '', // Fixed to match `toJson`
        profilePicture: data['ProfilePicture'] ?? '',
        dateOfBirth: data['DateOfBirth'] ?? '',
        city: data['City'] ?? '', // Fetch city from Firebase
        createdAt: (data['CreatedAt'] as Timestamp?)?.toDate(),
        updatedAt: (data['UpdatedAt'] as Timestamp?)?.toDate(),
      );
    } else {
      return UserModel.empty();
    }
  }
}
