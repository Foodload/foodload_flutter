import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:meta/meta.dart';

class ItemSettingsBloc extends Bloc<ItemSettingsEvent, ItemSettingsState> {
  final ItemRepository _itemRepository;
  final UserRepository _userRepository;

  ItemSettingsBloc({
    @required ItemRepository itemRepository,
    @required UserRepository userRepository,
    @required Item item,
  })  : assert(itemRepository != null && userRepository != null),
        _itemRepository = itemRepository,
        _userRepository = userRepository,
        super(ItemSettingsInit(item));

  @override
  Stream<ItemSettingsState> mapEventToState(ItemSettingsEvent event) async* {}
}
