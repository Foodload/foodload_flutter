import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/templates/templates.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/ui/widgets/templates/template_list_item.dart';

import 'delete_template_snackbar.dart';

class TemplateList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TemplatesBloc, TemplatesState>(
        listener: (context, state) {
      if (state.templatesStatus == Status.ERROR) {
        SnackBarHelper.showFailMessage(
          context,
          state.templatesErrorMessage,
        );
      }
    }, builder: (context, state) {
      if (state.templatesStatus == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(),
        );
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
              Scaffold.of(context)
                  .showSnackBar(DeleteTemplateSnackBar(
                    context: context,
                    message: 'Deleting template...',
                    onUndo: () {
                      BlocProvider.of<TemplatesBloc>(context)
                          .add(UndoDeleteTemplate());
                    },
                  ))
                  .closed
                  .then((SnackBarClosedReason reason) {
                if (reason != SnackBarClosedReason.action) {
                  //Then we haven't pressed undo; delete template
                  BlocProvider.of<TemplatesBloc>(context)
                      .add(DeleteTemplate(template.id));
                }
              });
            },
            onTap: () {
              //TODO: Implement
            },
          );
        },
      );
    });
  }
}
