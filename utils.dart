import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';

extension StringAnalyzer on String {
  Map<String, dynamic>? parseNaturalLanguageQuery() {
    final query = this;

    final filters = <String, dynamic>{};

    if (query.contains('single word')) {
      filters['word_count'] = 1;
    }

    if (query.contains('palindromic')) {
      filters['is_palindrome'] = true;
    }

    final lengthMatch =
        RegExp(r'longer than (\d+) characters').firstMatch(query);
    if (lengthMatch != null) {
      filters['min_length'] = int.parse(lengthMatch.group(1)!);
    }

    final containsFirstVowel =
        RegExp('contain the first vowel').firstMatch(query);

    final containsMatch =
        RegExp('containing the letter ([a-zA-Z])').firstMatch(query);
    if (containsMatch != null || containsFirstVowel != null) {
      filters['contains_character'] =
          containsFirstVowel != null ? 'a' : containsMatch!.group(1);
    }

    return filters.isEmpty ? null : filters;
  }

  Map<String, dynamic> analyzeString() {
    final value = this;

    final length = value.length;
    final isPalindrome =
        value.toLowerCase() == value.toLowerCase().split('').reversed.join();
    final uniqueCharacters = value.split('').toSet().length;
    final wordCount = value.trim().split(RegExp(r'\s+')).length;
    final characterFrequencyMap = groupBy(value.split(''), (char) => char)
        .map((key, value) => MapEntry(key, value.length));

    return {
      'length': length,
      'is_palindrome': isPalindrome,
      'unique_characters': uniqueCharacters,
      'word_count': wordCount,
      'sha256_hash': sha256.convert(utf8.encode(value)).toString(),
      'character_frequency_map': characterFrequencyMap,
    };
  }
}
