var chart
var has_focus=false;
var clicked=false;

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
			clicked = false;
		}
		has_focus = polarity;
	}

	gICAPI.onProperty = function(props) {
		title = eval("(" + props + ")");
	}

	gICAPI.onData = function( datastr ) {
//		alert('onData');
		if (datastr) {
//			alert('onData : ' + datastr);
//			data = eval("(" + datastr + ")");
			series = eval("(" + datastr + ")");
			clicked = true;
			gICAPI.SetFocus();
			createChart();
		}
	}
}

function createChart() {
	//alert('In createChart');

	chart = new Highcharts.Chart({
	chart: {
		renderTo: 'container_pie',
		plotBackgroundColor: null,
		plotBorderWidth: null,
		plotShadow: false,
		type: 'pie'
	},
	// title is from gICAPI.onProperty()
	title: title,
/*	title: {
		text: 'Title set in Java Script'
	},
*/
	tooltip: {
		pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	},
	plotOptions: {
		pie: {
			allowPointSelect: true,
			cursor: 'pointer',
			dataLabels: {
				enabled: true,
				format: '<b>{point.name}</b>: {point.percentage:.1f} %'
			}
		}
	},
	// series, including data, is from gICAPI.onData()
	series: series
/*
	series: [{
		name: 'Brands',
		colorByPoint: true,
		data: data
	}]
*/
	});
	//alert('chart created');
}
