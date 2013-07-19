
# Regex event emitter

An event emitter which takes regular expressions for event names

### Install

```bash
npm install regexemitter --save
```

[![NPM](https://nodei.co/npm/regexemitter.png?downloads=true&stars=true)](https://nodei.co/npm/regexemitter/)

### Example Script

```javascript
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
```

### Output

```bash
new message hello john
new message ahoy dave
```

## Build Status

[![Build Status](https://travis-ci.org/missinglink/regexemitter.png?branch=master)](https://travis-ci.org/missinglink/regexemitter)