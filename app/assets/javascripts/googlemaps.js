
var googleApp = function(map, trip_id,initialSteps) {
  var initialSteps = initialSteps;
  var map = map;
  var trip_id = trip_id;
  var selectedPosition = "";
  var markers = [];
  var current_marker = "";     
  var elevator = new google.maps.ElevationService();

   
  var  manageMap = function() {

    var initialize = function(){
    // create markers
    // add markers to markers array in the correct order
    _.each(initialSteps, function(step){
      var marker = new google.maps.Marker({
          object: 'marker',
          step_id : step.id,
          arrive_on : step.arrive_on,
          stay : step.stay,
          index: step.index,
          position: new google.maps.LatLng(step.lat,step.lon),
          draggable: true,
          map: map
      });
      markers.push(marker)
      addMarkerListeners(marker);
    })
    renderAll();
    };
    

    var getRoutePath = function(routePoints){
      var routePath = new google.maps.Polyline({
        path: routePoints,
        geodesic: true,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
        return routePath
    } // close getRoutePath
    
    var renderRoute = function(){
      if (!(typeof route === 'undefined')) {
        route.setMap(null);
      }
       var routePoints = []
       _.each(markers, function(marker){
        routePoints.push(marker.position)
       })
       route = getRoutePath(routePoints);
       route.setMap(map);
    } // close render Route

    function addMarkerListeners(marker) {
      google.maps.event.addListener(marker, 'dragend', function(){
        updateMarker(marker);
        renderAll();
      });

      google.maps.event.addListener(marker, 'rightclick', function(){
        showContextMenu(this.position,this)
      });

    }

    function deleteMarker(marker){
      var stepOption = {
        url: '/trips/'+ trip_id +'/steps/' + marker.step_id,
        data: { 'step': { 
                  lat: marker.position.k, 
                  lon: marker.position.A, 
                  index: marker.index,
                  token: $('#token').html() 
                } 
              },
        dataType:'json',
        type: 'DELETE'
      };
      var step = $.ajax(stepOption);
      step.done(function(step){
        console.log('deleted successfully');
      })
    }

    function updateMarker(marker) {
      var position_type = 'land'
      var positionalRequest = {'locations': [marker.position]}
      elevator.getElevationForLocations(positionalRequest,function(result,status){
        if (status == google.maps.ElevationStatus.OK) {
          if (result[0].elevation < 1 ) {
            position_type = 'marine'
          }
          var stepOption = {
            url: '/trips/'+ trip_id +'/steps/' + marker.step_id,
            data: { 'step': { 
                      lat: marker.position.k, 
                      lon: marker.position.A, 
                      index: marker.index,
                      elevation: result[0].elevation,
                      position_type: position_type, // 'land' or 'marine'
                      arrive_on: marker.arrive_on || undefined,
                      stay: marker.stay || "1",
                      token: $('#token').html() 
                    } 
                  },
            dataType:'json',
            type: 'put'
          };
          var step = $.ajax(stepOption);
          step.done(function(step){
            console.log('updated successfully');
          })
        } else {
            console.log('TODO Elevation service failed due to : ' + status)
        } // elevator if condition close
      }) // elevator function close
    }; // updateMarker close

    function createNewStep(location,index){
      var position_type = 'land'
      var positionalRequest = {'locations': [location]}
      elevator.getElevationForLocations(positionalRequest,function(result,status){
        if (status == google.maps.ElevationStatus.OK) {
          if (result[0].elevation < 1) {
            position_type = 'marine'
          }
          var stepOption = {
            url: '/trips/'+ trip_id +'/steps',
            data: { 'step': { 
                      lat: location.k,
                      lon: location.A, 
                      index:index,
                      elevation: result[0].elevation,
                      position_type: position_type, // 'land' or 'marine'
                      token: $('#token').html() 
                    } 
                  },
            dataType:'json',
            type: 'post'
          }
          var step = $.ajax(stepOption);

          step.done(function(step){
            var marker = new google.maps.Marker({
              object: 'marker',
              step_id : step.id,
              index: step.index,
              position: new google.maps.LatLng(step.lat,step.lon),
              draggable: true,
              map: map
            });
          
            if (index == markers.length){
              markers.push(marker)
            } else {
              first_markers = markers.slice(0,index)
              last_markers = markers.slice(index)
              first_markers.push(marker)
              markers = first_markers.concat(last_markers)
              for (var i=index+1 ; i < markers.length ; i++ ) {
                markers[i].index = i;
                updateMarker(markers[i]);
              }
            }
            addMarkerListeners(marker);
            renderAll();
            })

        } else {
          console.log('TODO Elevation service failed due to : ' + status)
        }
      })
    };

    function createMarker(location,index) {
      index = typeof index !== 'undefined' ? index : markers.length; 
      createNewStep(location,index);
    } // close function createMarker

    
    function renderAll(){
      renderMarkers(map);
      loadMarkerView();
      renderRoute();
    }

    // Sets the map on all markers in the array.
    function setAllMap(map) {
      for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
      }
    } 

    function renderMarkers(map){
      for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
      }
    }

    function addMarkerbefore(){
      current_index = markers.indexOf(current_marker)
      previous_marker = markers[current_index-1]
      lat = (current_marker.position.k - previous_marker.position.k )/2 + previous_marker.position.k
      lng = (current_marker.position.A - previous_marker.position.A )/2 + previous_marker.position.A
      new_marker = new google.maps.LatLng(lat,lng)
      createMarker(new_marker,current_index)
      current_marker = ""
    }


    function showContextMenu(latLng,from) {
      from = typeof from !== 'undefined' ? from : 'map';
      var projection;
      var contextmenuDir;
      current_marker = from;
      projection = map.getProjection() ;
      $('.contextmenu').remove();
      contextmenuDir = document.createElement("div");
      contextmenuDir.className  = 'contextmenu';
      if (from.object === 'marker') {
       contextmenuDir.innerHTML = '<a id="menu_remove_marker"><div class="context">Remove marker<\/div><\/a>'
       if (markers.indexOf(from) > 0) {
        contextmenuDir.innerHTML = contextmenuDir.innerHTML + '<a id="menu_add_marker_before"><div class="context">Add a marker before<\/div><\/a>'
       }
      } else {
       contextmenuDir.innerHTML = '<a id="menu1"><div class="context">Add Marker<\/div><\/a>'
                               + ''; 
      }
      $(map.getDiv()).append(contextmenuDir);
      setMenuXY(latLng);
      contextmenuDir.style.visibility = "visible";

    } // close function showContextMenu


    function setMenuXY(latLng){
      var mapWidth = $('#map_canvas').width();
      var mapHeight = $('#map_canvas').height();
      var menuWidth = $('.contextmenu').width();
      var menuHeight = $('.contextmenu').height();
      var clickedPosition = adjustXY(latLng);
      var x = clickedPosition.x ;
      var y = clickedPosition.y ;

      if((mapWidth - x ) < menuWidth)//if to close to the map border, decrease x position
          x = x - menuWidth;
      if((mapHeight - y ) < menuHeight)//if to close to the map border, decrease y position
         y = y - menuHeight;

      $('.contextmenu').css('left',x  );
      $('.contextmenu').css('top',y );
    }; // close function setMenuXY

    function adjustXY(latLng){
      var scale = Math.pow(2, map.getZoom());
      var nw = new google.maps.LatLng(
          map.getBounds().getNorthEast().lat(),
          map.getBounds().getSouthWest().lng()
      );
      var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
      var worldCoordinate = map.getProjection().fromLatLngToPoint(latLng);
      var caurrentLatLngOffset = new google.maps.Point(
          Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
          Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
      );
      return caurrentLatLngOffset;
    }; // close function adjustXY

     var loadMarkerView = function() {
        $(".marker-list").empty();
        _.each(markers, function(marker){
          var lat = marker.position.k // north-south
          var lng = marker.position.A // east-west
          var html =  "<li id='marker_"+ markers.indexOf(marker) +"'> " + 
                        "<h5><strong>Position" + markers.indexOf(marker)+ "</strong></h5>" + 
                        // "<p>lat: "+lat+" lng: "+lng+"</p>" + 
                        "<input type='date' id='arrive_on_"+ marker.id +"' name='arrive_on' class='step_input date' value='"+ marker.arrive_on+"'/>" +
                        "<input type='number' id='stay_"+ marker.id +"' name='stay' class='step_input stay' value='"+ marker.stay+"'  /> " +
                      "</li>"

          $('.marker-list').append(html)
        })

        $('.marker-list').sortable();
        $('.marker-list').disableSelection();

        $('.step_input').change(function(e){
          markerIndex = parseInt((this.parentElement.id).replace("marker_",""));
          marker = markers[markerIndex];
          marker[this.name] = this.value;
          updateMarker(marker);
        });

        $('.marker-list').on("sortupdate", function(){
          ids = []
          newMarkers = []
          dom_array = _.each(($('.marker-list').children()), function(li){li.id})

          _.each(dom_array, function(markerItem){
              ids.push(parseInt((markerItem.id).replace("marker_","")))
          }); // each dom array

          _.each(ids, function(pos){
            // if marker index if different from the position in the new array
            if (markers[pos].index != newMarkers.length) {
              markers[pos].index = newMarkers.length
              updateMarker(markers[pos])
            }
            newMarkers.push(markers[pos])

          })
          
          $('.marker-list').off('sortupdate')
          markers = newMarkers;
          loadMarkerView();
          renderRoute();
        }); // sortupdate function

      } // load marker view




    google.maps.event.addListener(map,'rightclick', function(e){
      selectedPosition = e.latLng
      showContextMenu(e.latLng)  
    })

    google.maps.event.addListener(map,'click', function(e){
     $('.contextmenu').remove();
    })

    $(map.getDiv()).on('click','#menu1',function(){
      createMarker(selectedPosition);
      selectedPosition = "";
      loadMarkerView()
      $('.contextmenu').remove();
      current_marker = ""
    })

    $(map.getDiv()).on('click','#menu_remove_marker',function(){
      var index = markers.indexOf(current_marker)
      marker = markers[index]
      deleteMarker(marker);
      markers[index].setMap(null);
      if (index > -1) {
       markers.splice(index, 1); // remove 1 item at index position
      }
      for (var i=index; i < markers.length ; i++ ) {
        markers[i].index = i;
        updateMarker(markers[i]);
      }
      $('.contextmenu').remove();
      renderAll();
      current_marker = ""
    })

    $(map.getDiv()).on("click",'#menu_add_marker_before',function(){
      addMarkerbefore()
      selectedPosition = "";
      loadMarkerView()
      $('.contextmenu').remove();
      current_marker = ""
    })

    initialize();

  } // renderGoogleMaps


    manageMap();
}
