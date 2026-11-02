// The on-screen keyboard: the Echo has no input method.  Keys go to the WebView as real key events
// (MainActivity.kt, channel "hassmic/keys"); a character the key map lacks is inserted by script.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef InsertText = Future<void> Function(String text);

class Keyboard extends StatefulWidget {
  final bool numbers;                   // a number field: the digits first
  final InsertText fallback;
  final VoidCallback onHide;
  const Keyboard({super.key, required this.numbers, required this.fallback, required this.onHide});
  @override
  State<Keyboard> createState() => _KeyboardState();
}

const _letters = [
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
  ['⇧', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⌫'],
  ['?123', '@', ' ', '.', '⏎', '⌄'],
];
const _symbols = [
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  ['@', '#', r'$', '%', '&', '*', '-', '+', '(', ')'],
  ['=', '!', '"', "'", ':', ';', '/', '?', '⌫'],
  ['ABC', ',', ' ', '.', '⏎', '⌄'],
];
const _special = {'⇧', '⌫', '?123', 'ABC', '⏎', '⌄'};

class _KeyboardState extends State<Keyboard> {
  static const _keys = MethodChannel('hassmic/keys');
  late bool symbols = widget.numbers;
  bool shift = false;
  Timer? _repeat;

  @override
  void didUpdateWidget(Keyboard old) {
    super.didUpdateWidget(old);
    if (old.numbers != widget.numbers) symbols = widget.numbers;
  }

  Future<void> _key(String code) => _keys.invokeMethod('key', code);
  Future<void> _text(String s) async {
    final ok = await _keys.invokeMethod<bool>('text', s) ?? false;
    if (!ok) await widget.fallback(s);
  }

  void _down(String k) {
    if (k == '⌫') {
      _key('backspace');
      _repeat = Timer(const Duration(milliseconds: 450), () {
        _repeat = Timer.periodic(const Duration(milliseconds: 70), (_) => _key('backspace'));
      });
    }
  }

  void _up(String k) {
    _repeat?.cancel();
    switch (k) {
      case '⌫':
        break;
      case '⇧':
        setState(() => shift = !shift);
      case '?123':
        setState(() => symbols = true);
      case 'ABC':
        setState(() => symbols = false);
      case '⏎':
        _key('enter');
      case '⌄':
        widget.onHide();
      default:
        _text(shift ? k.toUpperCase() : k);
        if (shift) setState(() => shift = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c1c1e),
      padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (final row in symbols ? _symbols : _letters)
          Row(children: [
            for (final k in row)
              Expanded(
                flex: k == ' ' ? 46 : _special.contains(k) ? 15 : 10,
                child: _Key(
                  label: k == ' ' ? 'space' : (shift && k.length == 1 ? k.toUpperCase() : k),
                  dark: _special.contains(k),
                  lit: k == '⇧' && shift,
                  onDown: () => _down(k),
                  onUp: () => _up(k),
                  onCancel: () => _repeat?.cancel(),
                ),
              ),
          ]),
      ]),
    );
  }
}

class _Key extends StatefulWidget {
  final String label;
  final bool dark, lit;
  final VoidCallback onDown, onUp, onCancel;
  const _Key({required this.label, required this.dark, required this.lit, required this.onDown, required this.onUp, required this.onCancel});
  @override
  State<_Key> createState() => _KeyState();
}

class _KeyState extends State<_Key> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final bg = widget.lit ? const Color(0xffe5e5ea) : widget.dark ? const Color(0xff2c2c2e) : const Color(0xff48484a);
    return Listener(
      onPointerDown: (_) { setState(() => pressed = true); widget.onDown(); },
      onPointerUp: (_) { setState(() => pressed = false); widget.onUp(); },
      onPointerCancel: (_) { setState(() => pressed = false); widget.onCancel(); },
      child: Container(
        height: 46,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: pressed ? bg.withValues(alpha: .6) : bg, borderRadius: BorderRadius.circular(7)),
        alignment: Alignment.center,
        child: Text(widget.label,
            style: TextStyle(color: widget.lit ? Colors.black : Colors.white, fontSize: widget.label.length == 1 ? 20 : 15)),
      ),
    );
  }
}
