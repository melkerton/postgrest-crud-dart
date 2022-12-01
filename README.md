## Postgrest Crud

A [Postgrest](https://postgrest.org) interface designed around create, recall, update, and delete operations with support for batch operations (createBatch, updateBatch, deleteBatch).

## Additional information

Still very experimental.

## Example

```
import 'package:postgrest_crud/postgrest_crud.dart';

class Widget {
    int id;
    Widget({this.id})
}

class WidgetModel extends Model<Widget> {
  @override
  String get modelName => "widget";

  @override
  String get primaryKey => "id";

  WidgetModel({required super.database});

  @override
  Widget fromJson(JsonObject json) {
    return Widget(id: json['id']);
  }

  @override
  JsonObject toJson(Widget model) {
    return {'id': model.id};
  }
}

void main () async {
    // common setup
    final postgrestConfig = PostgrestConfig(url: URL, schema: SCHEMA);
    final database = Database(postgrestConfig: postgrestConfig);

    // connect a table
    final service = TodoModel(database: database);

    // request records
    final response = await service.recall();

    // do something with response.models
    // ...

    // close database when finished, closes http.Client
    database.close();
}
```

See [Example](https://github.com/KernlAnnik/postgrest-crud-dart/tree/main/example) for a more detailed example.
