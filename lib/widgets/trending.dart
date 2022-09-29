import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/widgets/description.dart';

class TrendingMovies extends StatelessWidget {
  ///trending is a list of trending movies provided by the API
  final List trending;
  final genresMovies;
  final genresTv;

  const TrendingMovies({
    super.key,
    required this.trending,
    required this.genresMovies,
    required this.genresTv,
  });
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Description(
                    genresMovies: genresMovies,
                    genresTv: genresTv,
                    movieData: trending[index],
                  ),
                ),
              );
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
                          const SizedBox(
                            width: 6,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),

                            ///(Screen size - 100) This will help us to resize this container,
                            ///so that text inside will know the right boundary
                            width: width - 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///For some reason, some titles are null, and must be treated to not cause the app to crush
                                Text(
                                  trending[index]['title'] ??
                                      (trending[index]['name'] ??
                                          'Title not provided'),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),

                                ///TODO the release date must be changed in french
                                Text(
                                  ///TODO Reformatting date in french
                                  trending[index]['release_date'] == null
                                      ? (trending[index]['first_air_date'] ==
                                              null
                                          ? 'release date not provided'
                                          : DateFormat('dd MMMM yyyy')
                                              .format(
                                                DateTime.parse(
                                                  trending[index]
                                                      ['first_air_date'],
                                                ),
                                              )
                                              .toString())
                                      : DateFormat('dd MMMM yyyy')
                                          .format(
                                            DateTime.parse(
                                              trending[index]['release_date'],
                                            ),
                                          )
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
                                const SizedBox(
                                  height: 6,
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
