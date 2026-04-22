class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(studentIdentityProvider);
    return identity.when(
      data: (id) => id == null
          ? const ActorPickerScreen() // первый запуск
          : _ProfileContent(identity: id),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.identity});
  final StudentIdentity identity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(identity.groupName),
            background: Container(
              decoration: const BoxDecoration(gradient: AppColors.brandGradient),
            ),
          ),
        ),
        SliverList.list(children: [
          _InfoTile(label: 'Курс', value: '${identity.computedCourse ?? "—"}'),
          _InfoTile(label: 'Группа', value: identity.groupName),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Расписание'),
            onTap: () => context.push('/schedule/${identity.actorId}'),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Оценки'),
            subtitle: const Text('Появятся в ближайших обновлениях'),
            enabled: false,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Сменить группу'),
            onTap: () async {
              await ref.read(profileLocalDataSourceProvider).clear();
              ref.invalidate(studentIdentityProvider);
            },
          ),
        ]),
      ]),
    );
  }
}