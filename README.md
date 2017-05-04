## Express IP Block [WIP]

Small simple IP blocker for Connect/Express.

### Install

```npm install --save express-ip-block```

### Params

##### ips: Array - An array of IP addresses to white or black list.

##### options: Object - Module options.
* ```allow```: Boolean - If true, treats passed IP(s) as whitelisted. Otherwise, treats them as blacklisted. Default is true.

* ```allowForwarded```: Boolean - If true, checks various forwarded-for headers for an IP. Default is false.

### Example
```javascript
const ips = require('ips.json');
const options = { allow: false, allowForwarded: true };
const ipBlock = require('express-ip-block')(ips, options);

app.get('/', ipBlock, (request, response, next) => response.render('index'));

// Alternatively
const ipBlock = require('express-ip-block');
const ips = ['127.0.0.1'];
const options = { allowForwarded: true };

app.get('/', ipBlock(ips, options), (request, response, next) => response.render('index'));
```


### License

  express-ip-block is licensed under the DBAD license.

  Copyright (c) 2017 Bryan Kizer

   Everyone is permitted to copy and distribute verbatim or modified
   copies of this license document.

  > DON'T BE A DICK PUBLIC LICENSE
  > TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

   1. Do whatever you like with the original work, just don't be a dick.

       Being a dick includes - but is not limited to - the following instances:

     1a. Outright copyright infringement - Don't just copy this and change the name.  
     1b. Selling the unmodified original with no work done what-so-ever, that's REALLY being a dick.  
     1c. Modifying the original work to contain hidden harmful content. That would make you a PROPER dick.  

   2. If you become rich through modifications, related works/services, or supporting the original work,
   share the love. Only a dick would make loads off this work and not buy the original work's
   creator(s) a pint.

   3. Code is provided with no warranty. Using somebody else's code and bitching when it goes wrong makes
   you a DONKEY dick. Fix the problem yourself. A non-dick would submit the fix back.
