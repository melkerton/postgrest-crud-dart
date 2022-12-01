## Postgrest Crud

A [Postgrest](https://postgrest.org) client that provides create, recall, update, and delete operations with support for batch operations via createBatch, updateBatch, and deleteBatch.

This package is intended to provide a quick and simple way to add database support for Postgrest to an existing application. The requirements on the class representing a table record are meant to be minimal and mostly agnostic about the details of that class.

## Additional information

Still in early stages and very experimental.

### Roadmap

-   Complete the `Query` system.
-   Add support for RPC commands.

## Setup

-   Create a class (`CLASS`) that represents a table in your PostgreSQL database.
    -   The only requirement is that it has at least one property that represents a primary key.
-   Create a class (`SERVICE`) that extends `Model<CLASS>`.
    -   Override modelName, primaryKey, toJson, and fromJson.
    -   The package [json_serializable](https://pub.dev/packages/json_serializable) is useful for building toJson and fromJson methods from a class.
-   Instantiate a PostrestConfig object to connect your database.
-   Instantiate a Database object with a PostgrestConfig object.
-   Instantiate `SERVICE` with a Database object.

## Example

```
import 'package:postgrest_crud/postgrest_crud.dart';

// CLASS
class Widget {
    int id;
    Widget({this.id})
}

// Model<CLASS>
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
    // PostgrestConfig
    final postgrestConfig = PostgrestConfig(url: URL, schema: SCHEMA);

    // Database
    final database = Database(postgrestConfig: postgrestConfig);

    // SERVICE
    final service = TodoModel(database: database);

    // request records
    final response = await service.recall();

    // do something with response.models

    // ...

    // close database when finished, closes http.Client
    database.close();
}
```

See [example/] folder (https://github.com/KernlAnnik/postgrest-crud-dart/tree/main/example) for a more detailed example.
