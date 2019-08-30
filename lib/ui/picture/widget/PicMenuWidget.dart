import 'package:flutter/material.dart';
import 'package:xplan_flutter/model/common_model.dart';
import '../../../widget/cached_image.dart';

class PicMenuWidget extends StatelessWidget {
  final CommonModel commonModel;

  const PicMenuWidget({
    Key key,
    @required this.commonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          Expanded(child: Container(
              child: Image.asset(commonModel.icon),
              width: 36,
              height: 36
          )),
          Text(
            commonModel.title,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
