import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/variable_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../constant/color_constant.dart';
import '../../project_specific/project_appbar.dart';
import 'bank_list_sheet.dart';

class AddBankAccountPage extends StatefulWidget {
  final VoidCallback callback;
  const AddBankAccountPage({super.key, required this.callback});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final _bankHolderName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _branchName = TextEditingController();
  final _ifscCode = TextEditingController();

  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBarWidget(
        nameOfScreen: "Add a bank account",
        isBackIcon: true,
        callback: () {
          widget.callback.call();
        },
      ),
      body: Obx(
        () => ProgressContainerView(
          isProgressRunning: _homeController.showProgress,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _selectBankAccount(),
                const SizedBox(height: 20),
                _selectBankType(),
                const SizedBox(height: 20),
                SimpleTextFieldWidget(
                    textEditingController: _bankHolderName,
                    hintText: "Enter Here",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Enter Account Holder Name"),
                const SizedBox(height: 20),
                SimpleTextFieldWidget(
                    textEditingController: _branchName,
                    hintText: "Enter Here",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Branch Name"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SimpleTextFieldWidget(
                          textEditingController: _ifscCode,
                          hintText: "Enter Here",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "IfscCode"),
                    ),
                    Expanded(
                      child: SimpleTextFieldWidget(
                          textEditingController: _accountNumber,
                          hintText: "Enter Here",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          title: "Account Number"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Need help finding these numbers?",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.grayTextColor),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Learn more",
                          style: AppTextTheme.medium.copyWith(
                              color: ColorConstant.blackColor, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "By adding this bank account, i agree to payment",
                            style: AppTextTheme.regular.copyWith(
                                fontSize: 13,
                                color: ColorConstant.grayTextColor),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "T&Cs",
                            style: AppTextTheme.regular.copyWith(
                                fontSize: 13, color: ColorConstant.blackColor),
                          ),
                        ],
                      ),
                      Text(
                        "regarding topping up from bank account",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.grayTextColor),
                      ),
                      const SizedBox(height: 20),
                      ButtonWidget(
                          buttonTitleText: "Add bank Account",
                          onPress: () {
                            _doAddBankAccount();
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*-------------- Select Bank Account ---------------*/
  _selectBankAccount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: false,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              )),
              context: context,
              builder: (context) {
                return BankListSheet(
                  callback: () {
                    setState(() {});
                  },
                );
              });
        },
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorConstant.borderColor,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              bankName.isEmpty
                  ? Text(
                      "Select Bank",
                      style: AppTextTheme.regular.copyWith(
                          fontSize: 13, color: ColorConstant.blackColor),
                    )
                  : Text(
                      bankName,
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          fontSize: 13, color: ColorConstant.blackColor),
                    ),
              const SizedBox(height: 12),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*----------------  Select Bank  Type ---------------------*/
  int selectBankType = 0;
  _selectBankType() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Account Type",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectBankType = 0;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorConstant.blackColor),
                      ),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectBankType == 0
                                ? ColorConstant.primaryColor
                                : Colors.transparent),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Current",
                      style: AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.blackColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectBankType = 1;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorConstant.blackColor),
                      ),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectBankType == 1
                                ? ColorConstant.primaryColor
                                : Colors.transparent),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Savings",
                      style: AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.blackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*-------------- do Add Bank Account ------------*/
  _doAddBankAccount() {
    if (_bankHolderName.text.isEmpty) {
      showMessage("Please enter bank holder name");
      return;
    } else if (_accountNumber.text.isEmpty) {
      showMessage("Please enter bank account number");
      return;
    } else if (_branchName.text.isEmpty) {
      showMessage("Please enter branch name");
      return;
    } else if (_ifscCode.text.isEmpty) {
      showMessage("Please enter ifsc code");
      return;
    } else if (bankName.isEmpty || bankImage.isEmpty) {
      showMessage("Please select bank");
      return;
    } else {
      _homeController.doAddSalonBankAccount(
          account: {
            "accountType": selectBankType == 0 ? "current" : "savings",
            "accountNumber": _accountNumber.text,
            "ifscCode": _ifscCode.text,
            "bankName": bankName,
            "branchName": _branchName.text,
            "accountHolderName": _bankHolderName.text,
            "isPrimary": true,
            "bankIconImage": bankImage
          },
          callback: () {
            widget.callback.call();
            Get.back();
          });
    }
  }
}
