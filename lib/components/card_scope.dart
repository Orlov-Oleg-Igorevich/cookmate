import 'dart:convert';

import 'package:cookmate/models/recipe.model.dart';
import 'package:cookmate/services/storage.service.dart';
import 'package:flutter/material.dart';

class CardState {
  final bool isFavorite;
  final bool isOpened;

  CardState({this.isFavorite = false, this.isOpened = false});

  CardState copyWith({bool? isFavorite, bool? isOpened}) {
    return CardState(
      isFavorite: isFavorite ?? this.isFavorite,
      isOpened: isOpened ?? this.isOpened,
    );
  }
}

abstract class CardAspect {
  static const isFavorite = 'isFavorite';
  static const isOpened = 'IsOpened';
}

class CardScope extends InheritedModel<String> {
  final CardState state;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleOpen;

  const CardScope({
    super.key,
    required this.state,
    required this.onToggleFavorite,
    required this.onToggleOpen,
    required super.child,
  });

  static CardScope of(BuildContext context, {String? aspect}) {
    final scope = InheritedModel.inheritFrom<CardScope>(context);
    if (scope != null) {
      return scope;
    }

    throw FlutterError(
      'CardScope.of() вызывается с контекстом, в котором не содержится CardScope.\n'
      'Это может произойти, если используемый контекст не является потомком CardScope.',
    );
  }

  @override
  bool updateShouldNotify(CardScope oldWidget) {
    return state != oldWidget.state;
  }

  @override
  bool updateShouldNotifyDependent(
    CardScope oldWidget,
    Set<String> dependencies,
  ) {
    if (dependencies.contains(CardAspect.isFavorite) &&
        state.isFavorite != oldWidget.state.isFavorite) {
      return true;
    }
    if (dependencies.contains(CardAspect.isOpened) &&
        state.isOpened == oldWidget.state.isOpened) {
      return true;
    }

    return false;
  }
}

class CardProvider extends StatefulWidget {
  final Widget child;
  final Recipe recipe;
  const CardProvider({required this.recipe, required this.child, super.key});

  @override
  State<CardProvider> createState() => _CardProviderState();
}

class _CardProviderState extends State<CardProvider> {
  late CardState _state;
  final StorageService storage = StorageService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _state = CardState();
    _initializeData();
  }

  void _initializeData() {
    final result = storage.getFromStorage(widget.recipe.id);
    if (result != null) {
      setState(() {
        _state = _state.copyWith(isFavorite: true);
      });
    }
  }

  void _handleToggleFavorite() {
    if (_state.isFavorite) {
      storage.removeFromStorage(widget.recipe.id);
    } else {
      storage.writeToStorage(
        key: widget.recipe.id,
        value: jsonEncode(widget.recipe.toJson()),
      );
    }
    setState(() {
      _state = _state.copyWith(isFavorite: !_state.isFavorite);
    });
  }

  void _handleToggleOpened() {
    setState(() {
      _state = _state.copyWith(isOpened: !_state.isOpened);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardScope(
      state: _state,
      onToggleFavorite: _handleToggleFavorite,
      onToggleOpen: _handleToggleOpened,
      child: widget.child,
    );
  }
}
