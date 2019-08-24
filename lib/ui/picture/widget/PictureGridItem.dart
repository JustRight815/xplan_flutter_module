import 'package:flutter/material.dart';
import 'package:xplan_flutter/model/common_model.dart';
import 'package:xplan_flutter/widget/cached_image.dart';

class PictureGridItem extends StatelessWidget {
  final CommonModel commonModel;

  const PictureGridItem({
    Key key,
    @required this.commonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _items(context);
  }

  Widget _items(BuildContext context) {
    if (commonModel == null) return null;
    return _item(context, commonModel);
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CachedImage(
            imageUrl: model.icon,
            fit: BoxFit.cover,
          ),
          Text(model.title, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
