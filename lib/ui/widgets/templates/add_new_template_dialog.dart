import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_new_template/add_new_template.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';

class AddNewTemplateDialog extends StatefulWidget {
  @override
  _AddNewTemplateDialogState createState() => _AddNewTemplateDialogState();
}

class _AddNewTemplateDialogState extends State<AddNewTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new template'),
      ),
      body: BlocConsumer<AddNewTemplateBloc, AddNewTemplateState>(
        listener: (context, state) {
          if (state is AddNewTemplateSuccess) {
            Navigator.of(context).pop(state.newTemplate);
          } else if (state is AddNewTemplateFail) {
            SnackBarHelper.showFailMessage(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is AddNewTemplateAdding) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter template name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length > 20)
                        return 'Name cannot be longer than 20 characters';

                      return null;
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            BlocProvider.of<AddNewTemplateBloc>(context)
                                .add(AddNewTemplate(_nameController.text));
                          }
                        },
                        child: Text('Create template'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
