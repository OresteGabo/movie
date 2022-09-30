import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Description extends StatelessWidget {
  final movieData;
  final genresMovies;
  const Description({
    super.key,
    required this.movieData,
    required this.genresMovies,
  });

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
                getMovieTitle(movieData),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Image.network(
                'https://image.tmdb.org/t/p/w500${movieData['poster_path']}',
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
                  '${getFormattedDate(getReleaseDate(movieData))}   -   ${movieData['runtime'] == null ? '\tNO RUNTIME' : displayTime(34)}',
                ),

                ///TODO some movies's ID has no matching name, ID will be displayed instead
                Text(getMovieTypes(movieData['genre_ids']))
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
                  getMovieOriginalName(movieData),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(movieData['overview'])
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
    for (int x = 0; x < genresMovies.length; x++) {
      Map m = genresMovies[x];
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
        // (movieData['name'] ??
        (movieData['original_name'] ?? 'Title not provided');
  }

/*
  static String getMovieName(dynamic movieData) {
    return movieData['name'] ??
        (movieData['original_name'] ??
            (movieData['title'] ?? 'Name not provided'));
  }
*/
  static String getMovieOriginalName(dynamic movieData) {
    return movieData['original_title'] ??
        (movieData['name'] ??
            (movieData['title'] ?? 'Original name not provided'));
  }

  static int getHours(int minutes) {
    return (minutes / 60).floor();
  }

  static int getMinutes(int minutes) {
    return minutes % 60;
  }

  static String displayTime(int minutes) {
    return '${getHours(minutes)} h ${getMinutes(minutes)}';
  }
}
