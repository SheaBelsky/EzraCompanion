import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
    final List<Widget> children;

    final String errorToShow;

    final TextStyle _rowTextStyle = new TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
    );

    ErrorPage({
        Key key,
        this.children,
        this.errorToShow
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: new EdgeInsets.all(25.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    new Icon(Icons.error),
                    SizedBox(height: 30),
                    new Text(
                        errorToShow,
                        style: _rowTextStyle,
                        textAlign: TextAlign.center
                    ),
                    ...(children is List ? children : [])
                ]
            )
        );
    }
}

