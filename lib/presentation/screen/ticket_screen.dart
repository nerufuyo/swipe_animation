import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swipe_animation/common/costant.dart';
import 'package:swipe_animation/data/repository/repository.dart';
import 'package:swipe_animation/presentation/screen/home_screen.dart';
import 'package:swipe_animation/presentation/widget/components.dart';
import 'package:swipe_animation/style/pallet.dart';
import 'package:swipe_animation/style/typography.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.id});
  static const routeName = '/ticket';
  final String id;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<bool> selectedSeats = List.generate(30, (index) => false);
  String trailer = '';

  void fechData() async {
    final response = await Repository().getCinemaById(widget.id);
    setState(() => trailer = response.trailer);
  }

  @override
  void initState() {
    super.initState();
    fechData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(context),
              customVerticalSpace(16),
              YoutubePlayer(
                controller: YoutubePlayerController(
                  params: YoutubePlayerParams(
                    origin: trailer,
                    showControls: true,
                    showFullscreenButton: true,
                  ),
                ),
                aspectRatio: 16 / 9,
              ),
              customVerticalSpace(16),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: selectedSeats.length,
                itemBuilder: (context, seatIndex) {
                  final isClickable = !nonClickableIndices.contains(seatIndex);

                  return InkWell(
                    onTap: isClickable
                        ? () {
                            setState(() {
                              selectedSeats[seatIndex] =
                                  !selectedSeats[seatIndex];
                            });
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedSeats[seatIndex]
                            ? whiteColor
                            : isClickable
                                ? const Color(0xFF1D1D1D)
                                : const Color(0xFFFF9800),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: customText(
                          customTextValue: (seatIndex + 1).toString(),
                          customTextStyle: heading4.copyWith(
                            color: selectedSeats[seatIndex]
                                ? primaryColor
                                : isClickable
                                    ? whiteColor
                                    : primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              customVerticalSpace(16),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 30,
                ),
                shrinkWrap: true,
                itemCount: seatStatus.length,
                itemBuilder: (context, seatIndex) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(seatStatus[seatIndex]['color'].toString()),
                        ),
                        shape: BoxShape.circle,
                      ),
                      width: 10,
                      height: 10,
                    ),
                    customHorizontalSpace(8),
                    customText(
                      customTextValue: seatStatus[seatIndex]['status'],
                      customTextStyle: bodyText3.copyWith(
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              customVerticalSpace(16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    customTextValue: 'Total',
                    customTextStyle: bodyText3.copyWith(color: whiteColor),
                  ),
                  customText(
                    customTextValue: 'Rp ${selectedSeats.length * 10000}',
                    customTextStyle: heading3.copyWith(color: whiteColor),
                  ),
                ],
              ),
              customVerticalSpace(16),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: customButton(
                  buttonOnTapped: () {
                    Future.delayed(
                      const Duration(seconds: 3),
                      () => Navigator.pushNamed(context, HomeScreen.routeName),
                    );
                    customDialog(context);
                  },
                  buttonText: 'Pay',
                  buttonColor: Colors.orange,
                  buttonTextColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: IconButton(
            key: const ValueKey<String>('menuButton'),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.backward),
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
}
