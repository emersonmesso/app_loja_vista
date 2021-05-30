import 'package:flutter/material.dart';
import 'package:app_loja/models/home_manager.dart';
import 'package:app_loja/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager);

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            textColor: Color(0xFF2661FA),
            child: const Text('Adicionar Lista'),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered'));
            },
            textColor: Color(0xFF2661FA),
            child: const Text('Adicionar Grade'),
          ),
        ),
      ],
    );
  }
}
