class APIEndPoint {
  /*--------------- AUTH ---------------------------*/
  static const String salonRegister = "auth/salon/signup";
  static const String salonSendVerificationCode =
      "auth/salon/send/verification-code";
  static const String verifyVerificationCode =
      "auth/salon/verify/verification-code";
  static const String salonLoginPassword = "auth/salon/login/password";
  static const String loginMobileVerificationCode =
      "auth/salon/login/mobile-verification-code";
  static const String refreshToken = "auth/refresh";

  /*-------------- Home API -------------------*/
  static const String eligibility = "salon/onboarding/eligibility";
  static const String serviceCategory = "salon/service/category/list";
  static const String productList = "salon/service/product/list";
  static const String productAdd = "salon/product/add";

  /*-------------------- Service API -------------------- */
  static const String serviceAdd = "salon/service/add";
  static const String getServiceList = "salon/service/list?status[]=active";
  static const String salonArtist = "salon/artist/add";

  /*-------------------- Content / Blog API --------------------*/
  static const String salonContentList = "salon/blog/salon-blogs";
  static const String salonContentAdd = "salon/blog/add";
  // update → PUT "salon/blog/$id"   delete → DELETE "salon/blog/$id"

  /*------------- Artiest AUTH  -------------*/
  static const String salonArtiestLoginPassword = "auth/artist/login/password";

  /*------------- Menu Change API ---------*/
static const String menuChangeRequest = "salon/account/menu/change-request"
    "";
}
