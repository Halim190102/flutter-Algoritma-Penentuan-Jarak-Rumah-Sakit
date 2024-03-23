import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';
import 'package:rumkit/useable_widget/color.dart';
import 'package:rumkit/view_model/myloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BottomSheetData extends StatefulWidget {
  const BottomSheetData({Key? key, required this.datas}) : super(key: key);
  final String datas;
  @override
  State<BottomSheetData> createState() => _BottomSheetDataState();
}

class _BottomSheetDataState extends State<BottomSheetData> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print(Provider.of<LocProvider>(context).data);
  }

  @override
  Widget build(BuildContext context) {
    final a = Provider.of<LocProvider>(context);
    return Column(
      children: [
        Expanded(
          child: HorizontalDataTable(
            leftHandSideColumnWidth: 100,
            rightHandSideColumnWidth: a.lokasi.length * 100,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(a),
            leftSideItemBuilder: (_, i) => _generateFirstColumnRow(_, i, a),
            rightSideItemBuilder: (_, i) =>
                _generateRightHandSideColumnRow(_, i, a),
            itemCount: a.lokasi.length,
            rowSeparatorWidget: Divider(
              color: black54,
              height: 0.5,
              thickness: 1,
            ),
            verticalScrollbarStyle: ScrollbarStyle(
              thumbColor: blueAccent,
              isAlwaysShown: true,
              thickness: 3.5,
              radius: const Radius.circular(5.0),
            ),
            horizontalScrollbarStyle: ScrollbarStyle(
              thumbColor: blueAccent,
              isAlwaysShown: true,
              thickness: 5,
              radius: const Radius.circular(5.0),
            ),
            enablePullToRefresh: false,
          ),
        ),
        Divider(
          color: black,
          thickness: 2,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Text('Jalur Terbaik'),
              ),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: AutoSizeText(
                    a.newLokasi.join(' --> '),
                    maxLines: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Text('Jarak Terbaik'),
              ),
              Text('${a.jarak.toStringAsFixed(3).replaceAll('.', ',')} meter'),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _getTitleWidget(LocProvider a) {
    return [
      getTitleItemWidget(
        14,
        widget.datas,
        true,
      ),
      for (String data in a.lokasi) getTitleItemWidget(13, data, false),
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
        label != 'Lokasi Saya' &&
                label != 'Hubeny' &&
                label != 'Vincenty' &&
                label != 'Google Map'
            ? 'Rumah Sakit $label'
            : label,
        style: TextStyle(
          fontSize: size,
          fontWeight: a ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(
      BuildContext context, int index, LocProvider a) {
    return Container(
      width: 100,
      height: 60,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        a.lokasi[index] != 'Lokasi Saya'
            ? 'Rumah Sakit ${a.lokasi[index]}'
            : a.lokasi[index],
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(
      BuildContext context, int index, LocProvider a) {
    return Row(
      children: [
        for (var data in a.data)
          Container(
            width: 100,
            height: 60,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              jarak(data[index]),
              style: const TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

String jarak(double a) {
  if (a == 0) {
    return '0';
  }
  return a.toStringAsFixed(3).replaceAll('.', ',');
}
