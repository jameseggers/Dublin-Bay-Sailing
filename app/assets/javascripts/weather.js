$.ajax({
    type:    "GET",
    url:     "data/tweet.json",
    success: function(text) {
    	var  obj = JSON.parse(text);
    	var tweet = obj.text;
        $("#weatherStuff").html(tweet)
    },
    error:   function() {
        $("#weatherStuff").html("Shit!");
    }
});