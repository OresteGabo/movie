import 'package:flutter/material.dart';
import 'package:movie_app/widgets/description.dart';
import 'package:movie_app/widgets/movie_card.dart';

class TrendingMovies extends StatelessWidget {
  ///trending is a list of trending movies provided by the API
  ///This list has in it items of different MediaType ,
  ///for more on MediaType https://pub.dev/documentation/tmdb_api/latest/tmdb_api/MediaType.html
  final List movies;

  const TrendingMovies({
    super.key,
    required this.movies,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(

        ///in a ListView.builder, you should always provide the number of items expected
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetails(
                    movieId: movies[index]['id'],
                  ),
                ),
              );
            },
            child: MovieCard(
              originalReleaseDate:
                  DateTime.parse(movies[index]['release_date']),
              title: movies[index]['title'],
              posterPath: movies[index]['poster_path'],
              overview: movies[index]['overview'],
            ),
          );
        });
  }
}
