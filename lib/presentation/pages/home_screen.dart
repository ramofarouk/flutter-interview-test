import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interview/injection.dart';
import 'package:flutter_interview/presentation/bloc/repository_bloc.dart';
import 'package:flutter_interview/presentation/bloc/repository_event.dart';
import 'package:flutter_interview/presentation/bloc/repository_state.dart';
import 'package:flutter_interview/presentation/widget/repository.dart';
import 'package:flutter_interview/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> languages = [
    'All',
    'JavaScript',
    'Python',
    'Java',
    'C#',
    'HTML',
    'C',
    'TypeScript'
  ];
  String selectedLanguage = 'All';
  int perPage = 20;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<RepositoryBloc>().add(LoadMoreRepositories());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => sl<RepositoryBloc>()..add(FetchRepositories()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Omar App",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          actions: [
            BlocBuilder<RepositoryBloc, RepositoryState>(builder: (ctx, state) {
              return Container(
                margin: const EdgeInsets.all(10),
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButtonFormField<int>(
                  value: perPage,
                  isExpanded: true,
                  onChanged: (int? newValue) {
                    setState(() {
                      perPage = newValue!;
                      final bloc = BlocProvider.of<RepositoryBloc>(ctx);

                      bloc.add(FilterRepositoriesChangePage(perPage));
                    });
                  },
                  items: [20, 50, 100].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        "$value",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  dropdownColor: AppTheme.primaryColor,
                  iconEnabledColor: Colors.white,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
              );
            })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              BlocBuilder<RepositoryBloc, RepositoryState>(
                  builder: (ctx, state) {
                return dropDownButton(ctx);
              }),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<RepositoryBloc, RepositoryState>(
                  builder: (ctx, state) {
                    if (state is RepositoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RepositoryLoaded) {
                      if (state.filteredRepositories.isEmpty) {
                        return const Center(
                            child: Text(
                                'No repositories found for the selected language.'));
                      } else {
                        return ListView.builder(
                          itemCount: state.filteredRepositories.length,
                          controller: _scrollController,
                          itemBuilder: (ctx, index) {
                            final repository =
                                state.filteredRepositories[index];
                            return RepositoryWidget(
                              repository: repository,
                            );
                          },
                        );
                      }
                    } else if (state is RepositoryError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(
                        child: Text('Start Fetching Repositories'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownButton(ctx) {
    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() {
          selectedLanguage = newValue!;
          final bloc = BlocProvider.of<RepositoryBloc>(ctx);
          if (selectedLanguage == 'All') {
            bloc.add(FetchRepositories());
          } else {
            bloc.add(FilterRepositoriesByLanguage(selectedLanguage));
          }
        });
      },
      items: languages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
