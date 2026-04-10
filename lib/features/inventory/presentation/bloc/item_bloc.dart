import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/inventory/domain/entities/item.dart';
import 'package:omni_ledger/features/inventory/domain/usecases/items_usecases.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemsUsecases itemsUsecases;

  List<Item> _allItems = [];

  ItemBloc(this.itemsUsecases) : super(ItemInitial()) {
    on<FetchItemEvent>((event, emit) async {
      emit(ItemLoading());
      try {
        final items = await itemsUsecases.call();
        _allItems = items;
        emit(ItemLoaded(items: items, filterItems: items));
      } catch (e) {
        emit(ItemError("Failed to Fetch Items"));
      }
    });

    on<SearchItemEvent>((event, emit) async {
      if (state is ItemLoaded) {
        final filtered = _allItems.where((item) {
          return item.name.toLowerCase().contains(event.query.toLowerCase());
        }).toList();

        emit(ItemLoaded(items: _allItems, filterItems: filtered));
      }
    });

    on<CreateItemEvent>((event, emit) async {
      emit(ItemLoading());
      try {
        await itemsUsecases.create(event.name, event.unitPrice);
        emit(ItemCreated());
      } catch (e) {
        emit(ItemError("Failed to Create Item"));
      }
    });
  }
}
