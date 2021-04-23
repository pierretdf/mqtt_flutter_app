import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../settings/localization.dart';

typedef OnSaveCallback = Function(
    String name,
    String address,
    String identifier,
    int port,
    String username,
    String password,
    int qos,
    bool secure,
    String certificatePath,
    String privateKeyPath,
    String privateKeyPassword,
    String clientAuthorityPath);

class AddEditBrokerScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Broker broker;

  AddEditBrokerScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.broker,
  }) : super(key: key); // ?? ArchSampleKeys.addTodoScreen

  @override
  _AddEditBrokerScreenState createState() => _AddEditBrokerScreenState();
}

class _AddEditBrokerScreenState extends State<AddEditBrokerScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _address;
  String _identifier;
  int _port;
  String _username;
  String _password;
  int _qos;
  bool _secure = false;
  String _certificatePath; // Optionnal
  String _privateKeyPath; // Optionnal
  String _privateKeyPassword; // Optionnal
  String _clientAuthorityPath;

  TextEditingController _certificateController;
  TextEditingController _privateKeyController;
  TextEditingController _clientAuthorityController;

  bool get isEditing => widget.isEditing;

  void initState() {
    //_secure = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? localizations.editBroker : localizations.addBroker,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Broker Name
              TextFormField(
                initialValue: isEditing ? widget.broker.name : '',
                //key: ArchSampleKeys.taskField,
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: localizations.newBrokerName,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyBrokerError
                      : null;
                },
                onSaved: (value) => _name = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              // Broker Address
              TextFormField(
                initialValue: isEditing ? widget.broker.address : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: localizations.newBrokerAddress,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyBrokerError
                      : null;
                },
                onSaved: (value) => _address = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              // Broker Port
              TextFormField(
                initialValue: isEditing ? '${widget.broker.port}' : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter a broker port',
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyBrokerError
                      : null;
                },
                onSaved: (value) => _port = int.tryParse(value),
                onEditingComplete: () => node.nextFocus(),
              ),
              // Broker Identifier
              TextFormField(
                initialValue: isEditing ? widget.broker.identifier : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: localizations.newBrokerIdentifier,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyBrokerError
                      : null;
                },
                onSaved: (value) => _identifier = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              // Broker Username
              TextFormField(
                initialValue: isEditing ? widget.broker.username : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter a broker username',
                ),
                validator: (val) {
                  return null;
                },
                onSaved: (value) => _username = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              // Broker Password
              TextFormField(
                initialValue: isEditing ? widget.broker.password : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter a broker password',
                ),
                validator: (val) {
                  return null;
                },
                onSaved: (value) => _password = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              SwitchListTile(
                title: Text("Secure broker ?"),
                controlAffinity: ListTileControlAffinity.platform,
                value: _secure,
                onChanged: (bool value) {
                  setState(() {
                    _secure = value;
                  });
                },
              ),
              Visibility(
                visible: _secure,
                child: Column(
                  children: <Widget>[
                    // Broker Certification Path
                    GestureDetector(
                      child: TextFormField(
                        enabled: false,
                        initialValue:
                            isEditing ? widget.broker.certificatePath : '',
                        autofocus: true, //!isEditing
                        controller: _certificateController,
                        style: textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Select a certification file path',
                          icon: Icon(Icons.file_present),
                        ),
                        validator: (val) {
                          return val.trim().isEmpty
                              ? localizations.emptyBrokerError
                              : null;
                        },
                        onSaved: (value) => _certificatePath = value,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                      onTap: () async {
                        String path =
                            await FilePicker.platform.getDirectoryPath();
                        if (path != null) {
                          _certificateController.text = path;
                        } else {
                          print("User has cancelled the selection");
                        }
                      },
                    ),
                    // Broker Private Key Path
                    GestureDetector(
                      child: TextFormField(
                        enabled: false,
                        initialValue:
                            isEditing ? widget.broker.privateKeyPath : '',
                        autofocus: !isEditing,
                        controller: _privateKeyController,
                        style: textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Select a private key file path',
                          icon: Icon(Icons.file_present),
                        ),
                        validator: (val) {
                          return val.trim().isEmpty
                              ? localizations.emptyBrokerError
                              : null;
                        },
                        onSaved: (value) => _privateKeyPath = value,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                      onTap: () async {
                        String path =
                            await FilePicker.platform.getDirectoryPath();
                        if (path != null) {
                          _privateKeyController.text = path;
                        } else {
                          print("User has cancelled the selection");
                        }
                      },
                    ),
                    TextFormField(
                      initialValue:
                          isEditing ? widget.broker.privateKeyPassword : '',
                      autofocus: !isEditing,
                      style: textTheme.headline5,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Enter a private key password',
                      ),
                      validator: (val) {
                        return null;
                      },
                      onSaved: (value) => _privateKeyPassword = value,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    // Broker Client Authority Path
                    GestureDetector(
                      child: TextFormField(
                        enabled: false,
                        initialValue:
                            isEditing ? widget.broker.clientAuthorityPath : '',
                        autofocus: !isEditing,
                        controller: _clientAuthorityController,
                        style: textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Select a client authority file path',
                          icon: Icon(Icons.file_present),
                        ),
                        validator: (val) {
                          return val.trim().isEmpty
                              ? localizations.emptyBrokerError
                              : null;
                        },
                        onSaved: (value) => _clientAuthorityPath = value,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                      onTap: () async {
                        String path =
                            await FilePicker.platform.getDirectoryPath();
                        if (path != null) {
                          _clientAuthorityController.text = path;
                        } else {
                          print("User has cancelled the selection");
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton(
                  //key:
                  //isEditing ? ArchSampleKeys.saveBrokerFab : ArchSampleKeys.saveNewBroker,
                  child: Text(isEditing ? 'Valid Broker' : 'Add Broker'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // TODO add every mandatory parameters for MQTT Broker
                      widget.onSave(
                          _name,
                          _address,
                          _identifier,
                          _port,
                          _username,
                          _password,
                          _qos,
                          _secure,
                          _certificatePath,
                          _privateKeyPath,
                          _privateKeyPassword,
                          _clientAuthorityPath);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
