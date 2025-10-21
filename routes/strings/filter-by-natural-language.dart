import 'package:dart_frog/dart_frog.dart';

import '../../repositories/strings.dart';
import '../../utils.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'status': 'error', 'message': 'Method not allowed'},
    );
  }

  final query = context.request.uri.queryParameters['query'];

  if (query == null || query.isEmpty) {
    return Response(statusCode: 400, body: 'Missing or empty query parameter');
  }

  final filters = query.parseNaturalLanguageQuery();

  if (filters == null) {
    return Response(
      statusCode: 400,
      body: 'Unable to parse natural language query',
    );
  }

  final result = context
      .read<StringRepo>()
      .naturalLanguageFilter(filters: filters, query: query);

  return Response.json(
    body: result,
  );
}
