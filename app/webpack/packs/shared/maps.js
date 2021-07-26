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
        console.log('result', result);
        let currentUserLocation = result.current_user_location
        let squadMembersLocations = result.squad_members_locations
        
        let map = setDefaultMap(currentUserLocation)
        setCurrentUserMarker(map, currentUserLocation)
        setSquadMembersMarker(map, squadMembersLocations)
      }
    });
    
    function setDefaultMap(currentUserLocation) {
      const map = new google.maps.Map(document.getElementById('map'), {
        zoom: 7,
        center: { lat: currentUserLocation.latitude, lng: currentUserLocation.longitude },
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
      function squadMemberHTMLMarker(lat, lng, memberProfilePictureUrl, memberFullName) {
         this.profileImage = memberProfilePictureUrl
         this.fullName = memberFullName
         this.lat = lat;
         this.lng = lng;
         this.pos = new google.maps.LatLng(lat, lng);
       }
       
       squadMemberHTMLMarker.prototype = new google.maps.OverlayView();
       squadMemberHTMLMarker.prototype.onRemove = function () {}
       squadMemberHTMLMarker.prototype.onAdd = function () {
         div = document.createElement('div');
         div.className = "squad-member-marker";
         
         div2 = document.createElement('div');
         div2.className = "circle";
         div2.innerHTML = '<img src="' + this.profileImage + '" alt="' + this.fullName + '">'
         
         div3 = document.createElement('div');
         div3.className = "triangle";
         
         div.appendChild(div3)
         div.appendChild(div2)
         
         var panes = this.getPanes();
         panes.overlayImage.appendChild(div);
         this.div=div;
       }
       
       squadMemberHTMLMarker.prototype.draw = function () {
         var overlayProjection = this.getProjection();
         var position = overlayProjection.fromLatLngToDivPixel(this.pos);
         var panes = this.getPanes();
         this.div.style.left = position.x - 16 + 'px';
         this.div.style.top = position.y  - 70 +'px';
       }
       
       // Draw current User Marker
       squadMembersLocations.forEach(member => {
         var squadMemberMarker = new squadMemberHTMLMarker(member.latitude, member.longitude, member.profile_picture_url, member.full_name);
         squadMemberMarker.setMap(map);
       });
    }
  }
})
