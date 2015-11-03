/**
 * Created by zhs007 on 15/10/30.
 */

var parser = require('./struct.js');
var fs = require('fs');

var input = fs.readFileSync('struct/demo.input', 'utf-8');
var ret = parser.parse(input);

console.log(JSON.stringify(ret));