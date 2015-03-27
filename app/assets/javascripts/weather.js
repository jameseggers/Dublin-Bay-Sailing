$(document).ready(function() {
	$.ajax({
	    type:    "GET",
	    url:     "data/tweet.json",
	    success: function(text) {
	    	//console.log(text);
	    	//var  obj = JSON.parse(text);
	    	var tweet = text.text;
	    	console.log("TRUE");
	        $("#weatherStuff").html(tweet)
	    },
	    error:   function() {
	    	console.log("FALSE");
	        $("#weatherStuff").html("Shit!");
	    }
	});
});