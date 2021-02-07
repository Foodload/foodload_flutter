import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/templates/templates.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/ui/widgets/templates/template_list.dart';

class TemplateRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<TemplatesBloc>(context).add(RefreshTemplates());
        return BlocProvider.of<TemplatesBloc>(context)
            .firstWhere((state) => state.templatesStatus != Status.REFRESHING);
      },
      child: TemplateList(),
    );
  }
}
