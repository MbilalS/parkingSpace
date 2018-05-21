<template>
    <div class="layout-padding">
        <div id="map" style="width: 100%; height: 275px; margin-bottom: 25px;"></div>
    </div>
</template>

<script>
import EventBus from "../event_bus";
import {
  QInput,
  QDatetime,
  QBtn,
  QItem,
  QItemSide,
  QItemMain,
  QIcon,
  QLayout,
  QTabs,
  QList,
  QCollapsible
} from "quasar";

export default {
  components: {
    QInput,
    QDatetime,
    QBtn,
    QItem,
    QItemSide,
    QItemMain,
    QIcon,
    QLayout,
    QTabs,
    QList,
    QCollapsible
  },

  data: function() {
    return {
      map: null,
      loc: { lat: "", lng: "" },
      geocoder: null,
      markers: [],
      polygons: [],
      icon: {
        url: "statics/geocode-71_.png",
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(30, 30)
      }
    };
  },
  props: ["spaces", "location", "destination"],
  methods: {
    redraw: function(spaces, map) {
      this.cleanPolygons();
      this.draw(spaces, map);
    },
    draw_space: function(spaces, index, map) {
      this.cleanPolygons();
      this.draw([spaces[index]], map);
    },
    draw: function(spaces, map) {
      spaces.forEach(space => {
        var polygon;
        switch (space.zone_name) {
          case "A":
            polygon = this.constructPolygon(space.coordinates, "red", map);
            break;
          case "B":
            polygon = this.constructPolygon(space.coordinates, "#105990", map);
            break;
          default:
            polygon = this.constructPolygon(space.coordinates, "#f65314", map);
        }
        polygon.setMap(map);
        this.polygons.push(polygon);
      });
    },
    // Construct the polygon.
    constructPolygon: function(paths, color, map) {
      return new google.maps.Polygon({
        paths: paths,
        strokeColor: color,
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: color,
        fillOpacity: 0.35,
        map: map
      });
    },
    cleanPolygons: function() {
      this.polygons.forEach(polygon => {
        polygon.setMap(null);
      });
      this.polygons = [];
    },
    cleanMarkers: function() {
      this.markers.forEach(marker => {
        marker.setMap(null);
      });
      this.markers = [];
    },
    addMarker(location, name) {
      // Create a marker for each place.
      this.markers.push(
        new google.maps.Marker({
          map: this.map,
          icon: this.icon,
          title: name,
          animation: google.maps.Animation.DROP,
          position: location
        })
      );
    }
  },
  mounted: function() {
    navigator.geolocation.getCurrentPosition(position => {
      // Ulikooli 18 Latitude: 58.3810948 | Longitude: 26.7199784
      this.loc.lng = position.coords.longitude;
      this.loc.lat = position.coords.latitude;
     // this.loc.lng = 26.7199784;
      //this.loc.lat = 58.3810948;
      this.map = new google.maps.Map(document.getElementById("map"), {
        zoom: 15,
        center: this.loc
      });
      this.addMarker(this.loc, "Current");
      this.geocoder = new google.maps.Geocoder();
      this.geocoder.geocode({ location: this.loc }, (results, status) => {
        if (status === "OK") {
          if (results[0]) {
            
            EventBus.$emit("start", this.loc);
          }
        }
      });

      EventBus.$on("page", page => {
        
        if (page != "Start") {
        var searchBox = new google.maps.places.SearchBox(
          document.getElementById("search_box")
        );

        searchBox.addListener("places_changed", () => {
          var places = searchBox.getPlaces();
          if (places.length == 0) {
            return;
          }
          // Clear out the old markers.
          this.cleanMarkers();

          // For each place, get the icon, name and location.
          var bounds = new google.maps.LatLngBounds();
          places.forEach(place => {
            if (!place.geometry) {
              console.log("Returned place contains no geometry");
              return;
            }

            // Create a marker for each place.
            this.addMarker(place.geometry.location, place.name);

            this.loc.lng = place.geometry.location.lng();
            this.loc.lat = place.geometry.location.lat();
            this.geocoder = new google.maps.Geocoder();
            this.geocoder.geocode({ location: this.loc }, (results, status) => {
              if (status === "OK") {
                if (results[0]) {
                  this.$emit(
                    "update:destination",
                    results[0].formatted_address
                  );
                   EventBus.$emit("destination", results[0].formatted_address);
                }
              }
            });

            this.$emit("update:location", this.loc);

            if (place.geometry.viewport) {
              // Only geocodes have viewport.
              bounds.union(place.geometry.viewport);
            } else {
              bounds.extend(place.geometry.location);
            }
          });
          this.map.fitBounds(bounds);
        });
      }
      
      });
      

      this.map.addListener("click", event => {
        var position = event.latLng;
        this.cleanMarkers();
        this.map.panTo(position);
        // Create a marker for each place.
        this.markers.push(
          new google.maps.Marker({
            map: this.map,
            icon: this.icon,
            animation: google.maps.Animation.DROP,
            position: position
          })
        );
        this.loc.lng = position.lng();
        this.loc.lat = position.lat();

        this.$emit("update:location", this.loc);
        this.geocoder = new google.maps.Geocoder();
        this.geocoder.geocode({ location: position }, (results, status) => {
          if (status === "OK") {
            if (results[0]) {
              this.$emit("update:destination", results[0].formatted_address);
            }
          }
        });
      });
      EventBus.$on("draw", spaces => {
        this.draw(spaces, this.map);
      });
      EventBus.$on("redraw", spaces => {
        this.redraw(spaces, this.map);
      });
      EventBus.$on("draw_space", (spaces, index) => {
        this.draw_space(spaces, index, this.map);
      });

      EventBus.$on("location", location => {
        this.loc = location;
        this.map = new google.maps.Map(document.getElementById("map"), {
          zoom: 15,
          center: this.loc
        });
        this.addMarker(this.loc, "Destination");
      });
    });
  }
};
</script>
<style>
.A i {
  color: red;
}
.B i {
  color: #105990;
}
.C,
.D i {
  color: #f65314;
}
</style>
