import 'package:flutter/material.dart';
import 'package:movie_app/widgets/trending.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movie_app/model/app_vars.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'The movie app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      defaultLanguage: 'fr',
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    /*
      Trending has a mediaType set to all (MediaType.all), i teams the data may concerns Tv shows, and or movies and persons


      in our case, we will only need movies [Madiatype.movie] and tv shows [MediaType.tv], by precising it in the parameter to avoid the MediaType.person from being returned
      to get the genres, we need to consider both genres from both sources
      getTrending() has language 'fr', from the default language set in TMDB
      TMDB object created above in loadMovies function[tmdbWithCustomLogs]
    */

    Map trendingresult = await tmdbWithCustomLogs.v3.trending
        .getTrending(mediaType: MediaType.movie);

    setState(() {
      movies = trendingresult['results'];
    });

    ///API may return a very big list of Movies, we this will help to reduce and only keep the first 10
    if (movies.length > 10) {
      setState(() {
        movies.removeRange(10, movies.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrendingMovies(
        movies: movies,
      ),
    );
  }
}
