import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumkit/main.dart';
// import 'package:rumkit/model/koordinat.dart';
import 'package:rumkit/view_model/map/map_bloc.dart';

// import 'package:rumkit/view_model/myloc.dart';

void main() {
  testWidgets('uji tombol lokasi', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.my_location_outlined));
    await tester.pump();
  });

  testWidgets('uji tombol tampilkan lebih', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find
        .byIcon(MapBloc().state.but ? Icons.expand_more : Icons.expand_less));
    await tester.pumpAndSettle();
  });

  testWidgets('uji tombol tampilkan rumah sakit terdekat dan berganti tipe map',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find
        .byIcon(MapBloc().state.but ? Icons.expand_more : Icons.expand_less));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.map));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.directions));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.navigate_next));
    await tester.pumpAndSettle();
  });

  testWidgets('uji tombol tampilkan kalkulasi algoritma dan datanya',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find
        .byIcon(MapBloc().state.but ? Icons.expand_more : Icons.expand_less));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.directions));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.description));
    await tester.pumpAndSettle();

    //   await tester.tap(find.text(LocProvider().text ? 'Vincenty' : 'Hubeny'));
    //   await tester.pumpAndSettle();

    //   for (int i = 0; i < datakoordinat.length; i++) {
    //     expect(find.text('Rumah Sakit ${datakoordinat[i].name}'), findsWidgets);
    //   }
    //   expect(find.text('Jalur Terbaik'), findsWidgets);

    //   expect(find.text('Jarak Terbaik'), findsWidgets);
    //   expect(
    //       find.text(
    //           '${(LocProvider().text ? LocProvider().jarak2 : LocProvider().jarak1).toStringAsFixed(3).replaceAll('.', ',')} meter'),
    //       findsWidgets);
  });
}
