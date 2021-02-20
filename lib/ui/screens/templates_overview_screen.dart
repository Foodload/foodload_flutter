import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_new_template/add_new_template.dart';
import 'package:foodload_flutter/blocs/templates/templates.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/ui/widgets/app_drawer.dart';
import 'package:foodload_flutter/ui/widgets/templates/add_new_template_dialog.dart';
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
  TemplatesBloc _templatesBloc;

  @override
  void initState() {
    super.initState();
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _templateRepository = RepositoryProvider.of<TemplateRepository>(context);
    _templatesBloc = TemplatesBloc(
        templatesRepository: _templateRepository,
        userRepository: _userRepository)
      ..add(FetchTemplates());
  }

  @override
  void dispose() {
    super.dispose();
    _templatesBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TemplatesBloc>.value(
      value: _templatesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Templates'),
          actions: [
            _AddTemplate(),
          ],
        ),
        drawer: AppDrawer(),
        body: TemplateList(),
      ),
    );
  }
}

class _AddTemplate extends StatelessWidget {
  const _AddTemplate({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        final Template newTemplate = await Navigator.of(context).push(
          MaterialPageRoute<Template>(
            builder: (context) => BlocProvider<AddNewTemplateBloc>(
                create: (context) => AddNewTemplateBloc(
                      templatesRepository:
                          RepositoryProvider.of<TemplateRepository>(context),
                      userRepository:
                          RepositoryProvider.of<UserRepository>(context),
                    ),
                child: AddNewTemplateDialog()),
            fullscreenDialog: true,
          ),
        );
        if (newTemplate != null) {
          BlocProvider.of<TemplatesBloc>(context)
              .add(AddNewTemplateToList(newTemplate));
        }
      },
    );
  }
}
