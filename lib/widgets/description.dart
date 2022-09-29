import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Description extends StatelessWidget {
  final movieData;
  const Description({
    super.key,
    required this.movieData,
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
                  '${getFormattedDate(movieData['release_date'].toString())} - 1h27',
                ),

                ///TODO instead of printing the ID's, we need to print their related values
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
                //Text(overview),
                Text(movieData['overview'])
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String getFormattedDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    } on FormatException {
      return 'release date not provided';
    }
  }

  static String getMovieTypes(List<dynamic> list) {
    String str = '';
    for (int x = 0; x < list.length; x++) {
      str += '  ${list[x]}';
    }
    return str;
  }

  static String getMovieTitle(dynamic movieData) {
    return movieData['title'] ??
        (movieData['name'] ??
            (movieData['original_name'] ?? 'Title not provided'));
  }

  static String getMovieName(dynamic movieData) {
    return movieData['name'] ??
        (movieData['original_name'] ??
            (movieData['title'] ?? 'Name not provided'));
  }

  static String getMovieOriginalName(dynamic movieData) {
    return movieData['original_name'] ??
        (movieData['name'] ??
            (movieData['title'] ?? 'Original name not provided'));
  }
}
