import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_task/controllers/movie_controller.dart';
import 'package:movies_task/controllers/preference_controller.dart';
import 'package:movies_task/models/movies_model.dart';
import 'package:movies_task/screens/fav_movies_list.dart';
import 'package:movies_task/utils/app_colors.dart';
import 'package:movies_task/utils/app_consts.dart';
import 'package:movies_task/utils/app_text_style.dart';
import 'package:movies_task/utils/preference_labels.dart';
import 'package:movies_task/widgets/loading_indicator.dart';

class MoviesListWidget extends StatefulWidget {
  const MoviesListWidget({Key? key}) : super(key: key);

  @override
  State<MoviesListWidget> createState() => _MoviesListWidgetState();
}

class _MoviesListWidgetState extends State<MoviesListWidget> {
  final MoviesListController moviesListController =
      Get.put(MoviesListController());

  @override
  void initState() {
    getPrefsData();
    super.initState();
  }

  ///
  ///
  ///
  void getPrefsData() async {
    moviesListController.favMoviesList = await AppPreferencesController()
            .getListString(AppPreferencesLabels.favMovies) ??
        [];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text("Movies APP"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColors.red,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Get.to(() => const FavMoviesList());
              },
            ),
          ]),
      body: Obx(
        () => moviesListController.isLoading.value
            ? const LoadingIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///
                      ///
                      ///
                      Text(
                        "Blockbuster Exciting Movies",
                        style: AppTextStyle.boldWhite18,
                      ),
                      const SizedBox(height: 12),
                      moviesCardDesign(),

                      ///
                      ///
                      ///
                      Text(
                        "Continue Watching",
                        style: AppTextStyle.boldWhite18,
                      ),
                      const SizedBox(height: 12),
                      moviesCardDesign(),

                      ///
                      ///
                      ///
                      Text(
                        "Trending Now",
                        style: AppTextStyle.boldWhite18,
                      ),
                      const SizedBox(height: 12),
                      moviesCardDesign(),

                      ///
                      ///
                      ///
                      Text(
                        "Spanish Movies",
                        style: AppTextStyle.boldWhite18,
                      ),
                      const SizedBox(height: 12),
                      moviesCardDesign(),

                      ///
                      ///
                      ///
                      Text(
                        "Comedies",
                        style: AppTextStyle.boldWhite18,
                      ),
                      const SizedBox(height: 12),
                      moviesCardDesign(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  SizedBox moviesCardDesign() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.2,
      child: ListView.builder(
        itemCount: moviesListController.moviesListModel.results!.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final Results results =
              moviesListController.moviesListModel.results![index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  ///
                  ///
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.red,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(
                            imageUrl:
                                "${AppConsts.imagesPath}${results.posterPath!}",
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2.9,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const LoadingIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),

                      ///
                      ///
                      IconButton(
                          iconSize: 30,
                          onPressed: () {
                            moviesListController.isLoading.value = true;

                            if (moviesListController.favMoviesList
                                .contains(results.id.toString())) {
                              moviesListController.favMoviesList
                                  .remove(results.id.toString());

                              ///
                              ///
                              ///
                              AppPreferencesController().setListString(
                                AppPreferencesLabels.favMovies,
                                moviesListController.favMoviesList
                                    .toSet()
                                    .toList(),
                              );
                            } else {
                              moviesListController.favMoviesList.add(
                                results.id!.toString(),
                              );

                              ///
                              ///
                              ///
                              AppPreferencesController().setListString(
                                AppPreferencesLabels.favMovies,
                                moviesListController.favMoviesList
                                    .toSet()
                                    .toList(),
                              );
                            }
                            log(moviesListController.favMoviesList.toString());
                            moviesListController.isLoading.value = false;
                          },
                          icon: moviesListController.favMoviesList
                                  .contains(results.id.toString())
                              ? Icon(
                                  Icons.favorite,
                                  color: AppColors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: AppColors.white,
                                ))
                    ],
                  ),
                  const SizedBox(height: 8),

                  ///
                  /// title
                  ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ",
                        style: AppTextStyle.boldWhite12,
                      ),
                      Flexible(
                        child: Text(
                          moviesListController
                              .moviesListModel.results![index].title!,
                          style: AppTextStyle.boldWhite12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ///
                  /// release date
                  ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Release Date: ",
                        style: AppTextStyle.boldWhite12,
                      ),
                      Text(
                        moviesListController
                            .moviesListModel.results![index].releaseDate!,
                        style: AppTextStyle.boldWhite12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ///
                  /// overview
                  ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Overview: ",
                        style: AppTextStyle.boldWhite12,
                      ),
                      Flexible(
                        child: Text(
                          moviesListController
                              .moviesListModel.results![index].overview!,
                          style: AppTextStyle.boldWhite12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
