import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/template/template.dart';
import 'package:foodload_flutter/blocs/templates/templates.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/navigator_helper.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/ui/screens/template_details_screen.dart';
import 'package:foodload_flutter/ui/widgets/deleting_snackbar.dart';
import 'package:foodload_flutter/ui/widgets/refresher.dart';
import 'package:foodload_flutter/ui/widgets/scrollable_flexer.dart';
import 'package:foodload_flutter/ui/widgets/templates/template_list_item.dart';

class TemplateList extends StatefulWidget {
  @override
  _TemplateListState createState() => _TemplateListState();
}

class _TemplateListState extends State<TemplateList> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  void _showDeleteTemplateSnackBar(BuildContext context, Template template) {
    Scaffold.of(context)
        .showSnackBar(
          DeletingSnackBar(
            context: context,
            message: 'Deleting template...',
            onUndo: () {
              BlocProvider.of<TemplatesBloc>(context).add(UndoDeleteTemplate());
            },
          ),
        )
        .closed
        .then((SnackBarClosedReason reason) {
      if (reason != SnackBarClosedReason.action) {
        //Then we haven't pressed undo; delete template
        BlocProvider.of<TemplatesBloc>(context)
            .add(DeleteTemplate(template.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TemplatesBloc, TemplatesState>(
        listener: (context, state) {
      if (state.templatesStatus == Status.ERROR) {
        _refreshCompleter?.complete();
        _refreshCompleter = Completer<void>();
        SnackBarHelper.showFailMessage(
          context,
          state.templatesErrorMessage ??
              'Something went wrong. Please try again',
        );
      }
      if (state.templatesStatus == Status.COMPLETED) {
        _refreshCompleter?.complete();
        _refreshCompleter = Completer<void>();
      }
    }, builder: (context, state) {
      if (state.templatesStatus == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Refresher(
          onRefresh: () {
            BlocProvider.of<TemplatesBloc>(context).add(RefreshTemplates());
            return _refreshCompleter.future;
          },
          child: state.templates == null || state.templates.length <= 0
              ? ScrollableFlexer(
                  child: Center(
                    child: Text('Nothing here'),
                  ),
                )
              : ListView.builder(
                  itemCount: state.templates.length,
                  itemBuilder: (ctx, index) {
                    final template = state.templates[index];
                    return TemplateListItem(
                      template: template,
                      onDismiss: (direction) {
                        BlocProvider.of<TemplatesBloc>(context)
                            .add(DeleteTemplateFromList(template.id));
                        _showDeleteTemplateSnackBar(context, template);
                      },
                      onTap: () async {
                        final removedTemplate = await NavigatorHelper.push(
                          context: context,
                          child: BlocProvider<TemplateBloc>(
                            create: (context) => TemplateBloc(
                              templateId: template.id,
                              templateRepository:
                                  RepositoryProvider.of<TemplateRepository>(
                                      context),
                              userRepository:
                                  RepositoryProvider.of<UserRepository>(
                                      context),
                            ),
                            child: TemplateDetailsScreen(),
                          ),
                        );
                        if (removedTemplate != null) {
                          BlocProvider.of<TemplatesBloc>(context)
                              .add(DeleteTemplateFromList(template.id));
                          _showDeleteTemplateSnackBar(context, removedTemplate);
                        }
                      },
                    );
                  },
                ));
    });
  }
}
