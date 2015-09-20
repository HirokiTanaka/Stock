var argv = require('argv');
var moment = require('moment');
var configs = require('./app_config.json');
 
// get command arguments
argv.option([{
  name: 'table',
  short: 't',
  type : 'string',
  description :'set table name whose definition you want to output.',
  example: "'script --table=value' or 'script -t value'"
},{
  name: 'from',
  short: 'f',
  type : 'string',
  description :'set table\'s beginning partition key.',
  example: "'script --from=value' or 'script -f value'"
},{
  name: 'to',
  short: 't',
  type : 'string',
  description :'set table\'s end partition key.',
  example: "'script --to=value' or 'script -t value'"
}]);
var args = argv.run();

var table = args.options.table;
if (!table) {
  error_logger.error('invalid table name.');
  process.exit(1);
}
var from = args.options.from;
var to = args.options.to;

table = require('./lib/tables/' + table + '.js');
table = new table();

var ret = table.create();
if (from && to && 0 <= moment(to, "YYYY-MM-DD").diff(moment(from, "YYYY-MM-DD"), "days")) {
  ret += table.add_partitions(from, to, configs.stock_table_location_dir);
}
console.log(ret);
process.exit(0);
