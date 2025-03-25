library dropdown_search;

import 'dart:async';

 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/util/dropdown/popupMenu.dart';
import 'package:salon/util/dropdown/popup_safearea.dart';
import 'package:salon/util/dropdown/scrollbar_props.dart';
import 'package:salon/util/dropdown/selectDialog.dart';
import 'package:salon/util/dropdown/text_field_props.dart';



typedef Future<List<T>> DropdownSearchOnFind<T>(String text);
typedef Future<List<T>> DropdownSearchOnLoadMore<T>(String text, int offset);
typedef String DropdownSearchItemAsString<T>(T item);
typedef bool DropdownSearchFilterFn<T>(T item, String filter);
typedef bool DropdownSearchCompareFn<T>(T item, T? selectedItem);
typedef Widget DropdownSearchBuilder<T>(
    BuildContext context, T? selectedItem, String itemAsString);
typedef Widget DropdownSearchPopupItemBuilder<T>(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef bool DropdownSearchPopupItemEnabled<T>(T item);
typedef Widget ErrorBuilder<T>(
    BuildContext context, String? searchEntry, dynamic exception);
typedef Widget EmptyBuilder<T>(BuildContext context, String? searchEntry);
typedef Widget LoadingBuilder<T>(BuildContext context, String? searchEntry);
typedef Widget IconButtonBuilder(BuildContext context);
typedef Future<bool?> BeforeChange<T>(T prevItem, T nextItem);

typedef Widget FavoriteItemsBuilder<T>(BuildContext context, T item);

typedef List<T> FavoriteItems<T>(List<T> items);

enum Mode { DIALOG, BOTTOM_SHEET, MENU }

class DropdownSearch<T> extends StatefulWidget {
  final String? label;

  final String? hint;

  final bool showSearchBox;

  final bool isFilteredOnline;

  final bool showClearButton;

  final List<T>? items;

  final T? selectedItem;

  final DropdownSearchOnFind<T>? onFind;

  final DropdownSearchOnLoadMore<T>? onLoadMore;

  final ValueChanged<T?>? onChanged;

  final DropdownSearchBuilder<T>? dropdownBuilder;

  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;

  @Deprecated('Use `searchFieldProps` instead')
  final InputDecoration? searchBoxDecoration;

  final Color? popupBackgroundColor;

  final Widget? popupTitle;

  final DropdownSearchItemAsString<T>? itemAsString;

  final DropdownSearchFilterFn<T>? filterFn;

  final bool enabled;

  final Mode mode;

  final double? maxHeight;

  final double? dialogMaxWidth;

  final bool showSelectedItem;

  final DropdownSearchCompareFn<T>? compareFn;

  final InputDecoration? dropdownSearchDecoration;

  final TextStyle? dropdownSearchBaseStyle;

  final TextAlign? dropdownSearchTextAlign;

  final TextAlignVertical? dropdownSearchTextAlignVertical;

  final EmptyBuilder? emptyBuilder;

  final LoadingBuilder? loadingBuilder;

  final ErrorBuilder? errorBuilder;

  @Deprecated('Use `searchFieldProps` instead')
  final bool autoFocusSearchBox;

  final ShapeBorder? popupShape;

  final AutovalidateMode autoValidateMode;

  final FormFieldSetter<T>? onSaved;

  final FormFieldValidator<T>? validator;

  final Widget? clearButton;

  final IconButtonBuilder? clearButtonBuilder;

  final double? clearButtonSplashRadius;

  final Widget? dropDownButton;

  @Deprecated('Use `searchFieldProps` instead')
  final TextStyle? searchBoxStyle;

  final IconButtonBuilder? dropdownButtonBuilder;

  final double? dropdownButtonSplashRadius;

  final bool showAsSuffixIcons;

  final bool dropdownBuilderSupportsNullItem;

  final DropdownSearchPopupItemEnabled<T>? popupItemDisabled;

  final Color? popupBarrierColor;

  @Deprecated('Use `searchFieldProps` instead')
  final TextEditingController? searchBoxController;

  final VoidCallback? onPopupDismissed;

  final Duration? searchDelay;

  final BeforeChange<T?>? onBeforeChange;

  final bool showFavoriteItems;

  final FavoriteItemsBuilder<T>? favoriteItemBuilder;

  final FavoriteItems<T>? favoriteItems;

  final MainAxisAlignment? favoriteItemsAlignment;

  final PopupSafeArea popupSafeArea;

  final TextFieldProps? searchFieldProps;

  final ScrollbarProps? scrollbarProps;

  final bool popupBarrierDismissible;

  DropdownSearch({
    Key? key,
    this.onSaved,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.mode = Mode.DIALOG,
    this.label,
    this.hint,
    this.isFilteredOnline = false,
    this.popupTitle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.onLoadMore,
    this.dropdownBuilder,
    this.popupItemBuilder,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.searchBoxDecoration,
    this.popupBackgroundColor,
    this.enabled = true,
    this.maxHeight,
    this.filterFn,
    this.itemAsString,
    this.showSelectedItem = false,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.autoFocusSearchBox = false,
    this.dialogMaxWidth,
    this.clearButton,
    this.clearButtonBuilder,
    this.clearButtonSplashRadius,
    this.dropDownButton,
    this.dropdownButtonBuilder,
    this.dropdownButtonSplashRadius,
    this.showAsSuffixIcons = true,
    this.dropdownBuilderSupportsNullItem = false,
    this.popupShape,
    this.popupItemDisabled,
    this.popupBarrierColor,
    this.onPopupDismissed,
    this.searchBoxController,
    this.searchDelay,
    this.onBeforeChange,
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.showFavoriteItems = false,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.searchBoxStyle,
    this.popupSafeArea = const PopupSafeArea(),
    this.searchFieldProps,
    this.scrollbarProps,
    this.popupBarrierDismissible = true,
    this.dropdownSearchBaseStyle,
    this.dropdownSearchTextAlign,
    this.dropdownSearchTextAlignVertical,
  })  : assert(!showSelectedItem || T == String || compareFn != null),
        super(key: key);

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<T?> _selectedItemNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _selectedItemNotifier.value = widget.selectedItem;
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    final oldSelectedItem = oldWidget.selectedItem;
    final newSelectedItem = widget.selectedItem;
    if (oldSelectedItem != newSelectedItem) {
      _selectedItemNotifier.value = newSelectedItem;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: _selectedItemNotifier,
      builder: (context, data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: InkWell(
            onTap: () => _selectSearchMode(data),
            child: _formField(data),
          ),
        );
      },
    );
  }

  Widget _defaultSelectItemWidget(T? data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: widget.dropdownBuilder != null
              ? widget.dropdownBuilder!(
                  context,
                  data,
                  _selectedItemAsString(data),
                )
              : Text(_selectedItemAsString(data),
                  style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
        ),
        if (widget.showAsSuffixIcons) _manageTrailingIcons(data),
      ],
    );
  }

  Widget _formField(T? value) {
    return FormField(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(value);
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownSearchBaseStyle,
                textAlign: widget.dropdownSearchTextAlign,
                textAlignVertical: widget.dropdownSearchTextAlignVertical,
                isEmpty: value == null &&
                    (widget.dropdownBuilder == null ||
                        widget.dropdownBuilderSupportsNullItem),
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state, value),
                child: _defaultSelectItemWidget(value),
              );
            });
      },
    );
  }

  InputDecoration _manageDropdownDecoration(FormFieldState state, T? data) {
    return (widget.dropdownSearchDecoration ??
            const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder()))
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
            enabled: widget.enabled,
            labelText: widget.label,
            hintText: widget.hint,
            isDense: true,
            errorText: state.errorText);
  }

  String _selectedItemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  Widget _manageTrailingIcons(T? data) {
    final clearButtonPressed = () => _handleOnChangeSelectedItem(null);
    final dropdownButtonPressed = () => _selectSearchMode(data);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (data != null && widget.showClearButton == true)
          widget.clearButtonBuilder != null
              ? InkWell(
                  onTap: clearButtonPressed,
                  child: widget.clearButtonBuilder!(context),
                )
              : InkWell(
                  onTap: clearButtonPressed,
                  child:
                      widget.clearButton ?? const Icon(Icons.clear, size: 24),
                ),
        widget.dropdownButtonBuilder != null
            ? InkWell(
                onTap: dropdownButtonPressed,
                child: widget.dropdownButtonBuilder!(context),
              )
            : InkWell(
                onTap: dropdownButtonPressed,
                child: widget.dropDownButton ??
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 26,
                      color: Colors.white,
                    ),
              )
      ],
    );
  }

  Future<T?> _openSelectDialog(T? data) {
    return showGeneralDialog(
      barrierDismissible: widget.popupBarrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      barrierColor: widget.popupBarrierColor ?? const Color(0x80000000),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          top: widget.popupSafeArea.top,
          bottom: widget.popupSafeArea.bottom,
          left: widget.popupSafeArea.left,
          right: widget.popupSafeArea.right,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: widget.popupShape ??
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
            backgroundColor: widget.popupBackgroundColor,
            content: _selectDialogInstance(data),
          ),
        );
      },
    );
  }

  Future<T?> _openBottomSheet(T? data) {
    return showModalBottomSheet<T>(
        barrierColor: widget.popupBarrierColor,
        backgroundColor: Colors.transparent,
        isDismissible: widget.popupBarrierDismissible,
        isScrollControlled: true,
        shape: widget.popupShape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
        context: context,
        builder: (ctx) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Theme.of(ctx),
            builder: (_, child) {
              return SafeArea(
                top: widget.popupSafeArea.top,
                bottom: widget.popupSafeArea.bottom,
                left: widget.popupSafeArea.left,
                right: widget.popupSafeArea.right,
                child: Container(
                  color:
                      widget.popupBackgroundColor ?? Theme.of(ctx).canvasColor,
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom,
                    ),
                    child: _selectDialogInstance(data, defaultHeight: 350),
                  ),
                ),
              );
            },
          );
        });
  }

  Future<T?> _openMenu(T? data) {
    final RenderBox popupButtonObject = context.findRenderObject() as RenderBox;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromSize(
      Rect.fromPoints(
        popupButtonObject.localToGlobal(
            popupButtonObject.size.bottomLeft(Offset.zero),
            ancestor: overlay),
        popupButtonObject.localToGlobal(
            popupButtonObject.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Size(overlay.size.width, overlay.size.height),
    );
    return customShowMenu<T>(
        popupSafeArea: widget.popupSafeArea,
        barrierColor: widget.popupBarrierColor,
        shape: widget.popupShape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
        color: widget.popupBackgroundColor,
        context: context,
        position: position,
        elevation: 8,
        barrierDismissible: widget.popupBarrierDismissible,
        items: [
          CustomPopupMenuItem(
            enabled: false,
            child: SizedBox(
              width: popupButtonObject.size.width,
              child: _selectDialogInstance(data, defaultHeight:200),
            ),
          ),
        ]);
  }

  SelectDialog<T> _selectDialogInstance(T? data, {double? defaultHeight}) {
    return SelectDialog<T>(
      searchBoxStyle: widget.searchBoxStyle,
      popupTitle: Material(child: widget.popupTitle),
      maxHeight: widget.maxHeight ?? defaultHeight,
      isFilteredOnline: widget.isFilteredOnline,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      onFind: widget.onFind,
      onLoadMore: widget.onLoadMore,
      showSearchBox: widget.showSearchBox,
      itemBuilder: widget.popupItemBuilder,
      selectedValue: data,
      searchBoxDecoration: widget.searchBoxDecoration ??
          const InputDecoration(
              contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
      onChanged: _handleOnChangeSelectedItem,
      showSelectedItem: widget.showSelectedItem,
      compareFn: widget.compareFn,
      emptyBuilder: widget.emptyBuilder,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      autoFocusSearchBox: widget.autoFocusSearchBox,
      dialogMaxWidth: widget.dialogMaxWidth,
      itemDisabled: widget.popupItemDisabled,
      searchBoxController:
          widget.searchBoxController ?? TextEditingController(),
      searchDelay: widget.searchDelay,
      showFavoriteItems: widget.showFavoriteItems,
      favoriteItems: widget.favoriteItems,
      favoriteItemBuilder: widget.favoriteItemBuilder,
      favoriteItemsAlignment: widget.favoriteItemsAlignment,
      searchFieldProps: widget.searchFieldProps ??
          TextFieldProps(

            decoration: InputDecoration(
              hintStyle:   Get.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.gray),
              hintText: widget.hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              focusColor: Colors.grey[400],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            ),
          ),
      scrollbarProps: widget.scrollbarProps,
    );
  }

  void _handleFocus(bool isFocused) {
    if (isFocused && !_isFocused.value) {
      FocusScope.of(context).unfocus();
      _isFocused.value = true;
    } else if (!isFocused && _isFocused.value) {
      _isFocused.value = false;
    }
  }

  void _handleOnChangeSelectedItem(T? selectedItem) {
    changeItem() {
      _selectedItemNotifier.value = selectedItem;
      if (widget.onChanged != null) {
        FocusScope.of(context).requestFocus(FocusNode());
        widget.onChanged!(selectedItem);
      }
    }

    if (widget.onBeforeChange != null) {
      widget.onBeforeChange!(_selectedItemNotifier.value, selectedItem)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else {
      changeItem();
    }

    _handleFocus(false);
  }

  Future<T?> _selectSearchMode(T? data) async {
    _handleFocus(true);
    T? selectedItem;
    if (widget.mode == Mode.MENU) {
      selectedItem = await _openMenu(data);
    } else if (widget.mode == Mode.BOTTOM_SHEET) {
      selectedItem = await _openBottomSheet(data);
    } else {
      selectedItem = await _openSelectDialog(data);
    }
    _handleFocus(false);
    widget.onPopupDismissed?.call();

    return selectedItem;
  }

  Future<T?> openDropDownSearch() =>
      _selectSearchMode(_selectedItemNotifier.value);

  void changeSelectedItem(T selectedItem) =>
      _handleOnChangeSelectedItem(selectedItem);

  void clear() => _handleOnChangeSelectedItem(null);

  T? get getSelectedItem => _selectedItemNotifier.value;
  bool get isFocused => _isFocused.value;
}
