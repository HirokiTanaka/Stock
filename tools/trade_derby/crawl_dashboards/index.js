var phantom = require('phantom');
var cheerio = require('cheerio');
var moment = require('moment');
var fs = require('fs');
var argv = require('argv');

// get command arguments
argv.option([{
  name: 'login_id',
  short: 'u',
  type : 'string',
  description :'set trade derby login id.',
  example: "'script --login_id=value' or 'script -u value'"
},{
  name: 'password',
  short: 'p',
  type : 'string',
  description :'set trade derby login password.',
  example: "'script --password=value' or 'script -p value'"
}]);
var args = argv.run();
var config = {
  login_id: args.options.login_id,
  password: args.options.password
};

phantom.create(function(ph) {
  ph.createPage(function(page) {

    page.set('onInitialized', function() {
      page.evaluate(function() {
        document.addEventListener('DOMContentLoaded', function() {
          window.callPhantom('DOMContentLoaded');
        }, false);
      });
    });

    var funcs = function(funcs) {
      this.funcs = funcs;
      this.init();
    };
    funcs.prototype = {
      init: function() {
        var self = this;
        page.set('onCallback', function(data) {
          if (data === 'DOMContentLoaded') self.next();
        });
      },
      next: function() {
        var func = this.funcs.shift();
        if (func !== undefined) {
          func();
        } else {
          page.set('onCallback', undefined);
        }
      }
    };

    new funcs([
      function() {
        console.log('ログイン処理');
        page.open('https://www.k-zone.co.jp/td/users/login');
      },
      function() {
        console.log('ログイン画面');
        
        /*
         * This function wraps WebPage.evaluate, and offers the possibility to pass
         * parameters into the webpage function. The PhantomJS issue is here:
         * 
         *   http://code.google.com/p/phantomjs/issues/detail?id=132
         * 
         * This is from comment #43.
         */
        var evaluate = function (page, func) {
          var args = [].slice.call(arguments, 2);
          var fn = "function() { return (" + func.toString() + ").apply(this, " + JSON.stringify(args) + ");}";
          return page.evaluate(fn);
        };

        evaluate(page, function(config) {
          document.getElementById('login_id').value = config.login_id;
          document.getElementById('password').value = config.password;
          document.getElementById('remember_me').checked = true;
          document.getElementById("login_button").click();
        }, config);
      },
      function() {
        console.log('ダッシュボード画面');
        setTimeout(function() {
          page.open('https://www.k-zone.co.jp/td/dashboards/');
        }, 3000);
      },
      function() {
        console.log('holding要素');

        page.evaluate(function() {
          return document.getElementById('holding').innerHTML;
        }, function(html) {
          // var $ = cheerio.load(html);
          var file_name = "./output/" + moment().format('YYYY-MM-DD') + ".html";
          var html = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>' + html + '</body></html>';
          fs.writeFile(file_name, html);
          console.log(file_name + '出力完了');
          ph.exit();
        });
      }
    ]).next();
  });
});
