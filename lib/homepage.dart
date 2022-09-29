import 'package:flutter/material.dart';
import 'package:movie_app/widgets/trending.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The movie app',
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
  List trendingmovies = [];
  final String apikey = '04b719344104246bab9a7ee925a950ac';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNGI3MTkzNDQxMDQyNDZiYWI5YTdlZTkyNWE5NTBhYyIsInN1YiI6IjYzMzM3YTE2NjA4MmViMDA4ODNlM2NlYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gcSE4SYndJ4cbpQWW9QMWbKJ80Ij0MNkr8XTsMPp5IY';

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  var genresMovies;
  var genresTv;

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      defaultLanguage: 'fr',
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    ///Trending result conatins movies and Tv shows, to get the genres, we need to consider both movies genres and Tv genres
    Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending();

    Map genresResultsMovies = await tmdbWithCustomLogs.v3.genres.getMovieList();
    Map genresResultsTv = await tmdbWithCustomLogs.v3.genres.getTvlist();

    genresMovies = genresResultsMovies['genres'] as List;
    genresTv = genresResultsTv['genres'] as List;

    setState(() {
      trendingmovies = trendingresult['results'];

      ///Au cas ou l'API nous donne un tableau de plus de 10 films, on reduis la liste à 10
      if (trendingmovies.length > 10) {
        trendingmovies.removeRange(10, trendingmovies.length);
      }
      print('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TrendingMovies(
        genresMovies: genresMovies,
        genresTv: genresTv,
        trending: trendingmovies,
      ),
    );
  }
}
