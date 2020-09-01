import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';

loadingScreen() {
  return SpinKitFoldingCube(
    color: kPrimaryColor,
    duration: Duration(seconds: 2),
  );
}
