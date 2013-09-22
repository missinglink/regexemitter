
# regex event emitter

An event emitter which takes regular expressions & strings for event names.

Well tested and available in vanilla javascript for the browser or server.

### install

```bash
npm install regexemitter --save
```

[![NPM](https://nodei.co/npm/regexemitter.png?downloads=true&stars=true)](https://nodei.co/npm/regexemitter/)

### example

```javascript
/**
  regexeventemitter behaves just like nodejs native emitter except it
  allows regular expressions as event names.
**/

var EventEmitter = require('regexemitter');
var events = new EventEmitter();

// register a new event
events.on( /send this message to (john|dave)/, function ( arg1, arg2 ){

  console.log( 'event:', this.event );
  console.log( 'message:', arg1, arg2 );

});

events.emit( 'send this message to john', 'hello', 'john' );
events.emit( 'send this message to andy', 'hi', 'andy' );
events.emit( 'send this message to dave', 'ahoy', 'dave' );
```

### output

```bash
event: send this message to john
message: hello john

event: send this message to dave
message: ahoy dave
```

## for the browser

Copy `index.js` to your web server and rename it `regexemitter.js`.

### example

```html
<script type="text/javascript" src="regexemitter.js"></script>
<script type="text/javascript">

  /**
    regexeventemitter behaves just like nodejs native emitter except it
    allows regular expressions as event names.
  **/

  var events = new EventEmitter();

  // register a new event
  events.on( /send this message to (john|dave)/, function ( arg1, arg2 ){

    console.log( 'event:', this.event );
    console.log( 'message:', arg1, arg2 );

  });

  events.emit( 'send this message to john', 'hello', 'john' );
  events.emit( 'send this message to andy', 'hi', 'andy' );
  events.emit( 'send this message to dave', 'ahoy', 'dave' );

</script>
```

### output

```bash
event: send this message to john
message: hello john

event: send this message to dave
message: ahoy dave
```

## build status

```bash
npm test
```

[![Build Status](https://travis-ci.org/missinglink/regexemitter.png?branch=master)](https://travis-ci.org/missinglink/regexemitter)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/missinglink/regexemitter/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

