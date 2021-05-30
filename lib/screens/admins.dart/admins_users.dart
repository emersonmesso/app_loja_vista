import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:app_loja/commom/custom_drawer/custom_drawer.dart';
import 'package:app_loja/models/admin_orders_manager.dart';
import 'package:app_loja/models/admin_users.dart';
import 'package:app_loja/models/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __) {
          return AlphabetListScrollView(
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(
                  adminUsersManager.users[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.black),
                ),
                subtitle: Text(
                  adminUsersManager.users[index].email,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  context
                      .read<AdminOrdersManager>()
                      .setUserFilter(adminUsersManager.users[index]);
                  context.read<PageManager>().setPage(5);
                },
              );
            },
            highlightTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.names,
            showPreview: true,
          );
        },
      ),
    );
  }
}
