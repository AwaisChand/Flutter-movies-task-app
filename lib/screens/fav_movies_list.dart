import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_task/controllers/movie_controller.dart';
import 'package:movies_task/controllers/preference_controller.dart';
import 'package:movies_task/models/movies_model.dart';
import 'package:movies_task/utils/app_colors.dart';
import 'package:movies_task/utils/app_consts.dart';
import 'package:movies_task/utils/app_text_style.dart';
import 'package:movies_task/utils/preference_labels.dart';
import 'package:movies_task/utils/primary_button.dart';
import 'package:movies_task/widgets/loading_indicator.dart';

class FavMoviesList extends StatefulWidget {
  const FavMoviesList({Key? key}) : super(key: key);

  @override
  State<FavMoviesList> createState() => _FavMoviesListState();
}

class _FavMoviesListState extends State<FavMoviesList> {
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
        title: const Text("Favorite Movies"),
        centerTitle: true,
        backgroundColor: AppColors.red,
      ),
      body: Obx(
        () => moviesListController.isLoading.value
            ? const LoadingIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child:
                moviesCardDesign(),

              ),
      ),
    );
  }

  Widget moviesCardDesign() {
    return ListView.builder(
      itemCount: moviesListController.moviesListModel.results!.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Results results =
            moviesListController.moviesListModel.results![index];

        return moviesListController.favMoviesList
                .contains(results.id.toString())
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
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
                                  height:
                                      MediaQuery.of(context).size.height / 2.9,
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
                                    Get.defaultDialog(
                                      titlePadding:
                                          const EdgeInsets.only(top: 16),
                                      title: "Remove",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                      content: Column(
                                        children: [
                                          Text(
                                            "Are you sure you want to remove movie from favorite list",
                                            style: AppTextStyle.boldBlack14,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              PrimaryButton(
                                                width: 125,
                                                title: "Cancel",
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              PrimaryButton(
                                                width: 125,
                                                title: "Remove",
                                                onPressed: () {
                                                  moviesListController
                                                      .favMoviesList
                                                      .remove(results.id
                                                          .toString());

                                                  ///
                                                  ///
                                                  ///
                                                  AppPreferencesController()
                                                      .setListString(
                                                    AppPreferencesLabels
                                                        .favMovies,
                                                    moviesListController
                                                        .favMoviesList
                                                        .toSet()
                                                        .toList(),

                                                    ///
                                                    ///
                                                    ///
                                                  );

                                                  moviesListController
                                                      .isLoading.value = true;
                                                  moviesListController
                                                      .isLoading.value = false;
                                                  Get.back();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                  log(moviesListController.favMoviesList
                                      .toString());
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
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
                              const SizedBox(height: 8),
                              Text(
                                "Release Date: ",
                                style: AppTextStyle.boldWhite12,
                              ),
                              Flexible(
                                child: Text(
                                  moviesListController.moviesListModel
                                      .results![index].releaseDate!,
                                  style: AppTextStyle.boldWhite12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Overview: ",
                                style: AppTextStyle.boldWhite12,
                              ),
                              Text(
                                moviesListController
                                    .moviesListModel.results![index].overview!,
                                style: AppTextStyle.boldWhite12,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 18,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
