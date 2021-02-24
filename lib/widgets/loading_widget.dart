import 'package:flutter/material.dart';
 
class LoadingWidget extends StatelessWidget {
  final String loadingMessage;
 
  const LoadingWidget({Key key, this.loadingMessage}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
          SizedBox(height: 24),
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}