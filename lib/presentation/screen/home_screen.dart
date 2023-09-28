import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swipe_animation/data/model/cinema_model.dart';
import 'package:swipe_animation/data/repository/repository.dart';
import 'package:swipe_animation/presentation/screen/ticket_screen.dart';
import 'package:swipe_animation/presentation/widget/components.dart';
import 'package:swipe_animation/style/pallet.dart';
import 'package:swipe_animation/style/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController mainCarouselController = CarouselController();
  final CarouselController backgroundCarouselController = CarouselController();
  final List<Map<String, String>> cinemaImages = [];
  String cardSelectedId = '';
  int cardSelectedIndex = 0;
  bool isCardSelected = false;
  bool isBuyClicked = false;

  void fetchData() async {
    final cinema = await Repository().getCinemas();

    setState(() {
      cardSelectedId = cinema[0].id;
      cinemaImages.addAll(cinema.map((data) => {'images': data.images}));
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carousel Background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: primaryColor,
            child: isCardSelected
                ? const SizedBox.shrink()
                : _buildCarouselBackground(context),
          ),
          // Pop Up Poster
          _buildPopPoster(context),
          // Carousel Card
          FutureBuilder(
            future: Repository().getCinemas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cinema = snapshot.data;
                return _buildCarouselCard(context, cinema);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //Hader
          Positioned(
            top: 24,
            left: 24,
            right: 24,
            child: _buildHeader(),
          ),
          // Button
          AnimatedPositioned(
            duration: isCardSelected
                ? const Duration(milliseconds: 500)
                : const Duration(milliseconds: 200),
            bottom: isCardSelected ? 20 : 54,
            left: isCardSelected
                ? 16
                : isBuyClicked || (isCardSelected && isBuyClicked)
                    ? MediaQuery.of(context).size.width * 0.45
                    : 66,
            right: isCardSelected
                ? 16
                : isBuyClicked || (isCardSelected && isBuyClicked)
                    ? MediaQuery.of(context).size.width * 0.45
                    : 66,
            child: customButton(
              buttonVisible: !isBuyClicked,
              buttonOnTapped: () {
                setState(() => isBuyClicked = true);
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pushNamed(context, TicketScreen.routeName,
                          arguments: cardSelectedId)
                      .then((value) => setState(() => isBuyClicked = false));
                });
              },
              buttonText: 'Buy Ticket',
              buttonBorderRadius: BorderRadius.circular(isBuyClicked ? 24 : 8),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedPositioned _buildPopPoster(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: isCardSelected
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.3,
      left: MediaQuery.of(context).size.width * 0.25,
      right: MediaQuery.of(context).size.width * 0.25,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: isCardSelected ? MediaQuery.of(context).size.height * 0.25 : 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            cinemaImages[cardSelectedIndex]['images']!,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isCardSelected
              ? IconButton(
                  key: const ValueKey<String>('backButton'),
                  onPressed: () {
                    setState(() => isCardSelected = false);
                  },
                  icon: const Icon(Iconsax.backward),
                  color: whiteColor,
                )
              : IconButton(
                  key: const ValueKey<String>('menuButton'),
                  onPressed: () {},
                  icon: const Icon(Iconsax.menu4),
                  color: whiteColor,
                ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Iconsax.info_circle4),
          color: whiteColor,
        ),
      ],
    );
  }

  CarouselSlider _buildCarouselBackground(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: backgroundCarouselController,
      options: CarouselOptions(
        scrollPhysics: const NeverScrollableScrollPhysics(),
        height: MediaQuery.of(context).size.height,
        viewportFraction: 1,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          mainCarouselController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
      ),
      itemCount: cinemaImages.length,
      itemBuilder: (context, cardIndex, realIndex) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(cinemaImages[cardIndex]['images']!),
              colorFilter: ColorFilter.mode(
                primaryColor.withOpacity(0.5),
                BlendMode.darken,
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  AnimatedPositioned _buildCarouselCard(
      BuildContext context, List<Cinema>? cinema) {
    return AnimatedPositioned(
      bottom: isCardSelected ? 0 : 40,
      left: 0,
      right: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: CarouselSlider.builder(
        carouselController: mainCarouselController,
        options: CarouselOptions(
          height: isCardSelected
              ? MediaQuery.of(context).size.height * 0.75
              : MediaQuery.of(context).size.height * 0.7,
          viewportFraction: isCardSelected ? 1 : 0.75,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            backgroundCarouselController.animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
            setState(() {
              cardSelectedId = cinema![index].id;
              isCardSelected = false;
            });
          },
        ),
        itemCount: cinema!.length,
        itemBuilder: (context, cardIndex, realIndex) {
          return InkWell(
            onTap: () {
              setState(() {
                isCardSelected = true;
                cardSelectedIndex = cardIndex;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: isCardSelected
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: isCardSelected
                          ? 0
                          : MediaQuery.of(context).size.width * 0.65,
                      height: isCardSelected
                          ? 0
                          : MediaQuery.of(context).size.height * 0.45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          cinema[cardIndex].images,
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.height * 0.45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    customVerticalSpace(8),
                    customText(
                      customTextValue: cinema[cardIndex].title,
                      customTextStyle: heading1,
                    ),
                    customVerticalSpace(8),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cinema[cardIndex].genre.length > 3
                            ? 3
                            : cinema[cardIndex].genre.length,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        mainAxisExtent: 24,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      padding: isCardSelected
                          ? const EdgeInsets.symmetric(horizontal: 44)
                          : EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: cinema[cardIndex].genre.length,
                      itemBuilder: (context, genreIndex) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: secondaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: customText(
                            customTextValue:
                                cinema[cardIndex].genre[genreIndex],
                            customTextStyle: bodyText4,
                          ),
                        ),
                      ),
                    ),
                    customVerticalSpace(8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText(
                          customTextValue: cinema[cardIndex].rating.toString(),
                          customTextStyle: bodyText3,
                        ),
                        customHorizontalSpace(4),
                        RatingBar.builder(
                          ignoreGestures: true,
                          onRatingUpdate: (rating) {},
                          allowHalfRating: true,
                          initialRating: cinema[cardIndex].rating / 2,
                          minRating: 1,
                          itemSize: 20,
                          itemCount: 5,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.orange),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isCardSelected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customVerticalSpace(8),
                          Align(
                            alignment: Alignment.center,
                            child: customText(
                              customTextValue:
                                  'Director / ${cinema[cardIndex].director}',
                              customTextStyle: bodyText3,
                            ),
                          ),
                          customVerticalSpace(8),
                          customText(
                            customTextValue: 'Actors',
                            customTextStyle: heading3,
                          ),
                          customVerticalSpace(4),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  customHorizontalSpace(16),
                              itemCount: cinema[cardIndex].actors.length,
                              itemBuilder: (context, actorIndex) => SizedBox(
                                width: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        imageUrl: cinema[cardIndex]
                                            .actors[actorIndex]
                                            .image
                                            .toString(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Iconsax.user),
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                Image.asset(
                                          'lib/assets/images/default.jpeg',
                                        ),
                                      ),
                                    ),
                                    customVerticalSpace(4),
                                    customText(
                                      customTextValue: cinema[cardIndex]
                                          .actors[actorIndex]
                                          .name,
                                      customTextStyle: bodyText3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          customVerticalSpace(8),
                          customText(
                            customTextValue: 'Description',
                            customTextStyle: heading3,
                          ),
                          customVerticalSpace(4),
                          customText(
                            customTextValue: cinema[cardIndex].description,
                            customTextStyle: bodyText3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
