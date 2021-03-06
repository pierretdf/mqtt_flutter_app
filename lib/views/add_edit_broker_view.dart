import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mqtt_flutter_bloc/settings/keys.dart';

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

  const AddEditBrokerScreen({
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
  bool _authentication = false;
  bool _secure = false;
  String _certificatePath; // Optionnal
  String _privateKeyPath; // Optionnal
  String _privateKeyPassword; // Optionnal
  String _clientAuthorityPath;

  TextEditingController _certificateController;
  TextEditingController _privateKeyController;
  TextEditingController _clientAuthorityController;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? localizations.editBroker : localizations.addBroker,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Broker Name
              // CustomTextField(
              //     value: widget.broker.name,
              //     fieldKey: AppKeys.brokerNameField,
              //     edit: widget.isEditing,
              //     controller: _name,
              //     hint: localizations.newBrokerName,
              //     node: node),
              TextFormField(
                initialValue: widget.isEditing ? widget.broker.name : '',
                key: AppKeys.brokerNameField,
                autofocus: !widget.isEditing,
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
              // CustomTextField(
              //     value: widget.broker.address,
              //     fieldKey: AppKeys.brokerAddressField,
              //     edit: widget.isEditing,
              //     controller: _address,
              //     hint: localizations.newBrokerName,
              //     node: node),
              TextFormField(
                initialValue: widget.isEditing ? widget.broker.address : '',
                key: AppKeys.brokerAddressField,
                autofocus: !widget.isEditing,
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
                initialValue: widget.isEditing ? '${widget.broker.port}' : '',
                key: AppKeys.brokerPortField,
                autofocus: !widget.isEditing,
                style: textTheme.headline5,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: localizations.newBrokerPort,
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
                initialValue: widget.isEditing ? widget.broker.identifier : '',
                key: AppKeys.brokerIdentifierField,
                autofocus: !widget.isEditing,
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
              SwitchListTile(
                title: const Text('Broker with authentication ?'),
                key: AppKeys.brokerAuthenticationField,
                value: _authentication,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) {
                  setState(() {
                    _authentication = value;
                  });
                },
              ),
              // Broker Username
              Visibility(
                visible: _authentication,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue:
                          widget.isEditing ? widget.broker.username : '',
                      key: AppKeys.brokerUsernameField,
                      autofocus: !widget.isEditing,
                      style: textTheme.headline5,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: localizations.newBrokerUsername,
                      ),
                      validator: (val) {
                        return null;
                      },
                      onSaved: (value) => _username = value,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    // Broker Password
                    TextFormField(
                      initialValue:
                          widget.isEditing ? widget.broker.password : '',
                      key: AppKeys.brokerPasswordField,
                      autofocus: !widget.isEditing,
                      style: textTheme.headline5,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: localizations.newBrokerPassword,
                      ),
                      validator: (val) {
                        return null;
                      },
                      onSaved: (value) => _password = value,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: const Text('TLS secure broker ?'),
                key: AppKeys.brokerSecureField,
                value: _secure,
                activeColor: Theme.of(context).primaryColor,
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
                      onTap: () async {
                        final path =
                            await FilePicker.platform.getDirectoryPath();
                        if (path != null) {
                          _certificateController.text = path;
                        } else {
                          debugPrint('User has cancelled the selection');
                        }
                      },
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.isEditing
                            ? widget.broker.certificatePath
                            : '',
                        autofocus: !widget.isEditing,
                        controller: _certificateController,
                        style: textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: localizations.newBrokerClientCertificate,
                          icon: const Icon(Icons.file_present),
                        ),
                        validator: (val) {
                          return val.trim().isEmpty
                              ? localizations.emptyBrokerError
                              : null;
                        },
                        onSaved: (value) => _certificatePath = value,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                    ),
                    // Broker Private Key Path
                    GestureDetector(
                      onTap: () async {
                        final path =
                            await FilePicker.platform.getDirectoryPath();
                        if (path != null) {
                          _privateKeyController.text = path;
                        } else {
                          debugPrint('User has cancelled the selection');
                        }
                      },
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.isEditing
                            ? widget.broker.privateKeyPath
                            : '',
                        autofocus: !widget.isEditing,
                        controller: _privateKeyController,
                        style: textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: localizations.newBrokerPrivateKey,
                          icon: const Icon(Icons.file_present),
                        ),
                        validator: (val) {
                          return val.trim().isEmpty
                              ? localizations.emptyBrokerError
                              : null;
                        },
                        onSaved: (value) => _privateKeyPath = value,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                    ),
                    // Broker private key password
                    TextFormField(
                      initialValue: widget.isEditing
                          ? widget.broker.privateKeyPassword
                          : '',
                      autofocus: !widget.isEditing,
                      style: textTheme.headline5,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: localizations.newBrokerPrivateKeyPassword,
                      ),
                      validator: (val) {
                        return null;
                      },
                      onSaved: (value) => _privateKeyPassword = value,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    // Broker Client Authority Path
                    GestureDetector(
                      onTap: () async {
                        final path =
                            await FilePicker.platform.getDirectoryPath();
                        if (path != null) {
                          _clientAuthorityController.text = path;
                        } else {
                          debugPrint('User has cancelled the selection');
                        }
                      },
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.isEditing
                            ? widget.broker.clientAuthorityPath
                            : '',
                        autofocus: !widget.isEditing,
                        controller: _clientAuthorityController,
                        style: textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: localizations.newBrokerCertificateAuthority,
                          icon: const Icon(Icons.file_present),
                        ),
                        validator: (val) {
                          return val.trim().isEmpty
                              ? localizations.emptyBrokerError
                              : null;
                        },
                        onSaved: (value) => _clientAuthorityPath = value,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton(
                  key: widget.isEditing
                      ? AppKeys.saveBrokerFab
                      : AppKeys.saveNewBroker,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
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
                  child: Text(widget.isEditing ? 'Valid Broker' : 'Add Broker'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Key fieldKey;
  final bool edit;
  final String value;
  final String hint;
  final FocusScopeNode node;

  String controller;

  CustomTextField({
    @required this.fieldKey,
    @required this.edit,
    @required this.controller,
    @required this.value,
    @required this.hint,
    @required this.node,
  }) : super(key: fieldKey);

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      initialValue: edit ? value : '',
      key: fieldKey,
      autofocus: !edit,
      style: textTheme.headline5,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (val) {
        return val.trim().isEmpty ? localizations.emptyBrokerError : null;
      },
      onSaved: (value) => controller = value,
      onEditingComplete: () => node.nextFocus(),
    );
  }
}
