import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final ctt = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeProduct(id);
                } catch (error) {
                  ctt.showSnackBar(
                      SnackBar(content: Text('Deleting Fasiled!')));
                  //   await showDialog(
                  //     context: ctt,
                  //     builder: (ctx) => AlertDialog(
                  //       title: Text('An error occurred!'),
                  //       content: Text(
                  //           'Something went wrong, Can\'t delete this item.'),
                  //       actions: <Widget>[
                  //         FlatButton(
                  //           child: Text('Okay'),
                  //           onPressed: () {
                  //             Navigator.of(ctx).pop();
                  //           },
                  //         )
                  //       ],
                  //     ),
                  //   );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
