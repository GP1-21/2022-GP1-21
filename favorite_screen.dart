import '../favoret_screen/widgets/favoret_item_widget.dart';
import 'controller/favoret_controller.dart';
import 'models/favoret_item_model.dart';
import 'package:flutter/material.dart';
import 'package:shaden_s_application3/core/app_export.dart';
import 'package:shaden_s_application3/widgets/app_bar/appbar_image.dart';
import 'package:shaden_s_application3/widgets/app_bar/appbar_title.dart';
import 'package:shaden_s_application3/widgets/app_bar/custom_app_bar.dart';
import 'package:shaden_s_application3/widgets/custom_bottom_bar.dart';

class FavoretScreen extends GetWidget<FavoretController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray100,
        appBar: CustomAppBar(
          height: getVerticalSize(
            56.00,
          ),
          leadingWidth: 31,
          leading: AppbarImage(
            height: getSize(
              21.00,
            ),
            width: getSize(
              21.00,
            ),
            imagePath: ImageConstant.imgImage27,
            margin: getMargin(
              left: 10,
              top: 18,
              bottom: 16,
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(
            text: "lbl_favorite".tr,
          ),
          actions: [
            AppbarImage(
              height: getVerticalSize(
                39.00,
              ),
              width: getHorizontalSize(
                38.00,
              ),
              imagePath: ImageConstant.imgImage34,
              margin: getMargin(
                left: 19,
                top: 9,
                right: 19,
                bottom: 7,
              ),
            ),
          ],
        ),
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: getPadding(
                left: 13,
                top: 49,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: getPadding(
                      right: 22,
                    ),
                    child: Obx(
                      () => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller
                            .favoretModelObj.value.favoretItemList.length,
                        itemBuilder: (context, index) {
                          FavoretItemModel model = controller
                              .favoretModelObj.value.favoretItemList[index];
                          return FavoretItemWidget(
                            model,
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: getPadding(
                        left: 18,
                        top: 138,
                      ),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: getHorizontalSize(
                                145.00,
                              ),
                              child: Text(
                                "lbl_blvd_ruh_city".tr,
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular20,
                              ),
                            ),
                            Container(
                              width: getHorizontalSize(
                                145.00,
                              ),
                              margin: getMargin(
                                left: 9,
                              ),
                              child: Text(
                                "lbl_blvd_ruh_city".tr,
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular20,
                              ),
                            ),
                            Container(
                              width: getHorizontalSize(
                                145.00,
                              ),
                              margin: getMargin(
                                left: 36,
                              ),
                              child: Text(
                                "lbl_blvd_ruh_city".tr,
                                maxLines: null,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          onChanged: (BottomBarEnum type) {},
        ),
      ),
    );
  }
}
