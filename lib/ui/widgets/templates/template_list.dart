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
import 'package:foodload_flutter/ui/widgets/templates/template_list_item.dart';

class TemplateList extends StatelessWidget {
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
        SnackBarHelper.showFailMessage(
          context,
          state.templatesErrorMessage ??
              'Something went wrong. Please try again',
        );
      }
    }, buildWhen: (_, currentState) {
      return currentState.templatesStatus != Status.REFRESHING;
    }, builder: (context, state) {
      if (state.templatesStatus == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.templates == null || state.templates.length <= 0) {
        return ListView.builder(
            itemCount: 0,
            itemBuilder: (ctx, index) {
              return Center(
                child: Text('Empty'),
              );
            });
      }

      return ListView.builder(
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
                        RepositoryProvider.of<TemplateRepository>(context),
                    userRepository:
                        RepositoryProvider.of<UserRepository>(context),
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
      );
    });
  }
}
