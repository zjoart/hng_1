import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../utils.dart';

class StringRepo {
  Map<String, Map<String, dynamic>> get storage => _storage;

  static final _storage = <String, Map<String, dynamic>>{};

  ({dynamic data, int code}) analyze({
    required String value,
  }) {
    final id = sha256.convert(utf8.encode(value)).toString();

    if (_storage.containsKey(id)) {
      return (
        code: 409,
        data: 'String already exists in the system',
      );
    }

    final properties = value.analyzeString();

    final entry = {
      'id': id,
      'value': value,
      'properties': properties,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };

    _storage[id] = entry;

    return (
      code: 201,
      data: entry,
    );
  }

  ({dynamic data, int code}) getByValue({required String value}) {
    final id = sha256.convert(utf8.encode(value)).toString();
    final entry = _storage[id];

    if (entry == null) {
      return (code: 404, data: 'String does not exist in the system');
    }

    return (code: HttpStatus.ok, data: entry);
  }

  ({dynamic data, int code}) getAllByFilter({
    required Map<String, String> queryParams,
  }) {
    final isPalindrome = bool.tryParse("${queryParams['is_palindrome']}");

    final minLength = int.tryParse("${queryParams['min_length']}");
    final maxLength = int.tryParse("${queryParams['max_length']}");
    final wordCount = int.tryParse("${queryParams['word_count']}");

    final containsCharacter = queryParams['contains_character'];

    if (isPalindrome == null &&
        minLength == null &&
        maxLength == null &&
        wordCount == null &&
        containsCharacter == null) {
      return (code: 400, data: 'Invalid query parameter values or types');
    }

    if (containsCharacter != null && containsCharacter.length > 1) {
      return (code: 400, data: 'Invalid query parameter values or types');
    }

    final filteredData = _storage.values.where((entry) {
      final properties = entry['properties'] as Map<String, dynamic>;

      if (isPalindrome != null &&
          (properties['is_palindrome'] as bool) != isPalindrome) {
        return false;
      }

      if (minLength != null && (properties['length'] as int) < minLength) {
        return false;
      }

      if (maxLength != null && (properties['length'] as int) > maxLength) {
        return false;
      }

      if (wordCount != null && (properties['word_count'] as int) != wordCount) {
        return false;
      }

      if (containsCharacter != null &&
          !(entry['value'] as String).contains(containsCharacter)) {
        return false;
      }

      return true;
    }).toList();

    return (
      code: HttpStatus.ok,
      data: {
        'data': filteredData,
        'count': filteredData.length,
        'filters_applied': queryParams,
      },
    );
  }

  Map<String, dynamic> naturalLanguageFilter({
    required Map<String, dynamic> filters,
    required String query,
  }) {
    final filteredData = _storage.values.where((entry) {
      final properties = entry['properties'] as Map<String, dynamic>;

      if (filters['is_palindrome'] != null &&
          (properties['is_palindrome'] as bool) != filters['is_palindrome']) {
        return false;
      }

      if (filters['min_length'] != null &&
          (properties['length'] as int) < (filters['min_length'] as int)) {
        return false;
      }

      if (filters['max_length'] != null &&
          (properties['length'] as int) > (filters['max_length'] as int)) {
        return false;
      }

      if (filters['word_count'] != null &&
          (properties['word_count'] as int) != (filters['word_count'] as int)) {
        return false;
      }

      if (filters['contains_character'] != null &&
          !(entry['value'] as String)
              .contains(filters['contains_character'] as String)) {
        return false;
      }

      return true;
    }).toList();

    return {
      'data': filteredData,
      'count': filteredData.length,
      'interpreted_query': {
        'original': query,
        'parsed_filters': filters,
      },
    };
  }

  ({dynamic data, int code}) delete({required String value}) {
    final id = sha256.convert(utf8.encode(value)).toString();

    if (!_storage.containsKey(id)) {
      return (code: 404, data: 'String does not exist in the system');
    }

    _storage.remove(id);

    return (
      code: 204,
      data: null,
    );
  }
}
