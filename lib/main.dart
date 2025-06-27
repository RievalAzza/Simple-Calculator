import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'riwayat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator',
      theme: ThemeData.dark(), // Aktifkan tema gelap
      debugShowCheckedModeBanner: false,
      home: KalkulatorPage(),
    );
  }
}


class KalkulatorPage extends StatefulWidget {
  @override
  _KalkulatorPageState createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  String input = '';
  String result = '';
  bool showHistory = false;

  List<Map<String, String>> riwayat = [];

  String _ambilAngkaTerakhir(String ekspresi) {
    final match = RegExp(r'(\d+\.?\d*)').allMatches(ekspresi);
    if (match.isNotEmpty) {
      return match.last.group(0)!;
    }
    return '0';
  }

  bool bolehTambah(String nilai) {
    if (input.isEmpty) {
      return RegExp(r'[\d(]').hasMatch(nilai);
    }

    String last = input[input.length - 1];

    if (RegExp(r'[+\-×÷^.]').hasMatch(last) &&
        RegExp(r'[+\-×÷^.]').hasMatch(nilai)) {
      return false;
    }

    if (last == '.' && nilai == '.') return false;

    if (RegExp(r'[+\-×÷^]').hasMatch(last) && nilai == ')') return false;

    if (last == '.' && nilai == '(') return false;

    return true;
  }

  void tekanTombol(String nilai) {
    setState(() {
      if (nilai == 'C') {
        input = '';
        result = '';
      } else if (nilai == '⌫') {
        if (input.isNotEmpty) input = input.substring(0, input.length - 1);
      } else if (nilai == 'AC') {
        input = '';
        result = '';
        riwayat.clear();
      } else if (nilai == '=') {
        try {
          if (RegExp(r'[+\-×÷^]$').hasMatch(input)) {
            input += _ambilAngkaTerakhir(input);
          }
          result = _hitung(input);
          riwayat.insert(0, {'input': input, 'result': result});
        } catch (e) {
          result = 'Error';
        }
      } else {
        if (!bolehTambah(nilai)) return;

        if (nilai == '(' && input.isNotEmpty && RegExp(r'\d$').hasMatch(input)) {
          input += '*(';
        } else {
          input += nilai;
        }
      }
    });
  }

  String _hitung(String ekspresi) {
    try {
      ekspresi = ekspresi
          .replaceAll('×', '*')
          .replaceAll('x', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100');

      Parser p = Parser();
      Expression exp = p.parse(ekspresi);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return eval == eval.toInt() ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

Widget tombol(String teks) {
  final bool isSamaDengan = teks == '=';

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSamaDengan ? const Color.fromARGB(255, 16, 67, 254) : Colors.grey[800],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: () => tekanTombol(teks),
        child: Text(
          teks,
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
  );
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Icon(Icons.calculate), // Icon kalkulator
          SizedBox(width: 8),    // Jarak antara ikon dan teks
          Text('Calculator'),
        ],
      ),
    ),

    body: Column(
      children: [
        // Tampilan input dan hasil
        Expanded(
          child: Container(
            padding: EdgeInsets.all(24),
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(input, style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(result, style: TextStyle(fontSize: 24, color: Colors.grey)),
              ],
            ),
          ),
        ),

        // Baris: C, AC, Riwayat
        Row(
          children: [
            tombol('C'),
            tombol('AC'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final shouldClear = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RiwayatPage(riwayat: riwayat),
                        ),
                      );

                      if (shouldClear == true) {
                        setState(() {
                          riwayat.clear();
                        });
                      }
                    },
                    child: Icon(Icons.history, size: 28),
                  ),
                ),
              ),

          ],
        ),

        // Tombol-tombol kalkulator
        Row(children: [tombol('('), tombol(')'), tombol('^'), tombol('÷'), tombol('⌫')]),
        Row(children: [tombol('7'), tombol('8'), tombol('9'), tombol('-')]),
        Row(children: [tombol('4'), tombol('5'), tombol('6'), tombol('+')]),
        Row(children: [tombol('1'), tombol('2'), tombol('3'), tombol('×')]),
        Row(children: [tombol('%'), tombol('0'), tombol('.'), tombol('=')]),
      ],
    ),
  );
}
}