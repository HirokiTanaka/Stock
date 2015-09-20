var here = require('here').here;
var moment = require('moment');

var stocks = function() {

  this.create = function() {
    var scripts = here(/*
    CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
      code string,
      market string,
      brand string,
      industry string,
      opening int,
      high int,
      low int,
      closing int,
      turnover int,
      sales int
    )
    PARTITIONED BY (dt string)
    ROW FORMAT
      DELIMITED
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY '\n'
    ;
    */).unindent();
    return scripts;
  };

  this.add_partitions = function(from, to, location_dir) {
    var ret = '';
    from = moment(from, "YYYY-MM-DD");
    to = moment(to, "YYYY-MM-DD");
    ret += '\n';
    while(0 <= to.diff(from, "days")) {
      var datestr = from.format('YYYY-MM-DD');
      ret += "ALTER TABLE stocks ADD PARTITION ( dt='" + datestr + "' ) LOCATION '" + location_dir + "/" + datestr + "';\n";
      from = from.add(1, 'days');
    }
    return ret;
  };
};

module.exports = stocks;