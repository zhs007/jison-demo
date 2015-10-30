/**
 * Created by zhs007 on 15/10/30.
 */

var parser = require('./cfgfile.js');

var ret = parser.parse('abc = (3+9)*5 //haha \r\n bdc = "123"');