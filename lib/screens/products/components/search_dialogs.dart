import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 8,
          right: 8,
          child: Card(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              onFieldSubmitted: (text) {
                Navigator.of(context).pop(text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
