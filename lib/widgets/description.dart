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
  var release_dates;
  var theatricalReleaseDate = DateTime.now();
  Map release_dates_map = Map();

  int _runtime = 0;
  String _tagline = '';
  String _displayedTime = '';
  String _title = '';
  var originalReleaseDate; // = DateTime.now();
  String _overview = '';
  var _poster_path;

  var _genres; //Data from the API
  String _genresName = '';

  //String image;
  Map data = Map();
  void getMovieData() async {
    data = await tmdbWithCustomLogs.v3.movies.getDetails(widget.movieId);
    release_dates_map =
        await tmdbWithCustomLogs.v3.movies.getReleaseDates(widget.movieId);
    setState(() {
      _poster_path = data['poster_path'];
      _runtime = data['runtime'];
      _tagline = data['tagline'];
      _displayedTime = getTime(_runtime);
      _overview = data['overview'];
      _title = data['title'];
      originalReleaseDate = DateTime.parse(data['release_date']);
      _genres = data['genres'];
      _genresName = getGenres();
      release_dates = release_dates_map['results'];
      theatricalReleaseDate = getTheatricalReleaseDate();
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
          _topTitledImage(),
          const SizedBox(
            height: 24,
          ),

          ///The release date, duration and the movie type
          _middleContainer(),

          ///Tagline, and the overview in full
          _movieDescription(),
        ],
      ),
    );
  }

  ///The title and the image
  Widget _topTitledImage() {
    return Column(
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
    );
  }

  ///The release date, duration and the movie type
  Widget _middleContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: Column(
        children: [
          Text(
            '${getFormattedDate(theatricalReleaseDate)}   -  $_displayedTime',
          ),
          Text(_genresName),
        ],
      ),
    );
  }

  ///Tagline, and the overview in full
  Widget _movieDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tagline,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(_overview)
        ],
      ),
    );
  }

  ///This function return the list of genre_names separated by a comma
  ///This function can't be used immediately in the UI, because it has t finish its execution before being used
  ///An intermediate variable is needed, that variable should get the value through initState,
  ///Otherwise, the page will load before the existence of the data (null) and the display of
  /// null will cause a red screen error , saying that it expected a String String but got a null,
  /// it gets a null because genre.length is zero at first, and gets updated in initstate
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

  DateTime getTheatricalReleaseDate() {
    DateTime theatrical = originalReleaseDate;
    for (int x = 0; x < release_dates.length; x++) {
      if (release_dates[x]['iso_3166_1'] == 'FR') {
        var frDates = release_dates[x]['release_dates'];
        for (int y = 0; y < frDates.length; y++) {
          ///type 3 == Theatrical (from  https://developers.themoviedb.org/3/movies/get-movie-release-dates)
          if (frDates[y]['type'] == 3) {
            theatrical = DateTime.parse(
                (frDates[y]['release_date']).toString().substring(0, 10));
            return theatrical;
          }
        }
      }
    }
    return theatrical;
  }
}
