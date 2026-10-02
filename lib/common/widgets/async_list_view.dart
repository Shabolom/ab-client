import 'package:flutter/material.dart';

import '../controllers/async_list_controller.dart';

class AsyncListView<T> extends StatelessWidget {
  const AsyncListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.emptyLabel = 'Пока пусто',
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 96),
  });

  final AsyncListController<T> controller;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyLabel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isFirstLoad = controller.status == LoadStatus.initial ||
            (controller.status == LoadStatus.loading && controller.items.isEmpty);
        if (isFirstLoad) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.status == LoadStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 40, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 12),
                  Text(controller.errorMessage ?? 'Не удалось загрузить данные'),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: controller.load,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }
        if (controller.items.isEmpty) {
          return Center(
            child: Text(
              emptyLabel,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            padding: padding,
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => itemBuilder(context, controller.items[i]),
          ),
        );
      },
    );
  }
}
