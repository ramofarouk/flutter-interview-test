import 'package:flutter/material.dart';
import 'package:flutter_interview/core/entities/repository.dart';
import 'package:flutter_interview/themes/app_theme.dart';

class RepositoryWidget extends StatelessWidget {
  final Repository repository;
  const RepositoryWidget({required this.repository, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(repository.name,style: const TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(repository.description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          decoration:  BoxDecoration(color: AppTheme.secondaryColor,borderRadius: BorderRadius.circular(5)),
          child: Text(repository.language,style: const TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
