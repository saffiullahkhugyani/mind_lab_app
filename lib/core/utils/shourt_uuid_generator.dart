import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateShortUUID(String id) {
  var uuid = id; // Generate a standard UUID
  var bytes = utf8.encode(uuid); // Convert it to bytes
  var hash = sha256.convert(bytes); // Create a SHA-256 hash
  return hash.toString().substring(0, 5); // Return the first 8 characters
}
