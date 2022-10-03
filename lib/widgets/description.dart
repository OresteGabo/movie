import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/model/app_vars.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;
  const MovieDetails({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  int _runtime = 0;
  String _tagline = '';
  String _displayedTime = '';
  String _title = '';
  DateTime _release_date = DateTime.now();
  String _overview = '';
  var _poster_path;

  var _genres; //Data from the API
  String _genresName = '';
  var url;

  //String image;
  Map data = Map();
  void getMovieData() async {
    data = await tmdbWithCustomLogs.v3.movies.getDetails(widget.movieId);
    setState(() {
      _poster_path = data['poster_path'];
      _runtime = data['runtime'];
      _tagline = data['tagline'];
      _displayedTime = getTime(_runtime);
      _overview = data['overview'];
      _title = data['title'];
      _release_date = DateTime.parse(data['release_date']);
      _genres = data['genres'];
      _genresName = getGenres();
    });
  }

  @override
  void initState() {
    getMovieData();
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
                _title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              _poster_path == null
                  ? const SizedBox(
                      //Dimensions of image (aspect ratio recommended by TMDB)
                      width: 130,
                      height: 130 * 1.5,
                    )
                  : Image.network(
                      'https://image.tmdb.org/t/p/w500$_poster_path',
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
                Text(
                  '${getFormattedDate(_release_date)}   -  $_displayedTime',
                ),
                Text(_genresName),
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
                  _tagline,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(_overview)
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///This function return the list of genre_names separated by a comma
  ///This function can't be used immediately in the UI, because it has t finish its execution before being used
  ///An intermediate variable is needed, that variable should get the value through initState
  String getGenres() {
    String str = '';
    for (int x = 0; x < _genres.length; x++) {
      String separator = '';
      if (x != _genres.length - 1) {
        separator = ',';
      }
      str += ' ${_genres[x]['name']}$separator';
    }
    return str;
  }

  /// Returns a formatted date String from [date].
  ///
  /// Throws a [FormatException] if the [date] can not be converted, or not a valid date data
  static String getFormattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static int getHours(int m) {
    return (m / 60).floor();
  }

  static int getMinutes(int m) {
    return m % 60;
  }

  static String getTime(int m) {
    return '${getHours(m)}h${getMinutes(m)}';
  }
}
