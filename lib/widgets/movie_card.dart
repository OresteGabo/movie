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
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
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
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///For some reason, some titles are null, and must be treated to not cause the app to crush
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                          Text(
                            ///Tesing if data exist before usage
                            overview,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
