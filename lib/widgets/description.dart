import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movie_app/model/app_vars.dart';

const String apikey = '04b719344104246bab9a7ee925a950ac';
const String readaccesstoken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNGI3MTkzNDQxMDQyNDZiYWI5YTdlZTkyNWE5NTBhYyIsInN1YiI6IjYzMzM3YTE2NjA4MmViMDA4ODNlM2NlYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gcSE4SYndJ4cbpQWW9QMWbKJ80Ij0MNkr8XTsMPp5IY';

class MovieDetails extends StatefulWidget {
  final movieData;
  final genresMovies;
  const MovieDetails({
    super.key,
    required this.movieData,
    required this.genresMovies,
  });

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  int runtime = 0;
  String tagline = '';
  int hours = 0;
  int minutes = 0;

  void getMissingData() async {
    Map data =
        await tmdbWithCustomLogs.v3.movies.getDetails(widget.movieData['id']);
    setState(() {
      runtime = data['runtime'];
      tagline = data['tagline'];
      hours = getHours(runtime);
      minutes = getMinutes(runtime);
    });
  }

  @override
  void initState() {
    getMissingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ///The title and the image
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                getMovieTitle(widget.movieData),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movieData['poster_path']}',
                width: 130,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),

          ///The release date, duration and the movie type
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: Column(
              children: [
                ///TODO Movie duration has to be fixed, and add dynamic data from the API database
                Text(
                  '${getFormattedDate(getReleaseDate(widget.movieData))}   -  ${getTime(runtime)}',
                ),

                ///TODO some movies's ID has no matching name, ID will be displayed instead
                Text(getMovieTypes(widget.movieData['genre_ids']))
              ],
            ),
          ),

          ///Short title, and the description in full
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ///TODO this is neither a title, nor the original name, i still have to figure out what is is
                  //getMovieOriginalName(widget.movieData),
                  tagline,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(widget.movieData['overview'])
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///This function will return the genre associated to the id passed inside the parameter
  ///The id, can the a Tv Id or a Movie id
  String getGenre(int g) {
    for (int x = 0; x < widget.genresMovies.length; x++) {
      Map m = widget.genresMovies[x];
      if (m['id'] == g) {
        return m['name'];
      }
    }

    //in case the String pair not found, we will return the id back
    return g.toString();
  }

  ///This function return the release_date, or the first_air_date or empty
  static String getReleaseDate(dynamic movieData) {
    if (movieData['release_date'] == null) {
      if (movieData['first_air_date'] == null) {
      } else {
        return movieData['first_air_date'].toString();
      }
    } else {
      return movieData['release_date'].toString();
    }
    return '';
  }

  /// Returns a formatted date String from [date].
  ///
  /// Throws a [FormatException] if the [date] can not be converted, or not a valid date data
  static String getFormattedDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    } on FormatException {
      return 'release date not provided';
    }
  }

  String getMovieTypes(List<dynamic> list) {
    String str = '';
    for (int x = 0; x < list.length; x++) {
      str += '  ${getGenre(list[x])}';
    }
    return str;
  }

  static String getMovieTitle(dynamic movieData) {
    return movieData['title'] ??
        (movieData['original_name'] ?? 'Title not provided');
  }

  static int getHours(int m) {
    return (m / 60).floor();
  }

  static int getMinutes(int m) {
    int minn = m % 60;
    return m % 60;
  }

  static String getTime(int m) {
    return '${getHours(m)} h ${getMinutes(m)}';
  }
}
