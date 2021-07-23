import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:articles/bloc_patterns/edit_profile_bloc_patterns/edit_personal_bloc.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/data_collection.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/widgets_collection.dart';

class EditPersonalPage extends StatefulWidget {
  final Map<String, dynamic> userMap;

  EditPersonalPage({this.userMap});

  _EditPersonalPageState createState() =>
      _EditPersonalPageState(userMap: userMap);
}

class _EditPersonalPageState extends State<EditPersonalPage> {
  EditPersonalBloc _editPersonalBloc;

  final Map<String, dynamic> userMap;
  final GlobalKey<FormState> _personalformKey = GlobalKey<FormState>();

  _EditPersonalPageState({this.userMap});
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DataCollection _dataCollection = DataCollection();
  DateFormat _dateFormat = DateFormat('MMM dd yyyy');

  TextEditingController _firstNameTextEditingController =
          TextEditingController(),
      _middleNameTextEditingController = TextEditingController(),
      _lastNameTextEditingController = TextEditingController();

  void initState() {
    super.initState();
    _editPersonalBloc = EditPersonalBloc(userMap);
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
  }

  void dispose() {
    super.dispose();
    _editPersonalBloc.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile Settings',
            style: TextStyle(),
          ),
        ),
        body: Container(
          margin:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
          child: Form(
            key: _personalformKey,
            child: ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Appelation',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          StreamBuilder(
                            stream: _editPersonalBloc.appelationStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              return Container(
                                transform:
                                    Matrix4.translationValues(0.0, -5.0, 0.0),
                                child: DropdownButton<String>(
                                  hint: null,
                                  value: asyncSnapshot.data,
                                  items: _editPersonalBloc.appelationList
                                      .map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String selectedValue) {
                                    _editPersonalBloc.appelationStreamSink
                                        .add(selectedValue);
                                  },
                                ),
                              );
                            },
                          )
                        ])),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'First Name',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      StreamBuilder(
                          stream: _editPersonalBloc.firstNameStream,
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            _firstNameTextEditingController.value =
                                _firstNameTextEditingController.value
                                    .copyWith(text: asyncSnapshot.data);
                            return Container(
                                transform:
                                    Matrix4.translationValues(0.0, -5.0, 0.0),
                                child: TextFormField(
                                    validator: (String value) {
                                      String _firstnamePattern =
                                          "^[A-Za-z0-9._]*\$";
                                      RegExp _regExp =
                                          RegExp(_firstnamePattern);
                                      if (value.length < 2 ||
                                          value.length > 20) {
                                        return 'First Name should have characters between 2 and 20';
                                      } else if (!_regExp.hasMatch(value)) {
                                        return 'First can have (alphabets), (numbers), (.) and (_) only';
                                      }
                                      return null;
                                    },
                                    controller: _firstNameTextEditingController,
                                    onChanged: (String value) {
                                      _editPersonalBloc.firstNameStreamSink
                                          .add(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'First...',
                                      errorText: asyncSnapshot.error,
                                    )));
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Middle Name',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      StreamBuilder(
                          stream: _editPersonalBloc.middleNameStream,
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            _middleNameTextEditingController.value =
                                _middleNameTextEditingController.value
                                    .copyWith(text: asyncSnapshot.data);
                            return Container(
                                transform:
                                    Matrix4.translationValues(0.0, -5.0, 0.0),
                                child: TextFormField(
                                    validator: (String value) {
                                      String _middelnamePattern =
                                          "^[A-Za-z0-9._]*\$";
                                      RegExp _regExp =
                                          RegExp(_middelnamePattern);
                                      if (value.length < 2 ||
                                          value.length > 20) {
                                        return 'Middle Name should have characters between 2 and 20';
                                      } else if (!_regExp.hasMatch(value)) {
                                        return 'Middle can have (alphabets), (numbers), (.) and (_) only';
                                      }
                                      return null;
                                    },
                                    controller:
                                        _middleNameTextEditingController,
                                    onChanged: (String value) {
                                      _editPersonalBloc.middleNameStreamSink
                                          .add(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Middle Name...',
                                      errorText: asyncSnapshot.error,
                                    )));
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Last Name',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      StreamBuilder(
                          stream: _editPersonalBloc.lastNameStream,
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            _lastNameTextEditingController.value =
                                _lastNameTextEditingController.value
                                    .copyWith(text: asyncSnapshot.data);
                            return Container(
                                transform:
                                    Matrix4.translationValues(0.0, -5.0, 0.0),
                                child: TextFormField(
                                    validator: (String value) {
                                      String _lasrnamePattern =
                                          "^[A-Za-z0-9._]*\$";
                                      RegExp _regExp = RegExp(_lasrnamePattern);
                                      if (value.length < 2 ||
                                          value.length > 20) {
                                        return 'Last Name should have characters between 2 and 20';
                                      } else if (!_regExp.hasMatch(value)) {
                                        return 'Last can have (alphabets), (numbers), (.) and (_) only';
                                      }
                                      return null;
                                    },
                                    controller: _lastNameTextEditingController,
                                    onChanged: (String value) {
                                      _editPersonalBloc.lastNameStreamSink
                                          .add(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Last...',
                                      errorText: asyncSnapshot.error,
                                    )));
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            'Date of Birth',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                      StreamBuilder(
                          stream: _editPersonalBloc.birthDateStream,
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            return GestureDetector(
                                child: Container(
                                    child: Text(
                                        '${_dateFormat.format(DateTime.parse(asyncSnapshot.data))}')),
                                onTap: () {
                                  _selectBirthDate();
                                });
                          }),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Gender',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          StreamBuilder(
                            stream: _editPersonalBloc.genderStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              return Container(
                                transform:
                                    Matrix4.translationValues(0.0, -5.0, 0.0),
                                child: DropdownButton<String>(
                                  hint: null,
                                  value: asyncSnapshot.data,
                                  items: _dataCollection.gendersList
                                      .map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String selectedValue) {
                                    _editPersonalBloc.genderStreamSink
                                        .add(selectedValue);
                                  },
                                ),
                              );
                            },
                          )
                        ])),
                StreamBuilder(
                    stream: _editPersonalBloc.editCheckStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> asyncSnapshot) {
                      return RaisedButton(
                          color: Colors.deepOrange,
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: asyncSnapshot.hasData
                              ? () {
                                  if (_personalformKey.currentState
                                      .validate()) {
                                    _widgetsCollection.showMessageDialog();
                                    _editPersonalBloc.editPersonalProfile();
                                  }
                                }
                              : null);
                    }),
                StreamBuilder(
                    stream: _editPersonalBloc.editPersonalStream,
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return asyncSnapshot.data == null
                          ? Container(
                              width: 0.0,
                              height: 0.0,
                            )
                          : _editPersonalFinished(asyncSnapshot.data);
                    }),
              ],
            ),
          ),
        ));
  }

  Widget _editPersonalFinished(Map<String, dynamic> mapResponse) {
    Future.delayed(Duration.zero, () {
      _navigationActions.closeDialogRoot();
      _editPersonalBloc.editPersonalStreamSink.add(null);
      if (mapResponse['code'] == 200) {
        Connect.currentUser.name =
            '${mapResponse['content']['firstName']} ${mapResponse['content']['lastName']}';
        _widgetsCollection.showToastMessage(mapResponse['message']);
      } else if (mapResponse['code'] == 400) {
        _widgetsCollection.showToastMessage(mapResponse['content']['message']);
      } else {
        _widgetsCollection.showToastMessage(mapResponse['content']['message']);
      }
    });
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }

  void _selectBirthDate() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(DateTime.now().year - 18, 1, 1),
        onChanged: (date) {}, onConfirm: (date) {
      _editPersonalBloc.birthDateStreamSink.add(date.toString());
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
