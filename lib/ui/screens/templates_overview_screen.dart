import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/templates/templates.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/ui/widgets/app_drawer.dart';
import 'package:foodload_flutter/ui/widgets/templates/template_list.dart';

class TemplatesOverviewScreen extends StatefulWidget {
  static const routeName = '/template-overview-screen';

  @override
  _TemplatesOverviewScreenState createState() =>
      _TemplatesOverviewScreenState();
}

class _TemplatesOverviewScreenState extends State<TemplatesOverviewScreen> {
  UserRepository _userRepository;
  TemplateRepository _templateRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _templateRepository = RepositoryProvider.of<TemplateRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Templates'),
        actions: [
          //TODO: Implement
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: BlocProvider<TemplatesBloc>(
        create: (context) => TemplatesBloc(
          templatesRepository: _templateRepository,
          userRepository: _userRepository,
        )..add(FetchTemplates()),
        child: TemplateList(),
      ),
    );
  }
}
