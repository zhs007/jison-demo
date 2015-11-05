/**
 * Created by zhs007 on 15/10/30.
 */

var parser = require('./dslang.js');
var fs = require('fs');

var input = fs.readFileSync('dslang/demo.ds', 'utf-8');
var ret = parser.parse(input);

console.log(JSON.stringify(ret));