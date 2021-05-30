import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:app_loja/screens/checkout/components/card_back.dart';
import 'package:app_loja/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlipCard(
            key: cardKey,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(
              numberFocus: numberFocus,
              dateFocus: dateFocus,
              nameFocus: nameFocus,
              finished: () {
                cardKey.currentState.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              cvvFocus: cvvFocus,
            ),
          ),
          FlatButton(
            onPressed: () {
              cardKey.currentState.toggleCard();
            },
            textColor: Color(0xFF01579B),
            padding: EdgeInsets.zero,
            child: const Text('Virar cartão'),
          )
        ],
      ),
    );
  }
}
