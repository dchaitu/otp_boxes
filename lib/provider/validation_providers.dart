import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusNodeProvider = Provider((ref)=> FocusNode());
final usernameProvider = StateProvider<String>((ref)=> '');
final tokenProvider = StateProvider<String?>((ref) => null);
final showObscureTextProvider = StateProvider<bool>((ref)=> true);