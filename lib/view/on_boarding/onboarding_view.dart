import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/on_boarding_controller.dart';
import '../../core/custom_colors.dart';
import 'intro_screen1.dart';

class OnBoardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    return GetBuilder<OnBoardingController>(builder: (controller) {
      return Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          double height = 100.h;
          double width = 100.w;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (controller.currentPage !=
                        controller.onBoards.length - 1)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () => controller.updateCurrentPage(
                                  controller.onBoards.length - 1),
                              child: Text(
                                "تخطي",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: CustomColors.textBlack54),
                              ))),
                    SizedBox(
                      height: height * 0.70,
                      child: PageView.builder(
                        itemCount: controller.onBoards.length,
                        onPageChanged: (value) =>
                            controller.updateCurrentPage(value),
                        controller: controller.pageController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: controller.pageController,
                            builder: (context, child) {
                              double offset = 0.0;
                              if (controller
                                  .pageController.position.haveDimensions) {
                                offset =
                                    controller.pageController.page! - index;
                              } else {
                                offset =
                                    (controller.currentPage - index).toDouble();
                              }
                              return IntroScreen(
                                label: controller.onBoards[index].title,
                                details: controller.onBoards[index].content,
                                height: height,
                                width: width,
                                img: controller.onBoards[index].img,
                                animationValue: offset,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: AnimatedSmoothIndicator(
                        duration: const Duration(milliseconds: 700),
                        count: controller.onBoards.length,
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey.withOpacity(0.5),
                          activeDotColor: CustomColors.mainColor,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                        activeIndex: controller.currentPage,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.currentPage ==
                                    (controller.onBoards.length - 1)
                                ? controller.submit(context)
                                : controller.nextPage();
                          },
                          child: Text(
                            controller.currentPage ==
                                    (controller.onBoards.length - 1)
                                ? "ابدأ الآن"
                                : "التالي",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
