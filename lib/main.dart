import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'ui/features/auth/auth_view_model.dart';
import 'ui/features/auth/login_view.dart';
import 'ui/features/home/home_view_model.dart';
import 'ui/features/tickets/ticket_view_model.dart';
import 'ui/features/atm/atm_view_model.dart';
import 'ui/features/contracts/contract_view_model.dart';
import 'ui/features/mail/mail_view_model.dart';
import 'ui/features/parts/part_view_model.dart';
import 'ui/features/settings/settings_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BsmsApp());
}

class BsmsApp extends StatelessWidget {
  const BsmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
        ChangeNotifierProvider(create: (_) => AtmViewModel()),
        ChangeNotifierProvider(create: (_) => ContractViewModel()),
        ChangeNotifierProvider(create: (_) => MailViewModel()),
        ChangeNotifierProvider(create: (_) => PartViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const LoginView(),
      ),
    );
  }
}
