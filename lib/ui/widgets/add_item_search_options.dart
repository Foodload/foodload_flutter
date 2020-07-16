import 'package:flutter/material.dart';

class AddItemSearchOptions extends StatelessWidget {
  final Function searchHandler;
  final _form = GlobalKey<FormState>();
  final _searchTextFieldController = TextEditingController();

  AddItemSearchOptions(this.searchHandler);

  void validateThenSearch() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    searchHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Scan',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {},
            ),
          ],
        ),
        Text(
          'Or',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Type the ID of the item',
                    ),
                    textInputAction: TextInputAction.search,
                    controller: _searchTextFieldController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter the ID of the item';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      validateThenSearch();
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  color: Theme.of(context).colorScheme.primary,
                  child: Text(
                    'Search',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: () {
                    validateThenSearch();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
