
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../../controller/on_boarding_controller.dart';
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
          return  Scaffold(backgroundColor: CustomColors.selectedNavBarColor,
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (controller.currentPage !=
                            controller.onBoards.length - 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () => controller.updateCurrentPage(
                                        controller.onBoards.length - 1),
                                    child: Text(
                                      "skip",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!.copyWith(color: Colors.white),
                                    ))),
                          ),
                        SizedBox(
                          height: height * 0.7,
                          child: PageView(
                            onPageChanged: (value) =>
                                controller.updateCurrentPage(value),
                            controller: controller.pageController,
                            children: [
                              for (int i = 0;
                                  i < controller.onBoards.length;
                                  i++)
                                IntroScreen(
                                  label: controller.onBoards[i].title,
                                  details: controller.onBoards[i].content,
                                  height: height,
                                  width: width,
                                  img: controller.onBoards[i].img,
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: AnimatedSmoothIndicator(duration: Duration(milliseconds: 700),
                            count: controller.onBoards.length,
                            effect: SwapEffect(
                              dotColor: Colors.white.withOpacity(0.5),
                              activeDotColor: Colors.white,
                            ),
                            activeIndex: controller.currentPage,
                          ),
                        ),
                        ElevatedButton(

                            onPressed: () {
                              controller.currentPage ==
                                      (controller.onBoards.length - 1)
                                  ? controller.submit(context)
                                  : controller.nextPage();
                            },
                            child: Text(controller.currentPage ==
                                (controller.onBoards.length - 1)
                                ? "Let's go"
                                : "Next"))
                      ],
                    ),
                  ),
                );

        },
      );
    });
  }
}

/// todo: tablet:
//  Scaffold(
//                     body: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.asset(
//                         'assets/images/bg.jpg',
//                         fit: BoxFit.cover,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                                 colors: [Colors.black, Colors.transparent],
//                                 begin: Alignment.bottomCenter,
//                                 end: Alignment.topCenter)),
//                         child: Stack(children: [
//                           Container(
//                             padding: EdgeInsets.all(1.w),
//                             alignment: Alignment.bottomCenter,
//                             height: 100.h,
//                             child: Column(
//                               children: [
//                                 Expanded(flex: 20,
//                                   child: PageView(
//                                     onPageChanged: (value) => setState(() {
//                                       currentPage = value;
//                                     }),
//                                     controller: _controller,
//                                     children: [
//                                       IntroScreen(
//                                         label: 'Join Your Community!',
//                                         details:
//                                         'imperial will help you to meet members of your community in the UK and attend various events with them',
//                                       ),
//                                       IntroScreen(
//                                         label: 'Join Your Community!',
//                                         details:
//                                         'imperial will help you to meet members of your community in the UK and attend various events with them',
//                                       ),
//
//                                       onBoardingRegions(),
//                                     ],
//                                   ),
//                                 ),Expanded(flex: 1,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       TextButton(
//                                           onPressed: () {
//                                             _controller.jumpToPage(controller.onBoards.length+1);
//                                           },
//                                           child: Text(
//                                             currentPage != 2 ? 'Skip' : '',
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(color: Colors.white),
//                                           )),
//                                       SmoothPageIndicator(
//                                         controller: _controller,
//                                         count: controller.onBoards.length+1,
//                                         effect: ExpandingDotsEffect(
//                                           dotColor: Colors.white,
//                                           activeDotColor: CustomColors.red,
//                                         ),
//                                       ),
//                                       TextButton(
//                                           onPressed: currentPage == controller.onBoards.length+1
//                                               ? () {
//                                             // Boxes.onBoardingBox().put(1, true);
//                                             // Get.offAll(HomeView());
//                                           }
//                                               : () {
//                                             _controller.nextPage(
//                                                 duration:
//                                                 Duration(milliseconds: 200),
//                                                 curve: Curves.easeInOut);
//                                           },
//                                           child: currentPage == controller.onBoards.length+1
//                                               ? NextButton(iconSize: 3,
//                                             onPressed: () {
//                                               Get.to(HomeView());
//                                             },
//                                             icon: Icons.done,
//                                             color: CustomColors.green,
//                                           )
//                                               : NextButton(iconSize: 3,onPressed: () {
//                                             setState(() {
//                                               _controller.nextPage(
//                                                   duration:
//                                                   Duration(milliseconds: 200),
//                                                   curve: Curves.easeInOut);
//                                             });
//                                           })),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                         ]),
//                       ),
//                     ],
//                   ));
