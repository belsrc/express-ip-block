## Squeue [WIP]

Simple Mongo backed queue exercise.

#### #Queue(conString:String, options:Object)
Initializes a new instance of the Queue class.
* ```conString``` The Mongo connection string.
* ```options``` The options object.
* ```options.collection``` The collection name for the queue.
* ```options.release``` The number of seconds a queue can run before being considered old.
* ```options.retries``` The number of retries before a queue is dead.
* ```options.mongo``` The Mongo connection options.

Has the following defaults:
```
{
  collection: 'queue',
  release: 30,
  retries: 5,
  mongo: {
    keepAlive: 20000,
    autoReconnect: true,
  },
}
```

#### #connect()
Opens a connection to the Mongo DB.

#### #add(message:Mixed, priority:Number)
Adds a message to the queue.
* ```message``` The message to queue.
* ```priority``` The message priority.

#### #get()
Gets the next item in the queue.

#### #complete(id:String)
Marks a queue item as complete.
* ```id``` The item ID.

#### #fail(id:String)
Marks a queue item as failed.
* ```id``` The item ID.

#### #markDead(id:String)
Marks a queue item as dead _(to many retries)_.
* ```id``` The item ID.

#### #clean()
Removes all completed queue items.

_The collection already has a TTL index on completed documents so this is merely if you want to manually flush them._

#### #bury()
Removes all dead queue items.

#### #free()
Frees the queue items that are passed the release time.

### Example
```javascript
function addToQueue(message) {
  return queue
    .add(message);
}

function doWork() {
  return queue.get()
    .then(item => {
      if(!item) {
        return;
      }

      return repo
        .readById(item.message.id)
        .then(doc => doSomething(doc))
        .then(() => queue.complete(item.id))
        .catch(error => queue
          .fail(item.id)
          .then(() => Promise.reject(error))
        );
    });
}

// In the method where you want to queue something
// The message can be anything you want
addToQueue({ event: 'ADD', id: doc.id });

// In some sort of worker
doWork();
```


### License

  Squeue is licensed under the DBAD license.

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
