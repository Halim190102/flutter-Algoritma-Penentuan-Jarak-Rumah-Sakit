import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';
import 'package:rumkit/model/koordinat.dart';
import 'package:rumkit/useable_widget/color.dart';
import 'package:rumkit/view/map.dart';
import 'package:rumkit/view_model/perbandingan.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Hasil extends StatefulWidget {
  const Hasil({Key? key}) : super(key: key);

  @override
  State<Hasil> createState() => _HasilState();
}

class _HasilState extends State<Hasil> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer<PersentaseProvider>(
        builder: (context, a, child) {
          final hasil1 = a.totalhubenyvincenty;
          final hasil2 = a.totalhubenygooglemap;
          final hasil3 = a.totalvincentygooglemap;

          final datahubeny = a.timeHubenyList;
          final datavincenty = a.timeVincentyList;
          if (hasil1 != null &&
              hasil2 != null &&
              hasil3 != null &&
              datahubeny.isNotEmpty &&
              datavincenty.isNotEmpty) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Perbandingan Persentase Jarak Algoritma\nHubeny dan Vincenty dan Google Map',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    table(size, a, a.hubenyvincenty, hasil1,
                        'Hubeny dan Vincenty'),
                    table(size, a, a.hubenygooglemap, hasil2,
                        'Hubeny dan Google Map'),
                    table(size, a, a.vincentygooglemap, hasil3,
                        'Vincenty dan Google Map'),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Perbandingan Efisiensi Waktu\nAlgoritma Hubeny dan Vincenty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 2.8,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(
                            title: AxisTitle(text: 'Jumlah Iterasi'),
                          ),
                          primaryYAxis: const NumericAxis(
                            title: AxisTitle(text: 'Mikro Detik'),
                          ),
                          series: <ColumnSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              color: red,
                              dataSource: <ChartData>[
                                for (int i = 0; i < datahubeny.length - 1; i++)
                                  ChartData(
                                      datahubeny[i + 1], (i + 1).toString())
                              ],
                              xValueMapper: (ChartData sales, _) =>
                                  sales.jumlah,
                              yValueMapper: (ChartData sales, _) => sales.hasil,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.top,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ColumnSeries<ChartData, String>(
                              color: blue,
                              dataSource: <ChartData>[
                                for (int i = 0;
                                    i < datavincenty.length - 1;
                                    i++)
                                  ChartData(
                                      datavincenty[i + 1], (i + 1).toString())
                              ],
                              xValueMapper: (ChartData sales, _) =>
                                  sales.jumlah,
                              yValueMapper: (ChartData sales, _) => sales.hasil,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.top,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Loading();
          }
        },
      ),
    );
  }

  Column table(Size size, PersentaseProvider a, List<List<double>> b, double c,
      String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Perbandingan Persentase $text ',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          height: size.height * 0.4,
          child: HorizontalDataTable(
            onLoad: () {},
            leftHandSideColumnWidth: 100,
            rightHandSideColumnWidth: datakoordinat.length * 100,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: (_, i) => _generateFirstColumnRow(_, i),
            rightSideItemBuilder: (_, i) =>
                _generateRightHandSideColumnRow(_, i, b),
            itemCount: datakoordinat.length,
            rowSeparatorWidget: Divider(
              color: black54,
              height: 0.5,
              thickness: 1,
            ),
            verticalScrollbarStyle: ScrollbarStyle(
              thumbColor: black,
              isAlwaysShown: true,
              thickness: 3.5,
              radius: const Radius.circular(5.0),
            ),
            horizontalScrollbarStyle: ScrollbarStyle(
              thumbColor: black,
              isAlwaysShown: true,
              thickness: 5,
              radius: const Radius.circular(5.0),
            ),
            enablePullToRefresh: false,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Text('Persentase Perbedaan Jarak'),
              ),
              Text('${c.toStringAsFixed(6)} %'),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      getTitleItemWidget(
        14,
        'Perbandingan Persentase',
        true,
      ),
      for (String data in datakoordinat.map((e) => e.name))
        getTitleItemWidget(13, data, false),
    ];
  }

  Widget getTitleItemWidget(
    double size,
    String label,
    bool a,
  ) {
    return Container(
      width: 100,
      height: 60,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: a ? Alignment.center : Alignment.centerLeft,
      child: Text(
        label != 'Perbandingan Persentase' ? 'Rumah Sakit $label' : label,
        style: TextStyle(
          fontSize: size,
          fontWeight: a ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(
    BuildContext context,
    int index,
  ) {
    return Container(
      width: 100,
      height: 60,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Rumah Sakit ${datakoordinat[index].name}',
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(
      BuildContext context, int index, List<List<double>> a) {
    return Row(
      children: [
        for (var data in a)
          Container(
            width: 100,
            height: 60,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              '${data[index].toStringAsFixed(6)} %',
              style: const TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}
