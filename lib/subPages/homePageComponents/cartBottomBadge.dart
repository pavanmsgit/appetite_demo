import 'package:appetite_demo/helpers/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CartBottomBadge extends StatelessWidget {
  final int itemCount;
  final String itemTotalPrice;
  final VoidCallback onPress;

  final bool shouldShowPrice;

  const CartBottomBadge(
      {Key key,
      @required this.onPress,
      @required this.itemCount,
      this.itemTotalPrice,
      this.shouldShowPrice = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        margin: EdgeInsets.only(
            bottom: defaultTargetPlatform == TargetPlatform.android ? 10 : 20),
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        itemCount.toString() + " ITEMS",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        visible: shouldShowPrice,
                        child: VerticalDivider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                      Visibility(
                        visible: shouldShowPrice,
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      Visibility(
                        visible: shouldShowPrice,
                        child: Text(
                          itemTotalPrice == null ? "" : itemTotalPrice,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Place Order >",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  )
                ],
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1.0),
              foregroundColor: MaterialStateProperty.all<Color>(primary),
              backgroundColor: MaterialStateProperty.all<Color>(tertiary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: tertiary),
                ),
              ),
            ),
            onPressed: onPress),
      ),
    );
  }
}
