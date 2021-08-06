$( document ).on('turbolinks:load', function() {
  
  if ($('#map').length > 0) {
    // Init map
    initMap()
    
    // Show User location switcher
    $('[id^="edit_setting_"]').on('change', '[type=checkbox]', function() {
      $(this).closest('form').submit();
    })
  }
  
  function initMap() {
    $.ajax({
      url: window.origin + '/maps',
      type: 'GET',
      dataType: 'json',
      success: function(result) {
        let currentUserLocation = result.current_user_location
        let squadMembersLocations = result.squad_members_locations
        let map = null
        
        if (currentUserLocation) {
          map = setDefaultMap(currentUserLocation)
          setCurrentUserMarker(map, currentUserLocation)
        } else {
          let center = result.squad_members_locations[0] || { latitude: 38.9072, longitude: -77.0369 }
          map = setDefaultMap(center)
        }
        
        setSquadMembersMarker(map, squadMembersLocations)
      }
    });
    
    function setDefaultMap(center) {
      const map = new google.maps.Map(document.getElementById('map'), {
        zoom: 7,
        center: { lat: center.latitude, lng: center.longitude },
      });
    
      return map
    }
    
    function setCurrentUserMarker(map, currentUserLocation) {
      // current UserMarker
      function currentUserHTMLMarker(lat, lng) {
         this.lat = lat;
         this.lng = lng;
         this.pos = new google.maps.LatLng(lat, lng);
       }
       
       currentUserHTMLMarker.prototype = new google.maps.OverlayView();
       currentUserHTMLMarker.prototype.onRemove = function () {}
       
       currentUserHTMLMarker.prototype.onAdd = function () {
         div = document.createElement('div');
         div.className = "self-marker";
         
         div2 = document.createElement('div');
         div2.className = "circle-out";
         
         div3 = document.createElement('div');
         div3.className = "circle-in";
         
         div.appendChild(div3)
         div.appendChild(div2)
         
         var panes = this.getPanes();
         panes.overlayImage.appendChild(div);
         this.div=div;
       }
       
       currentUserHTMLMarker.prototype.draw = function () {
         var overlayProjection = this.getProjection();
         var position = overlayProjection.fromLatLngToDivPixel(this.pos);
         var panes = this.getPanes();
         this.div.style.left = position.x - 16 + 'px';
         this.div.style.top = position.y - 16 + 'px';
       }
       
       // Draw current User Marker
       var currentUserMarker = new currentUserHTMLMarker(currentUserLocation.latitude, currentUserLocation.longitude);
       currentUserMarker.setMap(map);
    }
    
    function setSquadMembersMarker(map, squadMembersLocations) {
      // Squad Member Marker
      class SquadMemberHTMLMarker extends google.maps.OverlayView {
        constructor(lat, lng, memberProfilePictureUrl, memberUsername, shiftPosition) {
          super();
          this.profileImage = memberProfilePictureUrl
          this.username = memberUsername
          this.lat = lat;
          this.lng = lng;
          this.pos = new google.maps.LatLng(lat, lng);
          this.shiftPosition = shiftPosition
        }
        
        onRemove() {
          
        }
        
        onAdd() {
          div = document.createElement('div');
          div.className = "squad-member-marker";
        
          div2 = document.createElement('div');
          div2.className = "circle";
          div2.innerHTML = '<img src="' + this.profileImage + '" alt="' + this.username + '">'
        
          div3 = document.createElement('div');
          div3.className = "triangle";
          
          div4 = document.createElement('div');
          div4.className = "map-username";
          div4.innerHTML = '<span>' + this.username + '</span>'
        
          div.appendChild(div3)
          div.appendChild(div2)
          div.appendChild(div4)
        
          var panes = this.getPanes();
          panes.overlayImage.appendChild(div);
          this.div=div;
        }
        
        draw() {
          var overlayProjection = this.getProjection();
          var position = overlayProjection.fromLatLngToDivPixel(this.pos);
          var panes = this.getPanes();
          this.div.style.left = position.x - 16 + 'px';
          this.div.style.top = position.y -6 -(32*this.shiftPosition) + 'px';
        }
      }
      
      // Draw current User Marker
      squadMembersLocations.forEach((member, arrayIndex) => {
        var squadMemberMarker = new SquadMemberHTMLMarker(member.latitude, member.longitude, member.profile_picture, member.username, arrayIndex);
        squadMemberMarker.setMap(map);
      });
    }
  }
})
