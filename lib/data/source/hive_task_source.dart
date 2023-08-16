import 'package:hive/hive.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/data/source/source.dart';

class HiveTaskDataSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;
  HiveTaskDataSource({required this.box});

  @override
  Future<TaskEntity> createOrUpdate({TaskEntity? data}) async {
    if (data!.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete({TaskEntity? data}) async {
    return data!.delete();
  }

  @override
  Future<void> deleteAll() async {
    await box.clear();
  }

  @override
  Future<void> deleteById({id}) async {
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById({id}) async {
    return box.values
        .firstWhere((TaskEntity taskEntity) => taskEntity.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchByKeyword = ''}) async {
    if (searchByKeyword.isNotEmpty) {
      return box.values
          .where((TaskEntity task) => task.name.contains(searchByKeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
