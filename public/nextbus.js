(function(){

  var getNextWork = function() {
    $.ajax({
      type: 'GET',
      url: '/next/work',
      success: function (buses) {
        $('#times').empty();
        if (!buses.length) {
          $('#times').append('<div>').text('No more buses');
          return;
        }

        $('#times').append('<h2 class="subtitle">Route '+buses[0].route_id+'</h2>');
        $('#times').append('<span class="direction">'+buses[0].stop_name+'<br>to work</span>')

        buses.forEach(function(bus){
          $('#times').append('<div class="time">'+bus.departure_time+'</div>');
        });
      },

      error: function (err) {
        console.error(err);
      }
    });
  };

  var getNextHome = function() {
    $.ajax({
      type: 'GET',
      url: '/next/home',
      success: function (buses) {
        $('#times').empty();
        if (!buses.length) {
          $('#times').append('<h2>No more buses today.</h2>');
          return;
        }

        $('#times').append('<h2 class="subtitle">Route '+buses[0].route_id+'</h2>');
        $('#times').append('<span class="direction">'+buses[0].stop_name+'<br>to home</span>')

        buses.forEach(function(bus){
          $('#times').append('<div class="time">'+bus.departure_time+'</div>');
        });
      },

      error: function (err) {
        console.error(err);
      }
    });
  };

  $(document).ready(function() {
    $('#to-work').click(function(e){
      e.preventDefault();
      getNextWork();
    });
    $('#to-home').click(function(e){
      e.preventDefault();
      getNextHome();
    })
  });

}())
