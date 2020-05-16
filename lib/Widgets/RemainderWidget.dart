import 'package:Notes_final/Screens/add_edit_Note.dart';
import 'package:Notes_final/Utils/notes.dart';
import 'package:Notes_final/primaryValues.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RemainderWidget extends StatefulWidget {
  RemainderWidget({Key key, this.isEditNote, this.note}) : super(key: key);
  static bool lights;
  static DateTime dateTime;
  final bool isEditNote;
  final Notes note;
  bool initialDateValueSet = false;
  @override
  _RemainderWidgetState createState() => _RemainderWidgetState();
}

class _RemainderWidgetState extends State<RemainderWidget> {
  var value;
  final format = DateFormat("EEE, d MMM, y  hh:mm a");
  TextEditingController _dateTimeController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Set reminder",
                  style: AppTheme.heading,
                ),
              ),
              Switch(
                activeColor: Colors.blue,
                value: RemainderWidget.lights,
                onChanged: (bool value) {
                  setState(() {
                    RemainderWidget.lights = value;
                  });
                },
              ),
            ],
          ),
          RemainderWidget.lights
              ? Container(
                  child: DateTimeField(
                      onSaved: (newValue) {
                        RemainderWidget.dateTime = newValue;
                      },
                      resetIcon: null,
                      decoration: InputDecoration(border: InputBorder.none),
                      style: AppTheme.notesDescription,
                      initialValue: widget.initialDateValueSet
                          ? DateTime.parse(widget.note.dateReminder)
                          : DateTime.now(),
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()));

                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      }))
              : Container(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEditNote) {
      if (widget.note.dateReminder != "null") {
        RemainderWidget.lights = true;
        widget.initialDateValueSet = true;
      } else {
        RemainderWidget.lights = false;
      }
    } else {
      RemainderWidget.lights = false;
    }
  }
}
