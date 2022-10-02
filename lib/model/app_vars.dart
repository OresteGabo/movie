import 'package:tmdb_api/tmdb_api.dart';

const String apikey = '04b719344104246bab9a7ee925a950ac';
const String readaccesstoken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNGI3MTkzNDQxMDQyNDZiYWI5YTdlZTkyNWE5NTBhYyIsInN1YiI6IjYzMzM3YTE2NjA4MmViMDA4ODNlM2NlYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gcSE4SYndJ4cbpQWW9QMWbKJ80Ij0MNkr8XTsMPp5IY';
TMDB tmdbWithCustomLogs = TMDB(
  defaultLanguage: 'fr',
  ApiKeys(apikey, readaccesstoken),
  logConfig: const ConfigLogger(
    showLogs: true,
    showErrorLogs: true,
  ),
);
