
/** regexeventemitter behaves just like nodejs native emitter except it takes regular expressions **/

var EventEmitter = require('regexemitter');
var events = new EventEmitter();

// register a new event
events.on( /send this message to (john|dave)/, function ( arg1, arg2 ){

  console.log( 'new message', arg1, arg2 );

});

events.emit( 'send this message to john', 'hello', 'john' );
events.emit( 'send this message to andy', 'hi', 'andy' );
events.emit( 'send this message to dave', 'ahoy', 'dave' );