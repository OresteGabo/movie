import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  const MovieCard({
    Key? key,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.overview,
  }) : super(key: key);

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
                'https://image.tmdb.org/t/p/w500$posterPath',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _moviesInfo(
                      title: title,
                      releaseDate: releaseDate,
                      overview: overview),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The column on the right of the image
  Widget _moviesInfo({
    required String title,
    required String releaseDate,
    required String overview,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///The title should be displayed on one line, otherwise, the ellipsis (...) are shown
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          getFrenchDate(
            DateTime.parse(releaseDate),
          ),
          style: const TextStyle(color: Colors.grey),
        ),
        const Spacer(),

        ///The overview is only show on 2 lines, and the rest is replaced by (...)
        Text(
          overview,
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
}
