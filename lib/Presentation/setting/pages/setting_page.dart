import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_app/Presentation/auth/pages/login_page.dart';
import 'package:flutter_pos_app/Presentation/home/bloc/logout/logout_bloc.dart';
import 'package:flutter_pos_app/Presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_pos_app/core/components/dropdown2.dart';
import 'package:flutter_pos_app/core/constants/colors.dart';
import 'package:flutter_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_app/data/datasources/product_local_datasource.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeMap(
                  orElse: () {},
                  success: (_) async {
                    await ProductLocalDatasource.instance.removeAllProduct();
                    ProductLocalDatasource.instance
                        .insertAllProduct(_.products.toList());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: AppColors.primary,
                        content: Text('Sync Data Successfully')));
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(const ProductEvent.fetch());
                    },
                    child: const Text('Sync Data'));
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
            },
          ),
          const Divider(),
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              AuthLocalDatasource().removeAuthData();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<LogoutBloc>().add(const LogoutEvent.logout());
                },
                child: const Text('Logout'),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
