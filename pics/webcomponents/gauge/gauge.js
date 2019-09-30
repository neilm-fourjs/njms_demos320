var myProps
var has_focus=false;
var clicked=false;
var val1;

// This function is called by the Genero Client Container
// so the web component can initialize itself and initialize
// the gICAPI handlers
onICHostReady = function(version) {

	if ( version != 1.0 ) {
		alert('Invalid API version');
		return;
	}

	gICAPI.onFocus = function( polarity ) {
		if ( polarity && clicked ) {
			//alert('onFocus');
			clicked = false;
		}
		has_focus = polarity;
	}

	gICAPI.onProperty = function(props) {
		myProps = eval("(" + props + ")");
	}

	gICAPI.onData = function( data ) {
		point = chartSpeed.series[0].points[0];
		val1 = eval("(" + data + ")");;
		document.getElementById("debug").innerHTML="gicapi:"+val1+" point.y:"+point.y;
		point.y = val1;
		point.update(val1);
		clicked = true;
		gICAPI.SetFocus();
	}
}