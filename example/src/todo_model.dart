import 'package:postgrest_crud/postgrest_crud.dart';

class Todo {
  int? id;
  Todo({this.id});
}

class TodoModel extends Model<Todo> {
  @override
  String get modelName => "todo";

  @override
  String get primaryKey => "id";

  TodoModel({required super.database});

  @override
  Todo fromJson(JsonObject json) {
    return Todo(id: json['id']);
  }

  @override
  JsonObject toJson(Todo model) {
    JsonObject jsonObject = {};
    if (model.id != null) {
      jsonObject['id'] = model.id;
    }
    return jsonObject;
  }
}
