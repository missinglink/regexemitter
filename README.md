
# Regex event emitter

An event emitter which takes regular expressions for event names

## For nodejs

### Install

```bash
npm install regexemitter --save
```

[![NPM](https://nodei.co/npm/regexemitter.png?downloads=true&stars=true)](https://nodei.co/npm/regexemitter/)

### Example

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

### Output

```bash
event: send this message to john
message: hello john

event: send this message to dave
message: ahoy dave
```

## For the browser

Copy the `index.js` file to your web server and name it `regexemitter.js`.

### Example

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

### Output

```bash
event: send this message to john
message: hello john

event: send this message to dave
message: ahoy dave
```

## Build Status

[![Build Status](https://travis-ci.org/missinglink/regexemitter.png?branch=master)](https://travis-ci.org/missinglink/regexemitter)