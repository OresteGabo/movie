import 'package:flutter/material.dart';
import 'package:movie_app/model/app_vars.dart';

class MovieCard extends StatefulWidget {
  final int id;
  final DateTime originalReleaseDate;
  final String posterPath;
  final String title;
  final String overview;

  MovieCard({
    required this.id,
    required this.originalReleaseDate,
    required this.posterPath,
    required this.title,
    required this.overview,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  var release_dates;
  var theatricalReleaseDate = DateTime.now();
  Map release_dates_map = Map();

  void loadData() async {
    release_dates_map =
        await tmdbWithCustomLogs.v3.movies.getReleaseDates(widget.id);

    setState(() {
      release_dates = release_dates_map['results'];
      theatricalReleaseDate = getTheatricalReleaseDate();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.posterPath}',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _moviesInfo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The column on the right of the image
  Widget _moviesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///The title should be displayed on one line, otherwise, the ellipsis (...) are shown
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          getFrenchDate(
            theatricalReleaseDate,
          ),
          style: const TextStyle(color: Colors.grey),
        ),
        const Spacer(),

        ///The overview is only show on 2 lines, and the rest is replaced by (...)
        Text(
          widget.overview,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  /// Get a date of the form '23 Juillet 2022' , in french from [date]
  static String getFrenchDate(DateTime date) {
    return '${date.day} ${getFrenchMonth(date.month)}  ${date.year}';
  }

  /// Get a month in french from integer month (1 ... 12 => janvier ... Decembre) from [month]
  static String getFrenchMonth(int month) {
    String frM = '';
    switch (month) {
      case 1:
        {
          frM = 'Janvier';
        }
        break;
      case 2:
        {
          frM = 'Février';
        }
        break;
      case 3:
        {
          frM = 'Mars';
        }
        break;
      case 4:
        {
          frM = 'Avril';
        }
        break;
      case 5:
        {
          frM = 'Mai';
        }
        break;
      case 6:
        {
          frM = 'Juin';
        }
        break;
      case 7:
        {
          frM = 'Juillet';
        }
        break;
      case 8:
        {
          frM = 'Août';
        }
        break;
      case 9:
        {
          frM = 'Septembre';
        }
        break;
      case 10:
        {
          frM = 'Octobre';
        }
        break;
      case 11:
        {
          frM = 'Novembre';
        }
        break;
      case 12:
        {
          frM = 'Decembre';
        }
        break;
      default:
        {
          frM = '___';
        }
        break;
    }
    return frM;
  }

  DateTime getTheatricalReleaseDate() {
    DateTime theatrical = widget.originalReleaseDate;
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
