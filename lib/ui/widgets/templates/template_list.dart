import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/templates/templates.dart';
import 'package:foodload_flutter/helpers/navigator_helper.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/ui/screens/test_screen.dart';
import 'package:foodload_flutter/ui/widgets/templates/template_list_item.dart';

import 'delete_template_snackbar.dart';

class TemplateList extends StatelessWidget {
  void _showDeleteTemplateSnackBar(BuildContext context, Template template) {
    Scaffold.of(context)
        .showSnackBar(
          DeleteTemplateSnackBar(
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

      if (state.templatesStatus == Status.ERROR) {
        return ListView.builder(
            itemCount: 0,
            itemBuilder: (ctx, index) {
              return Container();
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
                  context: context, child: TestScreen());
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
