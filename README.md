# PlaceOS Analytics API

Service for providing analytics for physical environments.

Provides efficient querying, aggregation and analaysis of events captured from
PlaceOS operation.

## Testing

`crystal spec`

## Compiling

`crystal build ./src/app.cr`

### Deploying

Once compiled you are left with a binary `./app`

* for help `./app --help`
* viewing routes `./app --routes`
* run on a different port or host `./app -b 0.0.0.0 -p 80`
