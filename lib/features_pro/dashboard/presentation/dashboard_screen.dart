// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_field

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lsebert/common_widgets/custom_drawer.dart';
import 'package:lsebert/common_widgets/loading_indicators.dart';
import 'package:lsebert/constants/app_constants.dart';
import 'package:lsebert/constants/text_font_style.dart';
import 'package:lsebert/gen/assets.gen.dart';
import 'package:lsebert/gen/colors.gen.dart';
import 'package:lsebert/helpers/di.dart';
import 'package:lsebert/helpers/loading_helper.dart';
import 'package:lsebert/helpers/toast.dart';
import 'package:lsebert/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/auth_button.dart';
import '../../../common_widgets/delete_dilouge_widget.dart';
import '../../../common_widgets/experiance_data_widget.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../../../networks/endpoints.dart';
import '../../../networks/stream_cleaner.dart';
import '../../../provider/image_picker_provider.dart';
import 'widget/dashboard_card.dart';
import 'widget/dotted_container.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cE7ECF1,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.cE7ECF1,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 75.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColors.c1DB5A9,
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.c1DB5A9,
                    width: 2.w,
                  ),
                ),
                child: StreamBuilder(
                    stream: getProProfileRxObj.dataFetcher,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            snapshot.data!['data']['user'];
                        String userImage = imageUrl + data['avatar'];
                        return CircleAvatar(
                          radius: 30.r, // Inner circle radius
                          backgroundImage: NetworkImage(userImage),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
              ),
            ),
          ),
          title: StreamBuilder(
              stream: getProProfileRxObj.dataFetcher,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data!['data']['user'];

                  return Text(
                    data['name'],
                    style: TextFontStyle.headline16w500C141414StyleInter
                        .copyWith(color: AppColors.allPrimaryColor),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Image.asset(
                  Assets.icons.menuIcon.path,
                  width: 38.w,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: StreamBuilder(
              stream: getProProfileRxObj.dataFetcher,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map data = snapshot.data!['data']['user'];
                  return Column(
                    children: [
                      // UIHelper.verticalSpace(4.h),
                      // CustomTextFormField(
                      //   fillColor: AppColors.cffffff,
                      //   isBorder: true,
                      //   isPrefixIcon: true,
                      //   iconpath: Assets.icons.searchIcon.path,
                      //   controller: _searchController,
                      //   hintText: 'Search',
                      // ),
                      UIHelper.verticalSpace(20.h),
                      DashBoardCardProfessional(
                        isText: false,
                        darkMode: true,
                        count: data["connect"]?.toString() ?? "0",
                        detail: "Total Connect People",
                        imagepath: Assets.icons.totalConnect.path,
                      ),
                      UIHelper.verticalSpaceSmall,
                      DashBoardCardProfessional(
                        isText: true,
                        darkMode: false,
                        count:
                            data["boostTransactionsCount"]?.toString() ?? "0",
                        detail: "Boost",
                        imagepath: Assets.icons.flameIcon.path,
                        onTap: () {
                          _showAlertDialog(context);
                        },
                      ),
                      UIHelper.verticalSpaceSmall,
                      DashBoardCardProfessional(
                        isText: false,
                        darkMode: false,
                        count: data["profile_views"]?.toString() ?? "0",
                        detail: "Profile Views",
                        imagepath: Assets.icons.profileViewIcon.path,
                      ),
                      UIHelper.verticalSpaceMedium,
                      StreamBuilder(
                          stream: getProProfileRxObj.dataFetcher,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<ImagePickerProvider>(
                                      builder: (context, provider, _) {
                                    provider.imageList = [];
                                    List data = snapshot.data!['data']['user']
                                        ["my_images"];
                                    List<Map> currentImage = [];

                                    for (var element in data) {
                                      Map image = {
                                        "id": element["id"],
                                        "image": imageUrl + element["image"]
                                      };
                                      currentImage.add(image);
                                    }
                                    provider.imageList = currentImage;

                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Add Photo",
                                              style: TextFontStyle
                                                  .headline24w700C000000StyleInter,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                List<File>? imagesList =
                                                    provider.getImages();
                                                log('Show Image Path $images');
                                                if (images.isNotEmpty) {
                                                  await postImageRxObj
                                                      .postProImage(imagesList)
                                                      .waitingForFuture();
                                                  await getProProfileRxObj
                                                      .fetchProfileData();
                                                  provider.clearImages();
                                                  ToastUtil.showLongToast(
                                                      'Image Upload Success');
                                                } else {
                                                  log('No images to upload');
                                                }
                                              },
                                              child: Icon(
                                                Icons.save,
                                                size: 26.sp,
                                                color:
                                                    AppColors.allPrimaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                        UIHelper.verticalSpaceSmall,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            provider.imageFile1 == null
                                                ? DottedContainer(
                                                    index: 1,
                                                    id: currentImage.isNotEmpty
                                                        ? currentImage[0]["id"]
                                                        : null,
                                                    imageUrl:
                                                        currentImage.isNotEmpty
                                                            ? currentImage[0]
                                                                ["image"]
                                                            : null,
                                                  )
                                                : _pickedImage(
                                                    provider.imageFile1!.path,
                                                    provider,
                                                    1),
                                            provider.imageFile2 == null
                                                ? DottedContainer(
                                                    index: 2,
                                                    id: currentImage.length >= 2
                                                        ? currentImage[1]["id"]
                                                        : null,
                                                    imageUrl:
                                                        currentImage.length >= 2
                                                            ? currentImage[1]
                                                                ["image"]
                                                            : null,
                                                  )
                                                : _pickedImage(
                                                    provider.imageFile2!.path,
                                                    provider,
                                                    2)
                                          ],
                                        ),
                                        UIHelper.verticalSpaceMediumLarge,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            provider.imageFile3 == null
                                                ? DottedContainer(
                                                    index: 3,
                                                    id: currentImage.length >= 3
                                                        ? currentImage[2]["id"]
                                                        : null,
                                                    imageUrl:
                                                        currentImage.length >= 3
                                                            ? currentImage[2]
                                                                ["image"]
                                                            : null,
                                                  )
                                                : _pickedImage(
                                                    provider.imageFile3!.path,
                                                    provider,
                                                    3),
                                            provider.imageFile4 == null
                                                ? DottedContainer(
                                                    index: 4,
                                                    id: currentImage.length >= 4
                                                        ? currentImage[3]["id"]
                                                        : null,
                                                    imageUrl:
                                                        currentImage.length >= 4
                                                            ? currentImage[3]
                                                                ["image"]
                                                            : null,
                                                  )
                                                : _pickedImage(
                                                    provider.imageFile4!.path,
                                                    provider,
                                                    4),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                  UIHelper.verticalSpaceMedium,
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: AppColors.cffffff,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(24.sp),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          UIHelper.verticalSpaceMedium,
                                          Text(
                                            "About Me",
                                            style: TextFontStyle
                                                .headline24w700C000000StyleInter,
                                          ),
                                          UIHelper.verticalSpaceMedium,
                                          StreamBuilder(
                                              stream: getProProfileRxObj
                                                  .dataFetcher,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  Map<String, dynamic> data =
                                                      snapshot.data!['data']
                                                          ['user'];
                                                  List? experianceData =
                                                      data['experiences'];
                                                  appData.write(
                                                      userImage,
                                                      imageUrl +
                                                          data['avatar']);

                                                  return Text(
                                                    data['user_detail']['bio'],
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextFontStyle
                                                        .headline14w400C848484StyleInter
                                                        .copyWith(
                                                            color: AppColors
                                                                .c5A5C5F),
                                                  );
                                                } else {
                                                  return SizedBox.shrink();
                                                }
                                              }),
                                          UIHelper.horizontalSpaceSmall,
                                        ],
                                      ),
                                    ),
                                  ),
                                  UIHelper.verticalSpaceMedium,
                                  //  if (experianceData != null)
                                  StreamBuilder(
                                      stream: getExperianceRXObj.dataFetcher,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map? data = snapshot.data;
                                          List experiance = data!['data'];
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.h, horizontal: 0.w),
                                            decoration: BoxDecoration(
                                                color: AppColors.cffffff,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.r)),
                                            child: Column(
                                              children: [
                                                ListView.separated(
                                                  separatorBuilder: (context,
                                                          index) =>
                                                      UIHelper.customDivider(),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: experiance.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ExperiencesDataWidget(
                                                        isEdit: false,
                                                        isExperianceShow: index ==
                                                            0,
                                                        crntCompanyName:
                                                            experiance[index]
                                                                [
                                                                'company_name'],
                                                        designation:
                                                            experiance[index]
                                                                ['designation'],
                                                        employeeType:
                                                            experiance[index]
                                                                ['status'],
                                                        endDate:
                                                            experiance[index]
                                                                ['ending_date'],
                                                        jobLocation:
                                                            experiance[index]
                                                                [
                                                                'company_location'],
                                                        startDate: experiance[
                                                                index]
                                                            ['starting_date'],
                                                        onTapExperianceEdit: () {
                                                          log(experiance[index]
                                                              .toString());
                                                        });
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                ],
                              );
                            } else {
                              return loadingIndicatorCircle(context: context);
                            }
                          }),
                    ],
                  );
                } else {
                  return loadingIndicatorCircle(context: context);
                }
              }),
        ),
        drawer: CustomDrawer(
          onTapLogout: () {
            deleteButtonDialouge(context, "You are about to Logout!", () {
              //  getDeleteTokenRXObj.deleteTokenData();
              getLogOutRXObj.fetchLogoutData();
              totalDataClean();
              NavigationService.navigateToReplacement(Routes.login);
            });
          },
          onTapNotification: () {
            _scaffoldKey.currentState!.closeDrawer();
            NavigationService.navigateTo(Routes.proNotification);
            _scaffoldKey.currentState!.closeDrawer();
          },
          onTapPaymnetHistory: () {
            NavigationService.navigateTo(Routes.paymentHistory);
            _scaffoldKey.currentState!.closeDrawer();
          },
          onTapAboutus: () {
            NavigationService.navigateToWithArgs(Routes.webview,
                {"name": "About US", "url": "$url/page/about-us"});
            _scaffoldKey.currentState!.closeDrawer();
          },
          onTapPrivacy: () {
            NavigationService.navigateToWithArgs(Routes.webview, {
              "name": "Privacy & Policy",
              "url": "$url/page/privacy-policy"
            });
            _scaffoldKey.currentState!.closeDrawer();
          },
          onTapHelpAndSuport: () {
            NavigationService.navigateTo(Routes.helpAndSupport);
            _scaffoldKey.currentState!.closeDrawer();
          },
          onTapSecurity: () {
            NavigationService.navigateTo(Routes.securityScreen);
            _scaffoldKey.currentState!.closeDrawer();
          },
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          icon: Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => NavigationService.goBack,
                child: Icon(
                  Icons.close,
                  size: 28.sp,
                ),
              )
            ],
          ),
          title: Text(
            'My Boosts',
            style: TextFontStyle.headline24w700C000000StyleInter,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textAlign: TextAlign.center,
                'Be a top profile your area for 30 minutes to get more matches',
                style: TextFontStyle.headline14w400C848484StyleInter
                    .copyWith(color: AppColors.c000000),
              ),
              UIHelper.verticalSpace(20.h),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: Row(
                  children: [
                    Image.asset(
                      Assets.icons.boostIcon.path,
                      width: 48.w,
                    ),
                    UIHelper.horizontalSpace(8.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Boosts',
                          style: TextFontStyle.headline24w700C000000StyleInter,
                        ),
                        UIHelper.verticalSpace(8.h),
                        Text(
                          textAlign: TextAlign.center,
                          '\$2.0',
                          style: TextFontStyle.headline14w400C848484StyleInter,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              UIHelper.verticalSpace(43.h),
              AuthCustomeButton(
                  name: 'Get More Boosts',
                  onCallBack: () {},
                  height: 48.h,
                  minWidth: 228.w,
                  borderRadius: 24.r,
                  color: AppColors.allPrimaryColor,
                  textStyle: TextFontStyle.headline16w600CFFFFFFFFStyleintere,
                  context: context)
            ],
          ),
        );
      },
    );
  }

  Widget _pickedImage(String path, ImagePickerProvider provider, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            width: 159.w,
            height: 154.h,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Image.file(
                File(
                  path,
                ),
                fit: BoxFit.cover)),
        Positioned(
          bottom: -12,
          right: -10,
          child: GestureDetector(
            onTap: () async {
              provider.resetImages(index);
            },
            child: CircleAvatar(
              backgroundColor: AppColors.cffffff,
              radius: 16.r,
              child: const Icon(
                Icons.close,
                color: AppColors.allPrimaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
