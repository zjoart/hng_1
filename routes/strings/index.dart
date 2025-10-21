import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../repositories/strings.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _handlePost(context);
  }

  if (context.request.method == HttpMethod.get) {}
  //   final pathSegments = context.request.uri.pathSegments;
  //   if (pathSegments.isEmpty) {
  //     return _handleGetAll(context);
  //   } else if (pathSegments.length == 2 && pathSegments[0] == 'strings') {
  //     return _handleGet(pathSegments[1]);
  //   } else if (pathSegments.length == 1 &&
  //       pathSegments[0] == 'filter-by-natural-language') {
  //     return _handleNaturalLanguageFilter(context);
  //   }
  // } else if (context.request.method == HttpMethod.delete) {
  //   final pathSegments = context.request.uri.pathSegments;
  //   if (pathSegments.length == 2 && pathSegments[0] == 'strings') {
  //     return _handleDelete(pathSegments[1]);
  //   }
  // }

  return Response(statusCode: 405, body: 'Method Not Allowed');
}

Future<Response> _handlePost(RequestContext context) async {
  try {
    final body = await context.request.body();

    final data = jsonDecode(body) as Map<String, dynamic>;

    if (data case {'value': final String value}) {
      final result = context.read<StringRepo>().analyze(value: value);
      return Response.json(statusCode: result.code, body: result.data);
    }
    if (data['value'] == null) {
      throw ArgumentError.notNull();
    }

    return Response(
      statusCode: 422,
      body: 'Invalid data type for "value" (must be string)',
    );
  } catch (e) {
    return Response(
      statusCode: 400,
      body: 'Invalid request body or missing "value" field',
    );
  }
}

// Response _handleGet(String stringValue) {
//   final id = sha256.convert(utf8.encode(stringValue)).toString();
//   final entry = _storage[id];

//   if (entry == null) {
//     return Response(statusCode: 404, body: 'String not found');
//   }

//   return Response.json(body: entry);
// }

// Response _handleGetAll(RequestContext context) {
//   final queryParams = context.request.uri.queryParameters;

//   bool? isPalindrome;
//   if (queryParams.containsKey('is_palindrome')) {
//     isPalindrome = queryParams['is_palindrome'] == 'true';
//   }

//   int? minLength;
//   if (queryParams.containsKey('min_length')) {
//     minLength = int.tryParse(queryParams['min_length']!);
//   }

//   int? maxLength;
//   if (queryParams.containsKey('max_length')) {
//     maxLength = int.tryParse(queryParams['max_length']!);
//   }

//   int? wordCount;
//   if (queryParams.containsKey('word_count')) {
//     wordCount = int.tryParse(queryParams['word_count']!);
//   }

//   String? containsCharacter;
//   if (queryParams.containsKey('contains_character')) {
//     containsCharacter = queryParams['contains_character'];
//   }

//   final filteredData = _storage.values.where((entry) {
//     final properties = entry['properties'] as Map<String, dynamic>;

//     if (isPalindrome != null &&
//         (properties['is_palindrome'] as bool) != isPalindrome) {
//       return false;
//     }

//     if (minLength != null && (properties['length'] as int) < minLength) {
//       return false;
//     }

//     if (maxLength != null && (properties['length'] as int) > maxLength) {
//       return false;
//     }

//     if (wordCount != null && (properties['word_count'] as int) != wordCount) {
//       return false;
//     }

//     if (containsCharacter != null &&
//         !(entry['value'] as String).contains(containsCharacter)) {
//       return false;
//     }

//     return true;
//   }).toList();

//   return Response.json(
//     body: {
//       'data': filteredData,
//       'count': filteredData.length,
//       'filters_applied': queryParams,
//     },
//   );
// }

// Response _handleDelete(String stringValue) {
//   final id = sha256.convert(utf8.encode(stringValue)).toString();
//   if (!_storage.containsKey(id)) {
//     return Response(statusCode: 404, body: 'String not found');
//   }

//   _storage.remove(id);
//   return Response(statusCode: 204);
// }
