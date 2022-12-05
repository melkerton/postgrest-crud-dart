## Setup Example

### Create a configuration file

Copy config.sample.yaml to config.yaml and update as needed. (The defaults provided will work with the Mock Server setup.)

Then use either the [Mock Server Setup](#mock-server-setup) or the
[Database Setup](#database-setup).

### Mock Server Setup (#mock-server-setup)

The simple example provided uses [node-mock-server](https://www.npmjs.com/package/node-mock-server) to provide a mock service. Run `node mock` from this directory
to start the mock server.

### Database Setup (#database-setup)

The migrations under `database/` can be used to create a Postgresql schema to be used with this example. Uses [yoyo-migrations](https://pypi.org/project/yoyo-migrations/) to manage migrations.
