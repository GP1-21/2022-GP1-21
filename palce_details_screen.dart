import '../palce_ditels_screen/widgets/listplacecounter_item_widget.dart';
import '../palce_ditels_screen/widgets/listrectanglefortyfive_item_widget.dart';
import 'controller/palce_ditels_controller.dart';
import 'models/listplacecounter_item_model.dart';
import 'models/listrectanglefortyfive_item_model.dart';
import 'package:flutter/material.dart';
import 'package:shaden_s_application3/core/app_export.dart';
import 'package:shaden_s_application3/widgets/app_bar/appbar_image.dart';
import 'package:shaden_s_application3/widgets/app_bar/appbar_title.dart';
import 'package:shaden_s_application3/widgets/app_bar/custom_app_bar.dart';
import 'package:shaden_s_application3/widgets/custom_icon_button.dart';

class PalceDitelsScreen extends GetWidget<PalceDitelsController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray100,
        appBar: CustomAppBar(
          height: getVerticalSize(
            56.00,
          ),
          leadingWidth: 39,
          leading: AppbarImage(
            height: getSize(
              21.00,
            ),
            width: getSize(
              21.00,
            ),
            imagePath: ImageConstant.imgImage27,
            margin: getMargin(
              left: 18,
              top: 18,
              bottom: 17,
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(
            text: "lbl_place_name".tr,
          ),
          actions: [
            CustomIconButton(
              height: 54,
              width: 53,
              margin: getMargin(
                left: 13,
                top: 1,
                right: 13,
                bottom: 1,
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgGroup7,
              ),
            ),
          ],
        ),
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: getPadding(
                left: 4,
                top: 18,
                right: 5,
                bottom: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: getPadding(
                        left: 34,
                        right: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                            svgPath: ImageConstant.imgArrow4,
                            height: getVerticalSize(
                              3.00,
                            ),
                            width: getHorizontalSize(
                              1.00,
                            ),
                            margin: getMargin(
                              top: 108,
                              bottom: 105,
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.img5,
                            height: getVerticalSize(
                              216.00,
                            ),
                            width: getHorizontalSize(
                              220.00,
                            ),
                            radius: BorderRadius.circular(
                              getHorizontalSize(
                                20.00,
                              ),
                            ),
                            margin: getMargin(
                              left: 47,
                            ),
                          ),
                          Spacer(),
                          CustomImageView(
                            svgPath: ImageConstant.imgArrow3,
                            height: getVerticalSize(
                              3.00,
                            ),
                            width: getHorizontalSize(
                              1.00,
                            ),
                            margin: getMargin(
                              top: 108,
                              bottom: 105,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      left: 21,
                      top: 41,
                      right: 60,
                    ),
                    child: Obx(
                      () => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.palceDitelsModelObj.value
                            .listrectanglefortyfiveItemList.length,
                        itemBuilder: (context, index) {
                          ListrectanglefortyfiveItemModel model = controller
                              .palceDitelsModelObj
                              .value
                              .listrectanglefortyfiveItemList[index];
                          return ListrectanglefortyfiveItemWidget(
                            model,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      368.00,
                    ),
                    margin: getMargin(
                      left: 8,
                      top: 42,
                    ),
                    padding: getPadding(
                      left: 2,
                      top: 7,
                      right: 2,
                      bottom: 7,
                    ),
                    decoration: AppDecoration.fillGreen20066.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: getPadding(
                            left: 2,
                            top: 1,
                          ),
                          child: Text(
                            "lbl_place_details".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: AppStyle.txtInterBold14,
                          ),
                        ),
                        Container(
                          width: getHorizontalSize(
                            355.00,
                          ),
                          margin: getMargin(
                            left: 2,
                            top: 13,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "\n".tr,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: "msg_riyadh_boulevared2".tr,
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 2,
                            top: 10,
                          ),
                          child: Text(
                            "lbl_place_timing".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInterBold14,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 7,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle43,
                                height: getVerticalSize(
                                  21.00,
                                ),
                                width: getHorizontalSize(
                                  20.00,
                                ),
                                margin: getMargin(
                                  bottom: 1,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  left: 7,
                                  top: 5,
                                ),
                                child: Text(
                                  "msg_4_00_pm_2_00_am".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterMedium14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: getVerticalSize(
                        2.00,
                      ),
                      width: getHorizontalSize(
                        350.00,
                      ),
                      margin: getMargin(
                        top: 44,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstant.gray600,
                      ),
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      181.00,
                    ),
                    width: getHorizontalSize(
                      381.00,
                    ),
                    margin: getMargin(
                      top: 58,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: getVerticalSize(
                              99.00,
                            ),
                            width: getHorizontalSize(
                              3.00,
                            ),
                            margin: getMargin(
                              top: 19,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.gray600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: getVerticalSize(
                              181.00,
                            ),
                            width: getHorizontalSize(
                              381.00,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.green20033,
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(
                                  20.00,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      222.00,
                    ),
                    child: Obx(
                      () => ListView.builder(
                        padding: getPadding(
                          left: 10,
                          top: 77,
                          right: 5,
                        ),
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.palceDitelsModelObj.value
                            .listplacecounterItemList.length,
                        itemBuilder: (context, index) {
                          ListplacecounterItemModel model = controller
                              .palceDitelsModelObj
                              .value
                              .listplacecounterItemList[index];
                          return ListplacecounterItemWidget(
                            model,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      2.00,
                    ),
                    width: getHorizontalSize(
                      239.00,
                    ),
                    margin: getMargin(
                      left: 10,
                      top: 21,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
