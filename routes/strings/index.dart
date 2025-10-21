import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../repositories/strings.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _handlePost(context);
  }

  if (context.request.method == HttpMethod.get) {
    final queryParams = context.request.uri.queryParameters;

    if (queryParams.isEmpty) {
      return Response(
        statusCode: 400,
        body: 'Invalid query parameter values or types',
      );
    }

    final result =
        context.read<StringRepo>().getAllByFilter(queryParams: queryParams);

    return Response.json(
      body: result.data,
      statusCode: result.code,
    );
  }

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
