import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';

import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/color_constant.dart';
import '../../project_specific/project_appbar.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final _bankHolderName = TextEditingController();
  final _branchCode = TextEditingController();
  final _accountNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Add a bank account",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _selectBankAccount(),
                  const SizedBox(height: 20),
                  SimpleTextFieldWidget(
                      textEditingController: _bankHolderName,
                      hintText: "Enter Here",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Enter Account Holder Name"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SimpleTextFieldWidget(
                            textEditingController: _branchCode,
                            hintText: "Enter Here",
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            title: "Branch Code"),
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
                  )
                ],
              ),
            ),
          ),
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
                          fontSize: 13, color: ColorConstant.grayTextColor),
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
    );
  }

  /*-------------- Select Bank Account ---------------*/
  _selectBankAccount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Bank",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            hint: Text(
              'Bank',
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.grayColor, fontSize: 13),
            ),
            items: bankNameList
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,
                          style: AppTextTheme.medium.copyWith(
                              color: ColorConstant.blackColor, fontSize: 13)),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Bank';
              }
              return null;
            },
            onChanged: (value) {
              //Do something when selected item is changed.
            },
            onSaved: (value) {
              /* selectedValue = value.toString();*/
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  /*-------------- do Add Bank Account ------------*/
  _doAddBankAccount() {
    if (_bankHolderName.text.isEmpty) {
      showMessage("Please enter bank holder name");
    } else if (_branchCode.text.isEmpty) {
      showMessage("Please enter branch code");
    } else if (_accountNumber.text.isEmpty) {
      showMessage("Please enter account number");
    } else {
      Get.back();
      Get.back();
    }
  }

  /*------------ Bank Name List --------------*/
  final List<String> bankNameList = [
    ' Andhra Bank',
    ' Axis Bank',
    ' Bank of Baroda - Corporate Banking',
    ' Bank of India',
    ' Canara Bank',
    ' Central Bank of India',
    ' ICICI Bank',
    ' IDBI Bank',
    ' Indian Bank',
    ' Indian Overseas Bank',
    ' SBI',
    'Yes Bank',
  ];
}
