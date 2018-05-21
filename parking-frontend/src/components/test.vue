<template>
    
    <div>
        <q-item>
        <q-item-side icon="near me"/> 
        <q-item-main>
            <q-input :attributes="{id:'search_box'}" float-label="Destination" v-model="destination"/>
        </q-item-main>
        </q-item>
        <div id="map" style="width: 100%; height: 275px; margin-bottom: 25px;"> </div>

    </div>
</template>

<script>
import { QItem, QItemSide, QInput, QItemMain } from 'quasar'
export default {
    components: {
        QItem, QItemSide, QInput, QItemMain
    },
    data: function () {
        return {
            map: null,
            destination: ''
        }
    },
    mounted: () => {
        console.log('Here');
        navigator.geolocation.getCurrentPosition(position => {
            let loc = {lat: position.coords.latitude, lng: position.coords.longitude};
            this.map = new google.maps.Map(document.getElementById('map'), {zoom: 15, center: loc});
            

            // Create the search box and link it to the UI element.
            var input = document.getElementById('search_box');
            var searchBox = new google.maps.places.SearchBox(input);
            // this.map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

            var markers = [];
            // Listen for the event fired when the user selects a prediction and retrieve
            // more details for that place.
            searchBox.addListener('places_changed', () => {
                var places = searchBox.getPlaces();

                console.log('Places: ' + places.length);

                if (places.length == 0) {
                    return;
                }

                // Clear out the old markers.
                markers.forEach(function(marker) {
                    marker.setMap(null);
                });
                markers = [];

                // For each place, get the icon, name and location.
                var bounds = new google.maps.LatLngBounds();
                places.forEach((place) => {
                    if (!place.geometry) {
                        console.log("Returned place contains no geometry");
                        return;
                    }
                    var icon = {
                        url: place.icon,
                        size: new google.maps.Size(71, 71),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(17, 34),
                        scaledSize: new google.maps.Size(25, 25)
                    };

                    // Create a marker for each place.
                    markers.push(new google.maps.Marker({
                        map: this.map,
                        icon: icon,
                        title: place.name,
                        position: place.geometry.location
                    }));

                    if (place.geometry.viewport) {
                    // Only geocodes have viewport.
                    bounds.union(place.geometry.viewport);
                    } else {
                    bounds.extend(place.geometry.location);
                    }
                });
                
                this.map.fitBounds(bounds);
            });

        })
    }

}
</script>

<style>

</style>

