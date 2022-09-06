## Inventory App

### Features supported


* Live Inventory updates including most recent sale displayed.
* Alert pop ups for stocks going below 5 units or going above 250 units.
* REST JSON API for fetching all the inventory data from db.

### Architechtural Decisions

I have used Sinatra for building this app as i wanted to keep it simple and lightweight.
RedisDb is used for storage of the inventory details, as its faster and would be better in performance when it comes to frequent read/write operations.
Ruby version used was 2.5.9

### How to run the app

You can start the app by running the following command:

```
  cd inventory_app
  bundle install
  bundle exec ruby app.rb
```

### How to use the app

Goto ```http://localhost:3000/``` in browser to see the live inventory data.

Goto ```http://localhost:3000/inventory_data``` in browser to see the inventory data in JSON format.


### To be completed
- Suggest shoe transfers from one store to another according to inventory
- Test cases

### Caveats to this approach
- Scalability
- This approach works best when the stores and different shoe models are seeded beforehand.

### Screenshots
 Screenshots are available in the images directory
