import 'package:dart_frog/dart_frog.dart';

import '../../repositories/strings.dart';

final _repo = StringRepo();

Handler middleware(Handler handler) {
  print('Storage:${_repo.storage.length}');

  return handler.use(requestLogger()).use(factRepo());
}

Middleware factRepo() {
  return provider<StringRepo>((context) => _repo);
}
