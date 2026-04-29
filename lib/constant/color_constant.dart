import 'package:flutter/material.dart';

class ColorConstant {
  static const Color primaryColor = Color(0xFF8466CF);
  static const Color primaryColor2 = Color(0xFF8454E5);
  static const Color blackColor = Color(0xFF222222);
  static const Color whiteColor = Colors.white;
  static const Color borderColor = Color(0xffE5E5E5);
  static const Color grayColor = Color(0xffC2C2C2);
  static const Color grayTextColor = Color(0xff787878);
  static const Color bgColor = Color(0xffFAF8FF);
  static const Color redColor = Color(0xffD10A0D);
  static const Color redColor2 = Color(0xffFF1A01);
  static const Color lightPisTaColor = Color(0xff92AD25);
  static const Color reviewCardColor = Color(0xffF5F5F5);
  static const Color borderColor2 = Color(0xffE1E1E1);
  static const Color dividerColor = Color(0xffDBDBDB);
  static const Color lightColor = Color(0xffE5DBFF);
  static const Color disAbleColor = Color(0xffEEE8FF);
  static const Color review = Color(0xffEFEFEF);
  static const Color bankHistoryBorder = Color(0xffE6E6E6);
  static const Color idColor = Color(0xffADADAD);
  static const Color bgViewColor = Color(0xffFFF2F2);
  static const Color borderRedColor = Color(0xffFFC0C1);
  static const Color experienceColor = Color(0xffBCBCBC);
  static const Color orangeDotColor = Color(0xffCF8C66);
  static const Color gray = Color(0xffF7F7F7);
  static const Color orangeContainer = Color(0xffFCA421);
  static const Color totalContainer = Color(0xff3AB7C0);
  static const Color totalRevenueContainer = Color(0xff21BAFC);
  static const Color service = Color(0xffA5C03A);
  static const Color addServiceBorderColor = Color(0xffF1F1F1);
  static const Color editButtonColor = Color(0xffE2D6FF);
  static const Color lightRedColor = Color(0xffFFDBDB);
  static const Color serviceColor = Color(0xffE9E9E9);
  static const Color blueGrayColor = Color(0xff4D5967);
  static const Color viewDetailsColor = Color(0xffECECEC);
  static const Color callColor = Color(0xffDBD0F8);
  static const Color topRatedColor = Color(0xff696A6B);
  static const Color skyBlueColor = Color(0xff2178FC);
  static const Color divider2Color = Color(0xffE8E8E8);
  static const Color lightGreyColor = Color(0xFFD9D9D9);

  /// Booking history cards (purple border, magenta price, mint View button)
  static const Color bookingCardBorderPurple = Color(0xFF8B5CF6);
  static const Color bookingValuePurple = Color(0xFF8B5CF6);
  static const Color bookingPriceMagenta = Color(0xFFD946EF);
  static const Color bookingPriceMagenta2 = Color(0xFFCD73B4);
  static const Color bookingStatusCancelled = Color(0xFFB0B0B0);
  static const Color bookingViewMintBg = Color(0xFFE8F8EF);
  static const Color bookingViewGreen = Color(0xFF166534);

  /// Stylist appointment overview cards (Figma-style white tiles)
  static const Color appointmentCardNameTime = Color(0xFFD180C1);
  static const Color appointmentCardDateServices = Color(0xFF8360E1);
  static const Color appointmentCardViewButton = Color(0xFF8C52FF);

  /// Layered shadow similar to Material [Card] elevation (~3) for appointment tiles.
  static const List<BoxShadow> appointmentCardElevation = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 3),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];
  static const Color lightGreenColor = Color(0xFF01AB4D);

  /// Set Stylist Availability (Figma)
  static const Color stylistAvailabilityScreenBg = Color(0xFFEBEBEB);
  static const Color stylistAvailabilityAvatarPlaceholder = Color(0xFFD175B2);
  static const Color stylistStatusOff = Color(0xFFD15447);
  static const Color stylistStatusAvailable = Color(0xFF21AB5F);
  static const Color stylistStatusPartial = Color(0xFFF4D03F);
  static const Color stylistManageButtonBg = Color(0xFFD1C4E9);
  static const Color stylistManageButtonAccent = Color(0xFF9575CD);

  /// Manage Stylists list screen background
  static const Color manageStylistScreenBg = Color(0xFFF2F2F2);

  /// Stylist exception (blocked) cards
  static const Color exceptionDisabledLabel = Color(0xFFE53E3E);
  static const Color exceptionDateViolet = Color(0xFF7C3AED);
  static const Color exceptionTimePink = Color(0xFFD53F8C);
  static const Color exceptionDeleteRed = Color(0xFFE53E3E);
}
