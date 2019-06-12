import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/attribute.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/models/speech_statistic.dart';
import 'package:quotierte_redeliste/ui/components/ColorUtils.dart';

class ColorLineData {
  String valueName;
  int valueInPercent;
  Color color;

  ColorLineData(this.valueName, this.valueInPercent, this.color);

  static List<ColorLineData> listFromSpeechStatistic(
      SpeechStatistic statistics, Room room) {
    Attribute attribute = room.attributes
        .firstWhere((attr) => attr.name == statistics.attributeName);

    List<ColorLineData> colorLineData = List();

    statistics.values.forEach((valueName, value) {
      Color color = attribute.values
          .firstWhere((attributeValue) => attributeValue.value == valueName)
          .color;

      colorLineData.add(ColorLineData(valueName, value, color));
    });

    return colorLineData;
  }
}

class ColoredLine extends StatelessWidget {
  final List<ColorLineData> values;

  ColoredLine(this.values) {
    this.values.sort(
        (data1, data2) => data2.valueInPercent.compareTo(data1.valueInPercent));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: values.map((data) => _getOneColor(data)).toList());
  }

  Widget _getOneColor(ColorLineData data) => data.valueInPercent != 0
      ? Expanded(
          flex: data.valueInPercent,
          child: Container(
              color: data.color,
              child: Center(
                  child: Text(data.valueName,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                          color: ColorUtils.getFontColorForBackground(
                              data.color))))))
      : Container();
}
