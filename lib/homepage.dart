import 'package:flutter/material.dart';
import 'package:movie_app/widgets/trending.dart';
import 'package:tmdb_api/tmdb_api.dart';

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
    loadMovies();
  }

  var genresMovies;

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

    /// Getting the genres of when MediaType is movie
    /// It returns an Associative table (Map) named genres, with id and its associated name
    /// sample example of the returned table
    /// {
    ///    "genres":[
    ///       {
    ///          "id":28,
    ///          "name":"Action"
    ///       },
    ///       {
    ///          "id":12,
    ///          "name":"Aventure"
    ///       }
    ///    ]
    /// }
    Map genresResultsMovies = await tmdbWithCustomLogs.v3.genres.getMovieList();

    genresMovies = genresResultsMovies['genres'] as List;

    setState(() {
      trendingmovies = trendingresult['results'];

      ///API may return a very big list of Movies, we this will help to reduce and only keep the first 10
      if (trendingmovies.length > 10) {
        trendingmovies.removeRange(10, trendingmovies.length);
      }
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
        trending: trendingmovies,
      ),
    );
  }
}
