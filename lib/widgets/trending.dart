import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrendingMovies extends StatelessWidget {
  ///trending is a list of trending movies provided by the API
  final List trending;

  const TrendingMovies({super.key, required this.trending});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(

        ///in a ListView.builder, you should always provide the number of items expected
        itemCount: trending.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              ///TODO By clicking on the movie, it should pop up with more description
            },
            child: Column(
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
                            'https://image.tmdb.org/t/p/w500${trending[index]['poster_path']}',
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),

                            ///This will help us to resize this container, so that text inside will kbow the right boundary
                            width: width - 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///For some reason, some titles are null, and must be treated to not cause the app to crush
                                Text(
                                  trending[index]['title'] ??
                                      'Title not provided',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ///TODO Reformatting date in french
                                  trending[index]['release_date'] == null
                                      ? 'release date not provided'
                                      : DateFormat('dd MMMM yyyy')
                                          .format(DateTime.parse(
                                              trending[index]['release_date']))
                                          .toString(),

                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Spacer(),
                                Text(
                                  ///Tesing if data exist before usage
                                  trending[index]['overview'] ?? 'no overview',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
