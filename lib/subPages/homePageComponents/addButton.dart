import 'package:appetite_demo/helpers/style.dart';
import 'package:flutter/material.dart';


const double buttonHeight = 40;
const double buttonWidth = 94;
const double iconSize = 18;

class AddButton extends StatefulWidget {

  final int quantity;
  final Function onInteractedCallback;

  AddButton({Key key, @required this.onInteractedCallback, this.quantity = 0}) : super(key: key);
  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton>
    with SingleTickerProviderStateMixin {

  bool _isActivated = false;
  int _counterValue = 0;

  @override
  void initState() {
    _counterValue = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        child: Stack(
          children: [
            AddCounter(
              counterValue: _counterValue,
              onAddPress: () {
                setState(() {
                  _counterValue++;
                });
                widget.onInteractedCallback(_counterValue);

              },
              onRemovePress: () {
                setState(() {
                  _counterValue--;
                  if (_counterValue == 0) {
                    _isActivated = false;
                  }
                });
                widget.onInteractedCallback(_counterValue);
              },
            ),
            Visibility(
              child: AddOverlay(
                onPress: () {
                  setState(() {
                    _isActivated = true;
                    _counterValue = 1;
                  });
                  widget.onInteractedCallback(_counterValue);
                },
              ),
              visible: !_isActivated,
            ),
          ],
        ),
      ),
    );
  }
}

class AddOverlay extends StatelessWidget {
  final VoidCallback onPress;

  const AddOverlay({Key key, @required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        child: TextButton(
            child: Text("+ ADD",
                style: TextStyle(
                    color: tertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(primary2),
              foregroundColor: MaterialStateProperty.all<Color>(primary2),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 1, color: Colors.white)),
              ),
            ),
            onPressed: onPress),
      ),
    );
  }
}

class AddCounter extends StatelessWidget {
  final int counterValue;
  final VoidCallback onAddPress;
  final VoidCallback onRemovePress;

  const AddCounter(
      {Key key, @required this.counterValue, @required this.onAddPress, @required this.onRemovePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: tertiary,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
             BoxShadow(
                color: tertiary,
                blurRadius: 1.0,
                offset: Offset(0.5, 0.5))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                  padding: EdgeInsets.only(left: 5),
                  onPressed: onRemovePress,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: iconSize,
                  )),
            ),
            Container(
              width: 32,
              height: buttonHeight,
              child: Center(
                child: Text(
                  counterValue.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                padding: EdgeInsets.only(right: 5),
                alignment: Alignment.center,
                onPressed: onAddPress,
                icon: Icon(
                  Icons.add,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
