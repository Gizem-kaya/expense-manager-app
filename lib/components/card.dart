import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

Text buildCardTitle(String title) {
  return Text(
    capitalize(title),
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
  );
}

Text buildCardSubTitle(int amount) {
  return Text(
    '$amount ' + '\$',
    style: TextStyle(
      fontSize: 18,
      color: Colors.white70,
    ),
  );
}
