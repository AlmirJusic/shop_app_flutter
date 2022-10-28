import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem(this.id, this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context); //mora zbog async

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            icon: const Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            // onPressed: () {
            //   Provider.of<Products>(context, listen: false).deleteProduct(id);
            // },

            // ili upotrebom alert dialoga
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) {
                final navigator = Navigator.of(ctx); //mora zbog async
                return AlertDialog(
                  title: const Text('Are u sure?'),
                  content:
                      const Text('Do u want to remove the item from the cart?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Products>(context, listen: false)
                              .deleteProduct(id);
                          navigator.pop(true);
                        } catch (error) {
                          scaffold.hideCurrentSnackBar();
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text('Deleting failed!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          navigator.pop(true);
                        }
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            ),
            icon: const Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,
          ),
        ]),
      ),
    );
  }
}
