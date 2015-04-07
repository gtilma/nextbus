var express = require('express');
var db = require('knex')({
  client: 'mysql',
  connection: {
    host: 'localhost',   // obviously, change
    user: 'root',        //   these to
    password: '',        //   your own
    database: 'capmetro' //   config
  }
});

var app = express();

app.use(express.static(__dirname + '/public'));

var server = app.listen(8080, function() {
  var host = 'localhost';
  var port = server.address().port;

  console.log('Listening at http://%s:%s', host, port);
});

(function(){
  var days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

  Date.prototype.getMilTime = function() {
    return this.toTimeString().split(' ')[0];
  };

  Date.prototype.getDayName = function() {
    return days[this.getDay()];
  };

})();

app.get('/next-work', function(request, response){
  var now = new Date();
  var timeNow = now.getMilTime(),
      dayOfWeek = now.getDayName(),
      stop = 4838, // hard-coded example stop
      route = 663, //   and route for proof of concept
      buses = [];

  db.select('st.departure_time', 't.route_id', 's.stop_name')
    .from('stop_times as st')
    .innerJoin('stops as s', 'st.stop_id', 's.stop_id')
    .innerJoin('trips as t', 'st.trip_id', 't.trip_id')
    .innerJoin('calendar as c', 't.service_id', 'c.service_id')
    .where('st.stop_id', stop)
    .andWhere('t.route_id', route)
    .andWhere('st.departure_time', '>', timeNow)
    .andWhere('c.'+dayOfWeek, 1)
    .orderBy('st.departure_time')
    .limit(4)
  .map(function(row){
    buses.push(row);
  })
  .then(function(){
    response.send(buses);
  });
});

app.get('/next-home', function(request, response){
  var now = new Date();
  var timeNow = now.getMilTime(),
      dayOfWeek = now.getDayName(),
      stop = 1969,  // hard-coded example stop
      route = 663,  //   and route for proof of concept
      buses = [];

  db.select('st.departure_time', 't.route_id', 's.stop_name')
    .from('stop_times as st')
    .innerJoin('stops as s', 'st.stop_id', 's.stop_id')
    .innerJoin('trips as t', 'st.trip_id', 't.trip_id')
    .innerJoin('calendar as c', 't.service_id', 'c.service_id')
    .where('st.stop_id', stop)
    .andWhere('t.route_id', route)
    .andWhere('st.departure_time', '>', timeNow)
    .andWhere('c.'+dayOfWeek, 1)
    .orderBy('st.departure_time')
    .limit(4)
  .map(function(row){
    buses.push(row);
  })
  .then(function(){
    response.send(buses);
  });
});
