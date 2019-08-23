import 'package:flutter/material.dart';
import 'package:xplan_flutter/model/common_model.dart';
import 'cached_image.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({
    Key key,
    @required this.localNavList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            child: Image.asset(model.icon),
            width: 32,
            height: 32,
          ),
//          Image.asset(model.icon),
//          CachedImage(
//            imageUrl: model.icon,
//            width: 32,
//            height: 32,
//          ),
          Text(model.title, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
