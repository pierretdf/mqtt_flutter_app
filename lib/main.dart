import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/settings/app_theme.dart';

import 'blocs/blocs.dart';
import 'models/models.dart';
import 'services/repositories.dart';
import 'settings/localization.dart';
import 'views/add_edit_widget_view.dart';
import 'views/views.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MqttRepository>(
          create: (_) => MqttRepository(),
        ),
        RepositoryProvider<BrokerRepository>(
          create: (_) => BrokerRepository(),
        ),
        RepositoryProvider<TopicRepository>(
          create: (_) => TopicRepository(),
        ),
        RepositoryProvider<WidgetRepository>(
          create: (_) => WidgetRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TabBloc>(create: (_) => TabBloc()),
          BlocProvider<MqttBloc>(
              create: (_) => MqttBloc(
                  _.read<MqttRepository>(), _.read<TopicRepository>())),
          BlocProvider<SubscriptionBloc>(
              create: (_) => SubscriptionBloc(
                  _.read<TopicRepository>(), _.read<MqttRepository>())
                ..add(SubscribedTopicsLoaded())),
          BlocProvider<MessageBloc>(
              create: (_) => MessageBloc(_.read<MqttBloc>())),
          BlocProvider<BrokerBloc>(
              create: (_) =>
                  BrokerBloc(_.read<BrokerRepository>(), _.read<MqttBloc>())
                    ..add(BrokersLoaded())),
          BlocProvider<WidgetBloc>(
              create: (_) => WidgetBloc(_.read<WidgetRepository>())
                ..add(WidgetItemsLoaded())),
        ],
        child: MqttApp(),
      ),
    ),
  );
}

class MqttApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // localizationsDelegates: [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('en', ''),
      //   const Locale('fr', ''),
      // ],
      localizationsDelegates: [
        FlutterBlocLocalizationsDelegate(),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) {
          return HomeView();
        },
        '/add_broker': (context) {
          return AddEditBrokerScreen(
            onSave: (name,
                address,
                identifier,
                port,
                username,
                password,
                qos,
                secure,
                certificatePath,
                privateKeyPath,
                privateKeyPassword,
                clientAuthorityPath) {
              context.read<BrokerBloc>().add(
                    BrokerAdded(
                      Broker(id: 1,
                        name: name,
                        address: address,
                        identifier: identifier,
                        port: port,
                        username: username,
                        password: password,
                        qos: qos,
                        secure: secure,
                        certificatePath: certificatePath,
                        privateKeyPath: privateKeyPath,
                        privateKeyPassword: privateKeyPassword,
                        clientAuthorityPath: clientAuthorityPath,
                      ),
                    ),
                  );
            },
            isEditing: false,
          );
        },
        '/add_widget': (context) {
          return AddEditWidgetScreen(
            onSave: (name, type, topic) {
              context.read<WidgetBloc>().add(
                    WidgetItemAdded(
                      WidgetItem(name: name, type: type, topic: topic),
                    ),
                  );
            },
            isEditing: false,
          );
        },
      },
    );
  }
}
